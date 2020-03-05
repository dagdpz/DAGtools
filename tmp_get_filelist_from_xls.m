function filelist_formatted = tmp_get_filelist_from_xls(Aiminput,Inputsequal,Inputsrange,Inputslist,drive,monkey) %Inputslist
filelist_formatted=[];
% Aiminput={'use_dir_sti_at_go';'use_map'};
% Inputsequal={'gridhole_x',0;'task_type',2};
% Inputsrange={'hits',50,3000;'Current_strength',35,300;'microstim_percentage',30,80;'Electrode_depth',40,46};
% monkey='Linus';

drive=dag_drive_IP=DAG_get_server_IP
switch monkey
    case 'Linus'
        path= strcat(drive,':', filesep,'Data', filesep, monkey, '_microstim_with_parameters', filesep);
        data=[drive,':', filesep,'Projects', filesep,'Pulv_microstim_behavior', filesep,'behavior',filesep,  monkey, '_summaries', filesep, monkey, '_updated_parameters.xls'];
    case 'Curius'
        path= strcat(drive,':', filesep,'Data', filesep, monkey, '_microstim_with_parameters', filesep);
        data=[drive,':', filesep,'Projects', filesep,'Pulv_microstim_behavior', filesep,'behavior',filesep,  monkey, '_summaries', filesep, monkey, '_updated_parameters.xls'];
end


[num,masterstring,~] = xlsread(data,'mastertable');

masternum=[NaN(1,size(num,2));num];

idx_Session=DAG_find_column_index(masterstring,'Session');
idx_Run=DAG_find_column_index(masterstring,'Run');
idx_Task_Aim=DAG_find_column_index(masterstring,'Aim');

log_sel_aim_idx=ones(1,size(masternum,1));
log_sel_equ_idx=ones(1,size(masternum,1));
log_sel_lower_ran_idx=ones(1,size(masternum,1));
log_sel_upper_ran_idx=ones(1,size(masternum,1));
log_sel_list_idx=ones(1,size(masternum,1));

for aimidx=1:size(Aiminput,1)
   log_sel_aim_idx_cell=strfind([masterstring(:,idx_Task_Aim)],Aiminput{aimidx,1});
   log_sel_aim_idx(aimidx,:) = ~cellfun('isempty',log_sel_aim_idx_cell);   
end

for equalidx=1:size(Inputsequal,1)
   idx.(Inputsequal{equalidx,1})=DAG_find_column_index(masterstring,Inputsequal{equalidx,1});
   if ischar(Inputsequal{equalidx,2})
       log_sel_equ_idx_cell=strfind([masterstring(:,idx.(Inputsequal{equalidx,1}))],Inputsequal{equalidx,2});
       log_sel_equ_idx(equalidx,:) = ~cellfun('isempty',log_sel_equ_idx_cell);
   else
   log_sel_equ_idx(equalidx,:)=masternum(:,idx.(Inputsequal{equalidx,1}))==Inputsequal{equalidx,2};
   end
end

for ranidx=1:size(Inputsrange,1)
   idx.(Inputsrange{ranidx,1})=DAG_find_column_index(masterstring,Inputsrange{ranidx,1});
   log_sel_lower_ran_idx(ranidx,:)=masternum(:,idx.(Inputsrange{ranidx,1}))>=Inputsrange{ranidx,2};
   log_sel_upper_ran_idx(ranidx,:)=masternum(:,idx.(Inputsrange{ranidx,1}))<=Inputsrange{ranidx,3};
end

if ~isempty(Inputslist)
    for listidx=1:size(Inputslist,2)
        values_to_be_present=[Inputslist{listidx}{2:end}];
        idx.(Inputslist{listidx}{1})=DAG_find_column_index(masterstring,Inputslist{listidx}{1});
        log_sel_list_idx(listidx,:) = cell2mat(cellfun(@(x) isempty(setxor(str2num(x),values_to_be_present)), masterstring(:,idx.(Inputslist{listidx}{1})), 'UniformOutput', false))';
    end
end

Sel_all=any(log_sel_aim_idx,1)&all(log_sel_equ_idx,1)&all(log_sel_lower_ran_idx,1)&all(log_sel_upper_ran_idx,1)&all(log_sel_list_idx,1);

new_idx=1;
 for master_idx = 1: size(masternum,1) %length(raw(:,1))

     if  Sel_all(master_idx)    
        cell_path{new_idx}      = path;
        cell_session{new_idx}   = masternum(master_idx,idx_Session);
        cell_run{new_idx}       = masternum(master_idx,idx_Run);
        filelist_formatted{new_idx,1} = [cell_path{new_idx}, num2str(cell_session{new_idx})];
        filelist_formatted{new_idx,2} = cell_run{new_idx};
        new_idx = new_idx +1;
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