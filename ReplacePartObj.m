function list = ReplacePartObj(list, Obj)
% function list = ReplacePartObj(list, Obj)
%
% Replace elements in the list of partitions of the standard set {1:N}
% by a elements specified in Obj
%
% LIST must be the result as returned by SetPartition(N, ...), N is an
% integer, and Obj is an array or cell array of N elements
%
% See also SetPartition, DispPartObj
%
% Author: Bruno Luong <brunoluong@yahoo.com>
% History
%   Original: 23-May-2003
%   02-Jun-2009: comments change

for k=1:size(list,1)
    lk = list{k};
    for l=1:size(lk,2)
        lk{l} = Obj(lk{l});
    end
    list{k} = lk;
end