function batch_filelist_formatted = DAG_get_batch_input_from_xls(run_by_run_filelist_formatted,Inputsequal,Keys,drive,monkey)
%batch_filelist_formatted = get_batch_input_from_xls_20140903(analysis_parameters.filelist_formatted,{'Session','Electrode_depth','Aim','Current_strength'},{})
batch_filelist_formatted={};

switch monkey
    case 'Linus'
        path= strcat(drive,':', filesep,'Data', filesep, monkey, '_microstim_with_parameters', filesep);
        data=[drive,':', filesep,'Projects', filesep,'Pulv_microstim_behavior', filesep,'behavior',filesep,  monkey, '_summaries', filesep, monkey, '_updated_parameters.xls'];
    case 'Curius'
        path= strcat(drive,':', filesep,'Data', filesep, monkey, '_microstim_with_parameters', filesep);
        data=[drive,':', filesep,'Projects', filesep,'Pulv_microstim_behavior', filesep,'behavior',filesep,   monkey, '_summaries', filesep, monkey, '_updated_parameters.xls'];
    case 'Cornelius'
        path= strcat(drive, 'Data', filesep, monkey, filesep);
        data=[drive, 'Protocols', filesep, monkey, filesep, monkey, '_protocol.xls'];
        %data=[pwd, filesep, monkey, '_protocol.xls'];
            case 'Cornelius_ina'
        path= strcat(drive, 'Data', filesep, monkey, filesep);
        data=[drive, 'Protocols', filesep, monkey, filesep, monkey, '_protocol.xls'];
        %data=[pwd, filesep, monkey, '_protocol.xls'];
end

[num,masterstring_orig,RAW_orig] = xlsread(data,'mastertable');
masternum_orig=[NaN(1,size(num,2));num];

idx_Session=DAG_find_column_index(masterstring_orig,'Session');
idx_Run=DAG_find_column_index(masterstring_orig,'Run');
masternum=NaN([1,size(masternum_orig,2)]);
RAW=cell([1,size(RAW_orig,2)]);
masterstring=cell([1,size(masterstring_orig,2)]);
for new_row_index = 1:size(run_by_run_filelist_formatted,1)
    old_row_index   = strcmp(strcat(path,num2str(masternum_orig(:,idx_Session))),run_by_run_filelist_formatted(new_row_index,1)) ...
                    & masternum_orig(:,idx_Run)==run_by_run_filelist_formatted{new_row_index,2};
    masternum(new_row_index,:)=masternum_orig(old_row_index,:);
    RAW(new_row_index,:)=RAW_orig(old_row_index,:);
    masterstring(new_row_index,:)=masterstring_orig(old_row_index,:);
end

Selection_matrix=true(1,size(masternum,1));
for equalidx=1:size(Inputsequal,2)
    idx.(Inputsequal{equalidx})=DAG_find_column_index(masterstring_orig,Inputsequal{equalidx});
    current_equal_entries = [RAW(:,idx.(Inputsequal{equalidx}))];
    cumulative_counter=0;
    batchidx=0;
    Previous_selection_matrix=Selection_matrix;
    
    for cumulative_batch_index=1:size(Previous_selection_matrix,1)
        cumulative_counter=cumulative_counter+batchidx;
        if all(cellfun(@ischar,current_equal_entries)) % this might be critical, if the first row does not have the correct format.....
            current_equal_entries = [masterstring(Previous_selection_matrix(cumulative_batch_index,:),idx.(Inputsequal{equalidx}))];
            unique_equal_entries=unique(current_equal_entries);
            for batchidx = 1:numel(unique_equal_entries)
                Selection_matrix(batchidx+cumulative_counter,:)=strcmp([RAW(:,idx.(Inputsequal{equalidx}))]',unique_equal_entries{batchidx})...
                    & Previous_selection_matrix(cumulative_batch_index,:);
            end
        else
            all_unique_equal_entries=unique(masternum(Previous_selection_matrix(cumulative_batch_index,:),idx.(Inputsequal{equalidx})));
            unique_equal_entries=all_unique_equal_entries(~isnan(all_unique_equal_entries));
            for batchidx = 1:numel(unique_equal_entries)
                Selection_matrix(batchidx+cumulative_counter,:)=masternum(:,idx.(Inputsequal{equalidx}))'==unique_equal_entries(batchidx)...
                    & Previous_selection_matrix(cumulative_batch_index,:) ;
            end
            if any(isnan(all_unique_equal_entries))
               batchidx= numel(unique_equal_entries)+1;
               Selection_matrix(batchidx+cumulative_counter,:)=isnan(masternum(:,idx.(Inputsequal{equalidx}))') & Previous_selection_matrix(cumulative_batch_index,:) ;
            end
        end
    end
end

 for batch_idx = 1: size(Selection_matrix,1) 
     if ~isempty(run_by_run_filelist_formatted)
     current_batch_files=run_by_run_filelist_formatted(Selection_matrix(batch_idx,:)',:);
     batch_filelist_formatted{batch_idx}=current_batch_files;
%      batch_filelist_formatted{batch_idx*2-1}=current_batch_files;
%      batch_filelist_formatted{batch_idx*2}=Keys;
     end
 end
 
end

function column_index=DAG_find_column_index(inputcell,title)
for m=1:size(inputcell,2)
    if strcmp(inputcell{1,m},title)
        column_index=m;
    end
end
end