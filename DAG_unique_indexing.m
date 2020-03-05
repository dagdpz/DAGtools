function [indexed, N_uniquedata, N_data]= DAG_unique_indexing(Data)

% 20151216
% provides indexes according to the first appearance (NOT sorted)
% Works for numeric and string vectors, 

[~,A,B]=unique(Data,'first');
[~,C]=sort(Data(sort(A)));
indexed=C(B);

N_uniquedata=max(indexed);
N_data=size(Data,1);
end