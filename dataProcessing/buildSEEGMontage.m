function [chan_montage, num_montage] = buildSEEGMontage(channels)

%%
v = regexp(channels,'([\D]+)([\d.]+)','tokens');
v = vertcat(v{:}); v= vertcat(v{:}); % un-nest

[ch_groups, ch_names] = findgroups(v(:,1)); 
ch_nums = arrayfun(@str2num, (string(v(:,2))));

mntg = splitapply(@(x){sorting(x)}, ch_nums, ch_groups);

lmntg = find(cellfun(@length, mntg) > 20);

if length(lmntg) > 2, warning('two grids detected'); end

for i_grid = 1:length(lmntg)

    grid = mntg{lmntg(i_grid)}; 
    grid_width = round(length(grid)/8); 

    onEnd = [8:8:(grid_width-1)*8];

    Lend = ismember(grid(:,1), string(onEnd));
    Rend = ismember(grid(:,2), string(onEnd+1));

    toRemove = Lend & Rend;
    mntg{lmntg(i_grid)} = grid(~toRemove,:);

end

ch_names(cellfun(@isempty, mntg)) = [];
mntg(cellfun(@isempty, mntg)) = [];

montage_names = arrayfun(@(x){strcat(ch_names{x}, mntg{x})}, [1:length(mntg)]');
chan_montage = vertcat(montage_names{:});

[~, src] = ismember(chan_montage(:,1), channels);
[~, targ] = ismember(chan_montage(:,2), channels);
num_montage = [src, targ];

end

%%
function out = sorting(chan_numbers)
    chan_numbers = chan_numbers(:);
    ch = sort(chan_numbers); 
    ch_pairs = [ch(1:end-1), ch(2:end)];
    to_rm = ch(1:end-1) + 1 ~= ch(2:end);
    ch_pairs(to_rm,:) = [];

    if isempty(ch_pairs)
        out = [];
    else
        out = [(sprintfc('%d', ch_pairs(:,1))), (sprintfc('%d', ch_pairs(:,2)))];
    end
end