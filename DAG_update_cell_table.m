function [complete_mastertable]=DAG_update_cell_table(old_table,new_table,column_to_sort)

%column_to_sort='Session';
idx1=DAG_find_column_index(new_table,column_to_sort);
idx2=DAG_find_column_index(old_table,column_to_sort);
array_to_look_for=[new_table{2:end,idx1}];
input_array=[old_table{2:end,idx2}];

previous_date=0;
current_date_counter=0;
numindex=0;
row_exists_already=[];
for k=1:length(array_to_look_for)
    
    if previous_date~=array_to_look_for(k)
        %new date!
        % 1) restart counter for current date
        % 2) get row indexes of this date in input_array
        current_date_counter=1;
        current_date_numindex=find(input_array==array_to_look_for(k));
    else
        % still the same date --> increase date counter
        current_date_counter=current_date_counter+1;
    end
    % check if the currently processed row of array_to_look_for already exists in input_array
    row_exists_already(k)=ismember(array_to_look_for(k),input_array) ...
        && current_date_counter<=sum(input_array==array_to_look_for(k));
    if row_exists_already(k)
        % numindex tells us in which row of input_array to find the rows in array_to_look_for
        numindex(k)=current_date_numindex(current_date_counter);
    else
        % currently processed row of array_to_look_for doesnt exist yet in input_array
        current_date_numindex=find(input_array>array_to_look_for(k));
        if isempty(current_date_numindex)
            % for appending dates
            numindex(k)=NaN;
        else
            numindex(k)=current_date_numindex(1);
            % for squeezing in dates: IMPORTANT: only works in combination with row_exists_already==0 !!
        end
    end
    previous_date=array_to_look_for(k);
end




numindex=numindex+1;
%insert_counter=0;
old_table2=old_table;
new_table2=cell(size(old_table,1),size(new_table,2));
new_table2(1,:)=new_table(1,:);
old_table2(1,:)=old_table(1,:);
rows_to_update=[];
for idx=1:numel(row_exists_already)
    if row_exists_already(idx)
        new_table2(numindex(idx),:)=new_table(idx+1,:);
        rows_to_update=[rows_to_update numindex(idx)]; %%%
    else
        if isnan(numindex(idx))
            new_table2(end+1,:)=new_table(idx+1,:);
            old_table2(end+1,:)=num2cell(zeros(1,size(old_table,2)));
            rows_to_update=[rows_to_update size(new_table2,1)];
        else
            new_table2=[new_table2(1:numindex(idx)-1,:); new_table(idx+1,:);           new_table2(numindex(idx):end,:)];
            old_table2=[old_table2(1:numindex(idx)-1,:); num2cell(zeros(1,size(old_table,2))); old_table2(numindex(idx):end,:)];
            rows_to_update=[rows_to_update numindex(idx)]; %%%
            numindex=numindex+1;
            %insert_counter=insert_counter+1;
        end
    end
end
complete_mastertable=DAG_update_mastertable_cell(old_table2,new_table2,rows_to_update);

end