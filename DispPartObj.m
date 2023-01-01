function DispPartObj(list, Obj, options)
% function list = DispPartObj(list)
%
% Display elements in the list of partitions as returned by SetPartition(...)
%
% VARIATIONS
%   If p is the list of partitions from the set {1,2,...,N} (as returned by
%   calling SetPartition(N,...)), user can replace set elements (numbers)
%   by providing an object (cell) array OBJ: DispPartObj(list, Obj).
%   Example:
%       > p=SetPartition(4);
%       > DispPartObj(p, {'dog' 'cat' 'orange' 'apple'});
%       > DispPartObj(p, [pi exp(1) sqrt(2) Inf]);
%
% > DispPartObj(..., options); % optional display formatting.
%   options is structure with following fields fo strings (excepted FID):
%       'header': header displayed before the list. The default header is
%           'The N partition(s) are:'
%           Set to 'none' to not display the header.
%       'partindent': indentation displayed before a partition: '\t'
%       'leftbracket' 'rightbracket': bracket of a set: '{' '}'
%       'setsep': subset separator: ' '
%       'elesep': elements separator: ' '
%       'fid': is an integer file identifier obtained from FOPEN, or 1 for
%        standard output (default).
%   Example:
%       > p=SetPartition(4);
%       > DispPartObj(p, [], struct('elesep',',','setsep',' + '));
%
% See also SetPartition, ReplacePartObj
%
% Author: Bruno Luong <brunoluong@yahoo.com>, followed an idea from
%         Matt Fig
% History
%   Original: 02-Jun-2009
%   24-Oct-2009: Correct formating of cell of numeric

% Number of partitions
m = size(list,1);
if m>0
    % Number of elements of the set
    n = 0;
    % use for-loop instead of cellfun for backward compatibility
    for j=1:length(list{1})
        n = n + length(list{1}{j});
    end
end

% no option by default
if nargin<3 || isempty(options)
    options = struct();
end

% Get the values of options, set to default values if they are not provided
fid = getoptions(options, 'fid', 1);
partindent = getoptions(options, 'partindent', '\t');
leftbracket = getoptions(options, 'leftbracket', '{');
rightbracket = getoptions(options, 'rightbracket', '}');
setsep = getoptions(options, 'setsep', ' ');
elesep = getoptions(options, 'elesep', ' ');

fmtele = '%d';
if  nargin>=2 && ~isempty(Obj)
    if numel(Obj)<n
        error('DispPartObj: Obj must have %d elements', n);
    end
    ObjReplaced = 1; % replace Objects
    fmtele = '%s';
    if ~iscell(Obj)
        Obj = num2cell(Obj);
    end
    % Convert to the cell strings if Objects is provided by user
    for k=n:-1:1
        ObjStr{k} = num2str(Obj{k});
    end % for-loop instead of cell-fun
else % No replacing, display the original elements
    ObjStr = [];
    oneele = list{1}{1};
    if m>0 && n>0 && iscell(oneele)
        if ischar(oneele{1})
            fmtele = '%s';
        else
            fmtele = '%d';
        end
        ObjReplaced = 2; % cell objects
    else
        ObjReplaced = 3; % array objects
    end
end

fmtele = [fmtele elesep];
fmtset = [leftbracket '%s' rightbracket];

defheader = sprintf('The %d partition(s) are:', m);
header = getoptions(options, 'header', defheader);

if ~strcmpi(header,'none')
    fprintf(fid, '%s\n', header);
end
% Loop on all partitions
for i=1:m
    fprintf(fid, partindent);
    l = length(list{i});
    % loop on subsets
    for j=1:l
        switch ObjReplaced
            case 1 % replace Objects
                subset = sprintf(fmtele, ObjStr{list{i}{j}});
            case 2 % cell objects
                subset = sprintf(fmtele, list{i}{j}{:});
            otherwise % ==3, array objects
                subset = sprintf(fmtele, list{i}{j});
        end
        subset(end-length(elesep)+1:end)=[];
        subset = sprintf(fmtset, subset);
        if j<l % Not set separator for the last set
            subset = sprintf('%s%s', subset, setsep);
        end
        fprintf(fid,'%s', subset);
    end
    fprintf(fid,'\n'); % carried return, new partition
end

end % DispPartObj

% Get the options fieldname, if not exists return the default value
function opt = getoptions(options, field, default)
    field = lower(field);
    if isfield(options, field)
        opt = options.(field);
    else
        opt = default;
    end
end % getoptions
