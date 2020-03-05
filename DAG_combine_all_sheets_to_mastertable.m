function DAG_combine_all_sheets_to_mastertable(filename,column_to_sort)
[~, sheets]=xlsfinfo(filename);
sheets=sheets(~ismember(sheets,'Mastertable'));
mastertable={column_to_sort};
for s=1:numel(sheets)    
[~, ~, data]=xlsread(filename,sheets{s});
[mastertable]=DAG_update_cell_table(data,mastertable,column_to_sort);
end
xlswrite(filename,mastertable,'Mastertable')

end