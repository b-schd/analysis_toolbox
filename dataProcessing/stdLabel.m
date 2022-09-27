function str_list = stdLabel(str_list) % Standardize labels on ieeg
    
        %Remove leading zero
        mtch = regexp(string(str_list), '(0[0-9]+)', 'Match');
        for i_m = 1:length(mtch)
            if ~isempty(mtch{i_m})
                str_list{i_m}= regexprep(str_list{i_m}, '(0[0-9]*)', regexp(str_list{i_m}, '([1-9]+0*)', 'Match'));
            end
        end
        
        % Remove EEG, -Ref, and spaces
        str_list = replace(str_list, {'EEG', '-Ref', ' '}, '');
end