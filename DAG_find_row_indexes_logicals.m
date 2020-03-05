function [logidx,numindex]=DAG_find_row_indexes_logicals(array_to_look_for,input_array)
current_date=0;
current_date_counter=0;
for k=1:length(array_to_look_for)
    if current_date~=array_to_look_for(k) %new date, restart counter
       current_date_counter=1; 
    end    
    logidx(k)=ismember(array_to_look_for(k),input_array(:,1)) && current_date_counter<sum(input_array(:,1)==array_to_look_for(k));
    if logidx(k)
        if current_date~=array_to_look_for(k) % find all runs run of new date
            current_date_numindex=find(input_array(:,1)==array_to_look_for(k));
        else                                  % increase date counter
            current_date_counter=current_date_counter+1;
        end
        numindex(k)=current_date_numindex(current_date_counter);
    else
        current_date_numindex=find(input_array(:,1)>array_to_look_for(k));
        if isempty(current_date_numindex) %% for appending dates
            numindex(k)=NaN;
        else
            numindex(k)=current_date_numindex(1); %% for squeezing in dates: IMPORTANT: only works in combination with logidx==0 !!
        end
    end
    current_date=array_to_look_for(k);
end
end