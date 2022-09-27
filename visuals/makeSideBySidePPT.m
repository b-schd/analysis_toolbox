function makeSideBySidePPT(pptName, PicFolder, leftPicPattern, rightPicPattern)
% MAKESIDEBYSIDEPPT(pptName, pathToPicFolder, leftPicPattern, rightPicPattern)
% 
% Finds pairs of pictures in PicFolder matching 'leftPicPattern' and 'rightPicPattern'
% and places them side by side in a powerPoint presentation. If PicFolder
% has subfolders, this function looks for pairs of pictures in each
% subfolder. 
%
% INPUTS:
%   pptName: name of ppt (e.g. '~/Desktop/mySlides.pptx')
%   PicFolder: path to PicFolder OR toplevel folder containing multiple PicFolder subfolders
%   leftPicPattern: name pattern for left pics (e.g. ptID*_left_foot.png)
%   rightPicPattern: name pattern for left pics  (e.g. ptID*_right_foot.png)
%
% OUTPUT: Creates a powerpoint "pptName" with left/right images
%
% Example: makeSideBySidePPT('mySlides.pptx', myPtFolders/, 'HUP*interictal*.png', 'HUP*-ictal_clip*.png')
%
% bscheid (bscheid@seas.upenn.edu) August 2022
%

import mlreportgen.ppt.*;

ptPaths = dir(PicFolder);
addpath(genpath(ptPaths(1).folder));            % Add all folders and subfolders to matlab path
ptPaths(startsWith({ptPaths.name}, '.')) = [];  % remove hidden folders

SLIDE_WIDTH = 6.5;
SLIDE_HEIGHT = 7.5;

% Check if pathToPicFolder has subfolders
subfolders = isfolder(fullfile({ptPaths.folder}, {ptPaths.name}));
if sum(subfolders) == 0 
    ptPaths = ptPaths(1); ptPaths.name = '.';  
end

ppt = Presentation(pptName);

for i_pt = 1:length(ptPaths)

    disp(ptPaths(i_pt).name)
    lPics = dir(fullfile(ptPaths(i_pt).folder, ptPaths(i_pt).name, leftPicPattern));
    rPics = dir(fullfile(ptPaths(i_pt).folder, ptPaths(i_pt).name, rightPicPattern));
    
    disp(length(lPics))
    disp({lPics.name}')
     disp(length(rPics))
    disp({rPics.name}')
    
    if length(lPics) ~= length(rPics) || isempty(lPics)
        fprintf('did not find matched pairs for %s, skipping \n', ptPaths(i_pt).name)
        continue
    end

    for i = 1:length(lPics)
    
        pictureSlide = add(ppt,'Blank');
        
        % Center Left Image on Left Side
        lPic = Picture(which(fullfile(lPics(i).name)));
        dims = regexp(string([lPic.Width, lPic.Height]), '(\d*)px', 'tokens');
        dims = cellfun(@str2num, dims);
        if dims(1)/dims(2) > SLIDE_WIDTH /SLIDE_HEIGHT
            Width = SLIDE_WIDTH ;
            Height = SLIDE_WIDTH * dims(2)/dims(1);
        else
            Height = SLIDE_HEIGHT;
            Width = SLIDE_HEIGHT * dims(1)/dims(2);
        end

        % Center image on page
        lPic.Width = sprintf('%0.2fin', Width);
        lPic.Height = sprintf('%0.2fin', Height);
        lPic.X= sprintf('%0.2fin', (SLIDE_WIDTH  - Width)/2);
        lPic.Y= sprintf('%0.2fin', (SLIDE_HEIGHT - Height)/2);
        
        add(pictureSlide,lPic);
        
        % Center Right Image on Right Side
        rPic = Picture(which(fullfile(rPics(i).name)));
        dims = regexp(string([rPic.Width, rPic.Height]), '(\d*)px', 'tokens');
        dims = cellfun(@str2num, dims);
        if dims(1)/dims(2) > SLIDE_WIDTH /SLIDE_HEIGHT
            Width = SLIDE_WIDTH ;
            Height = SLIDE_WIDTH * dims(2)/dims(1);
        else
            Height = SLIDE_HEIGHT;
            Width = SLIDE_HEIGHT * dims(1)/dims(2);
        end

        rPic.Width = sprintf('%0.2fin', Width);
        rPic.Height = sprintf('%0.2fin', Height);
        rPic.X= sprintf('%0.2fin', SLIDE_WIDTH + (SLIDE_WIDTH  - Width)/2);
        rPic.Y= sprintf('%0.2fin', (SLIDE_HEIGHT - Height)/2);
        add(pictureSlide,rPic);
    
    end

end

disp('saving and closing ppt, this may take a minute...')
close(ppt);


