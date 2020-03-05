function [task] = DAG_import_parameters_from_xls_to_trial_task(varargin)

%import_parameters_from_xls_to_trial_task(20140719,'Y:\Data\Curius_microstim_with_parameters','Curius_stimulation_parameters.xls')
%import_parameters_from_xls_to_trial_task([20140710 20140722],'Y:\Data\Linus_microstim_with_parameters','Linus_stimulation_parameters.xls')

%xls_file='curius_stimulation_parameters_2.ods';
%[~,~,raw] = xlsread(xls_file,num2str(days));

%base_path = 'C:\Users\Adan_Ulises\Desktop\Behavioral_analysis_audv\Pulvinar_project\setup1_microstim';
%base_path = 'C:\Users\lschneider\Desktop\monkey_data\Curius';

global analysis_parameters
if numel(varargin)==0
    dates=analysis_parameters.dates;
    folder_with_session_days=analysis_parameters.folders.extended_data;
    xls_file=analysis_parameters.files.original_parameters;
else
    if numel(varargin)>0
        dates=varargin{1};
    end
    if numel(varargin)>1
        folder_with_session_days=varargin{2};
    end
    if numel(varargin)>2
        xls_file=varargin{3};
    end
end

if numel(dates)==1
dates=[dates dates];
end

dir_folder_with_session_days=dir(folder_with_session_days); % dir
all_files_in_base_path=[];
ctr=1;
for k=1: length(dir_folder_with_session_days)
    X=str2num(dir_folder_with_session_days(k).name);
    if X==dates(1) |  ( X<=  dates(2) & X >  dates(1))
        all_files_in_base_path{ctr}= dir_folder_with_session_days(k).name;
        valid_dates{ctr}=X;        
        ctr=ctr+1;
    end
end


for in_folders = 1:length(all_files_in_base_path)
    ii_run=2;
    if length(all_files_in_base_path{in_folders})==8 % take all the folders named as yyyymmdd from the main monkey folder
        [~,~,raw] = xlsread(xls_file,num2str(valid_dates{in_folders}));
        folder_to_look_at{1} = all_files_in_base_path{in_folders}; % start looping through session folders
        individual_day_folder = [folder_with_session_days folder_to_look_at{1}]; % session of interest
        d_individual_day_folder=dir(individual_day_folder); % dir
        files_inside_session_folder={d_individual_day_folder.name}'; % files inside session folders
        for number_of_files = 1:length(files_inside_session_folder) % start looping within the session folder
            SETTINGS=[];
            if length(files_inside_session_folder{number_of_files}) > 10 && strcmp(files_inside_session_folder{number_of_files}(end-3:end),'.mat')
                load([individual_day_folder filesep files_inside_session_folder{number_of_files}]);                
                parameter_index=1;
                while true
                    if size(raw,2) < parameter_index
                        break;
                    end
                    current_parameter=raw{1,parameter_index};
                    if isnan(current_parameter)
                        break;
                    else
                       task.(current_parameter)=raw{ii_run,parameter_index};
                       parameter_index=parameter_index+1;
                    end
                end
                ii_run=ii_run+1;                
                tmp_field_cell=repmat({task},numel(trial),1);
                [trial.task]=tmp_field_cell{:};
                save([individual_day_folder filesep files_inside_session_folder{number_of_files}],'task','trial','SETTINGS')                
            end
        end
    end
end