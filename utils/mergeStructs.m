function s = mergeStructs(structList, varargin)

% Usage: 
% s = mergestructs(structList);  % merge only fields that overlap in all structs
% options: 
    % 'fieldnames' - Create struct with fieldnames in "fieldnames". Will
    % include fieldname even if field does not exist in all structs
    
    % 'inclusive' - Will include all fieldnames in all structs, padding
    % where information is missing. 


% Default, merge only similar columns in s1 and s2 
% options: 
% 'fieldNames': merge field names

fN = [];
incl = 0;

if ~isa(structList, 'cell'), error('Expecting cell array as first argument'); end

for i =1:length(varargin)
    if isa(varargin{i}, 'char')
        switch varargin{i}
            case 'fieldnames'
                fN = varargin{i+1};
            case 'inclusive'
                incl= 1; 
        end
    end
end

% Get struct fieldnames
if incl == 0  % non-inclusive, only get intersection. 
    if ~isempty(fN), strNames = fN;
    else strNames = unique(fieldnames(structList{1})');
    end  
    for i_st = 1:length(structList)
        strNames= intersect(fieldnames(structList{i_st}), strNames);
    end
elseif ~isempty(fN), strNames = fN(:); % inclusive, get all specified fieldnames
else % inclusive, get all fieldnames
    allNames = cellfun(@fieldnames, structList, 'UniformOutput', false);
    strNames = unique(vertcat(allNames{:}));
end
    
    
%% Combine Structs
        
s= struct();
for f= strNames'
    ctr = 0;     
    for i_st = 1:length(structList)
        len = length(structList{i_st});
        if ismember(f{1}, fieldnames(structList{i_st}))
            for l = 1:len
                s(ctr+l).(f{1})= structList{i_st}(l).(f{1});
            end
            ctr = ctr + len;
        else
            [s(ctr+[1:len]).(f{1})] = deal([]);
            ctr = ctr+len;
        end 
    end

end