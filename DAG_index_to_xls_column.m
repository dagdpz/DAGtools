function [xlsind]=DAG_index_to_xls_column(cellind_row, cellind_col)
%converts cellindex to excel index
%for example:  (2,3) -> C2 
% input:
%     cellind_row=2
%     cellind_col=3
% output:
%     xlsind='C2'

% modified: Danial
% 20140708
%%
APH=['A':'Z'];

Excelcols=[];
colindx_dyn=cellind_col;
while true
    counter=mod(colindx_dyn-1,26)+1;
    Excelcols=[Excelcols APH(counter)];
    if 26>=colindx_dyn
        break
    end
    colindx_dyn=ceil((colindx_dyn-counter)/26);    
end
Excelcols=fliplr(Excelcols);

xlsind= [Excelcols num2str(cellind_row)];
end

