function [mastertable,out_comp]=DAG_get_trialinfo_mastertable(varargin)
global analysis_parameters
current_date            =datestr(date,'yyyymmdd');

if numel(varargin)==0
    monkey                   =analysis_parameters.monkey;
%    monkeypsych_analyze      =analysis_parameters.files.monkeypsych_analyze;
    filelist_formatted       =analysis_parameters.filelist_formatted;
    working_directory        =analysis_parameters.folders.output;
    dates                    =analysis_parameters.dates;
    batch_list_rearranged    =analysis_parameters.batch_list_rearranged;
else
    %to be added....
    if numel(varargin)>0
        monkey=varargin{1};
    end
    if numel(varargin)>1
        filelist_formatted=varargin{2};
    end
    if numel(varargin)>2
        working_directory=varargin{3};
    end
    if numel(varargin)>3
        monkeypsych_analyze=varargin{4};
    end
    if numel(varargin)>4
        dates=varargin{5};
    end    
    batch_list_rearranged    =0;
end
if batch_list_rearranged
    Sel_all={'display',0};
    sel_array=repmat({Sel_all},1,size(filelist_formatted,2));
    Analyze_input=[filelist_formatted;sel_array];    
    [out_comp,~,~]= monkeypsych_analyze_working(Analyze_input{:});
    filelist_re_formatted(:,1)=cellfun(@(x) x{1,1},filelist_formatted,'UniformOutput',0);
    filelist_re_formatted(:,2)=cellfun(@(x) [x{:,2}],filelist_formatted,'UniformOutput',0);
else    
Sel_all={'display',0,'runs_as_batches',1};
[out_comp,~,~]= monkeypsych_analyze_working(filelist_formatted,Sel_all);
filelist_re_formatted=filelist_formatted;
end
trialinfo = DAG_most_recent_version(working_directory,strcat(monkey, '_trialinfo_mastertable'));

table_for_updating(1,:)={'Session','Run','total_trials','hits','hits_t_2_e_0','hits_t_2_e_4','task_type','task_effector','reach_hand','x_positions','y_positions','choice_percentage','microstim_percentage','microstim_start', 'microstim_state', 'percentage_left_chosen_stimulated', 'percentage_left_chosen_baseline', 'RT_R_mean_stimulated', 'RT_R_std_stimulated',...
    'RT_L_mean_stimulated', 'RT_L_std_stimulated', 'RT_R_mean_baseline', 'RT_R_std_baseline', 'RT_L_mean_baseline', 'RT_L_std_baseline', 'min_time_fix_hold','max_time_fix_hold'};

if isempty(trialinfo)
    shift_rows=0;
    original_table=table_for_updating;
else
    load(trialinfo,'mastertable');
    original_table=mastertable;
    title_index=DAG_find_column_index(original_table,'Session');
    if all([original_table{2:end,title_index}] >= dates(1)) % ignore_not_matching_dates
        shift_rows=0;
        original_table=table_for_updating;
    else
        pot_run_files_start=find([original_table{2:end,title_index}]==dates(1));
        if ~isempty(pot_run_files_start)
            shift_rows=pot_run_files_start(1)-1;
        else
            shift_rows=size(original_table,1)-1;
        end
    end
end

for k=1:numel(out_comp)
    n_trials(k) = numel(out_comp{k}.binary);
    hits(k) = sum([out_comp{k}.binary.success]);
    hits_t_2_e_0(k) = sum([out_comp{k}.binary.success] & [out_comp{k}.task.effector]==0 & [out_comp{k}.task.type]==2);
    hits_t_2_e_4(k) = sum([out_comp{k}.binary.success] & [out_comp{k}.task.effector]==4 & [out_comp{k}.task.type]==2);
    type{k,:}            = unique([out_comp{k}.task.type]);
    effector{k,:}        = unique([out_comp{k}.task.effector]);
    reach_hand{k,:}      = unique([out_comp{k}.reaches(~isnan([out_comp{k}.reaches().reach_hand])).reach_hand]);
    x_positions{k,:}     = round(real(unique([out_comp{k}.saccades(~isnan(real([out_comp{k}.saccades.tar_pos]))).tar_pos, out_comp{k}.reaches(~isnan(real([out_comp{k}.reaches.tar_pos]))).tar_pos])));
    y_positions{k,:}     = round(imag(unique([out_comp{k}.saccades(~isnan(real([out_comp{k}.saccades.tar_pos]))).tar_pos, out_comp{k}.reaches(~isnan(real([out_comp{k}.reaches.tar_pos]))).tar_pos])));
    
    choice_percentage(k)    = round(mean([out_comp{k}.binary.choice])*100);
    microstim_percentage(k) = round(mean([out_comp{k}.binary.microstim])*100);
    
    %% not necessarily correct....
    microstim_start_after_go_withnan  = unique([out_comp{k}.task([out_comp{k}.task.stim_state]==2 | ([out_comp{k}.task.stim_state]==3 & [out_comp{k}.task.type]==1) |[out_comp{k}.task.stim_state]==4 | [out_comp{k}.task.stim_state]==6 | [out_comp{k}.task.stim_state]==7 | [out_comp{k}.task.stim_state]==9).stim_start]);
    microstim_start_before_go_withnan = unique([out_comp{k}.task([out_comp{k}.binary.success] & (([out_comp{k}.task.stim_state]==3 & [out_comp{k}.task.type]~=1)| [out_comp{k}.task.stim_state]==5 | [out_comp{k}.task.stim_state]==10)).stim_to_state_end]);
    microstim_start_before_go_withnan = microstim_start_before_go_withnan(microstim_start_before_go_withnan<=0.2);
    microstim_start{k,:}              = round([sort(microstim_start_before_go_withnan(~isnan(microstim_start_before_go_withnan)).*-1) microstim_start_after_go_withnan(~isnan(microstim_start_after_go_withnan))].*1000);
    microstim_states                  = unique([out_comp{k}.task.stim_state]);
    microstim_state{k,:}              = microstim_states(~isnan(microstim_states));
    
    percentage_left_chosen_stimulated(k) = round([out_comp{k}.counts.left_choice_percentage_successful_microstim]);
    percentage_left_chosen_baseline(k)   = round([out_comp{k}.counts.left_choice_percentage_successful_baseline]);
    
    RT_R_mean_stimulated(k) =  round(nanmean([out_comp{k}.saccades([out_comp{k}.binary.eyetar_r] & [out_comp{k}.binary.success] & [out_comp{k}.binary.microstim]).lat])*1000);
    RT_R_std_stimulated(k)  =  round(nanstd([out_comp{k}.saccades([out_comp{k}.binary.eyetar_r] & [out_comp{k}.binary.success] & [out_comp{k}.binary.microstim]).lat])*1000);
    RT_L_mean_stimulated(k) =  round(nanmean([out_comp{k}.saccades([out_comp{k}.binary.eyetar_l] & [out_comp{k}.binary.success] & [out_comp{k}.binary.microstim]).lat])*1000);
    RT_L_std_stimulated(k)  =  round(nanstd([out_comp{k}.saccades([out_comp{k}.binary.eyetar_l] & [out_comp{k}.binary.success] & [out_comp{k}.binary.microstim]).lat])*1000);
    
    RT_R_mean_baseline(k) =  round(nanmean([out_comp{k}.saccades([out_comp{k}.binary.eyetar_r] & [out_comp{k}.binary.success] & ~[out_comp{k}.binary.microstim]).lat])*1000);
    RT_R_std_baseline(k)  =  round(nanstd([out_comp{k}.saccades([out_comp{k}.binary.eyetar_r] & [out_comp{k}.binary.success] & ~[out_comp{k}.binary.microstim]).lat])*1000);
    RT_L_mean_baseline(k) =  round(nanmean([out_comp{k}.saccades([out_comp{k}.binary.eyetar_l] & [out_comp{k}.binary.success] & ~[out_comp{k}.binary.microstim]).lat])*1000);
    RT_L_std_baseline(k)  =  round(nanstd([out_comp{k}.saccades([out_comp{k}.binary.eyetar_l] & [out_comp{k}.binary.success] & ~[out_comp{k}.binary.microstim]).lat])*1000);
    min_time_fix_hold(k)     =  round(min([out_comp{k}.timing.fix_time_hold])*1000);
    max_time_fix_hold(k)     =  round(max([out_comp{k}.timing.fix_time_hold])*1000) + round(max([out_comp{k}.timing.fix_time_hold_var])*1000);
    
    table_for_updating(k+1+shift_rows,:)= {str2double(filelist_re_formatted{k,1}(end-7:end)),filelist_re_formatted{k,2},n_trials(k),hits(k),hits_t_2_e_0(k),hits_t_2_e_4(k),...
        type{k,:},effector{k,:},reach_hand{k,:},x_positions{k,:},y_positions{k,:},...
        choice_percentage(k),microstim_percentage(k),microstim_start{k,:},microstim_state{k,:}...
        percentage_left_chosen_stimulated(k),percentage_left_chosen_baseline(k),...
        RT_R_mean_stimulated(k),RT_R_std_stimulated(k),RT_L_mean_stimulated(k),RT_L_std_stimulated(k),...
        RT_R_mean_baseline(k),RT_R_std_baseline(k),RT_L_mean_baseline(k),RT_L_std_baseline(k),min_time_fix_hold(k),max_time_fix_hold(k)};
    
end

raw_data_rows=[shift_rows+2:shift_rows+2+size(table_for_updating,1)];
mastertable= DAG_update_mastertable_cell(original_table,table_for_updating,raw_data_rows);
save(strcat(working_directory, monkey, '_trialinfo_mastertable_',current_date),'mastertable')
end
