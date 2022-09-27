function makeSinglePicPPT(pptName, PicFolder, PicPattern)
% MAKESIDEBYSIDEPPT(pptName, pathToPicFolder, leftPicPattern, rightPicPattern)
% 
% Finds pictures in PicFolder matching 'PicPattern' 
% and centers them in their own slides in a powerPoint presentation. If PicFolder
% has subfolders, this function looks for pictures in each subfolder. 
%
% INPUTS:
%   pptName: name of ppt (e.g. '~/Desktop/mySlides.pptx')
%   PicFolder: path to PicFolder OR toplevel folder containing multiple PicFolder subfolders
%   PicPattern: name pattern for pics (e.g. ptID*.png)
%
% OUTPUT: Creates a powerpoint "pptName" with one images per slide
%
% Example: makeSinglePicPPT('mySlides.pptx', myPtFolders/, 'HUP*interictal*.png')
%
% bscheid (bscheid@seas.upenn.edu) August 2022
%

import mlreportgen.ppt.*;

ptPaths = dir(PicFolder);
addpath(genpath(ptPaths(1).folder));            % Add all folders and subfolders to matlab path
ptPaths(startsWith({ptPaths.name}, '.')) = [];  % remove hidden folders

SLIDE_WIDTH = 13.5;
SLIDE_HEIGHT = 7.5;

% Check if pathToPicFolder has subfolders
subfolders = isfolder(fullfile({ptPaths.folder}, {ptPaths.name}));
if sum(subfolders) == 0 
    ptPaths = ptPaths(1); ptPaths.name = '.';  
end

ppt = Presentation(pptName);

for i_pt = 1:length(ptPaths)

    disp(ptPaths(i_pt).name)
    pics = dir(fullfile(ptPaths(i_pt).folder, ptPaths(i_pt).name, PicPattern));
    
    if  length(pics) == 0
        fprintf('did not find matching pics for %s, skipping \n', ptPaths(i_pt).name)
        continue
    end

    for i = 1:length(pics)
    
        pictureSlide = add(ppt,'Blank');
        
        lPic = Picture(which(fullfile(pics(i).name)));

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
        
    
    end

end

disp('saving and closing ppt, this may take a minute...')
close(ppt);


