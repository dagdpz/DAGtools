function DAG_create_mastertable_sheet(excel_file)


[~,parametersheets] = xlsfinfo(excel_file);
sheet_counter=0;
complete_mastertable={};
for k=1:numel(parametersheets)
    if isempty (str2num(parametersheets{k}))
            continue
    else
        sheet_counter=sheet_counter+1;   
    end    
    [~,~,parameter_table] = xlsread(excel_file,parametersheets{k});
    row_counter=size(complete_mastertable,1);
    n_rows=size(parameter_table,1)-1;
    if sheet_counter==1
        complete_mastertable=parameter_table;        
    else        
        table_for_updating=[parameter_table(1,:); cell(row_counter-1,size(parameter_table,2)); parameter_table(2:end,:)];
        complete_mastertable = DAG_update_mastertable_cell(complete_mastertable,table_for_updating,[row_counter+1:row_counter+n_rows]);
    end
    
end


if size(complete_mastertable,2)>255
   complete_mastertable=complete_mastertable(:,1:255);
   disp('mastertable has too many columns, size has been reduced to 255 columns')
end
xlswrite(excel_file,complete_mastertable,'mastertable');