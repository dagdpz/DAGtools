function output_cell=DAG_keep_only_numeric_cell_entries(original_cell)
% to reduce a cell to only contain numbers (AND ONLY if they are strings)

logidx=false(size(original_cell,1),size(original_cell,2));
for idx=1:numel(original_cell)
    if isnan(str2double(original_cell{idx}))
        logidx(idx)=false;
    else
        logidx(idx)=true;
    end
end
output_cell=original_cell(logidx);
end
