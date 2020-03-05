function [filelist_complete filelist_formatted] = DAG_get_filelist_from_folder(varargin)
%  DAG_get_filelist_from_folder('W:\Data\Tesla\',[20140201 20140301])

global analysis_parameters

if numel(varargin)==0
    folder_with_session_days=analysis_parameters.folders.extended_data;
    dates=analysis_parameters.dates;
    disp('get_filelist_from_folder is taking folder and dates from analysis_parameters')
else
    folder_with_session_days=varargin{1};
    dates=varargin{2};
    disp('get_filelist_from_folder is taking folder and dates from input')
end

if folder_with_session_days(end)~='\'
    folder_with_session_days=[folder_with_session_days '\'];
end

dir_folder_with_session_days=dir(folder_with_session_days); % dir
if all(isnan(dates)) || all(isempty(dates)) || all(dates==0)
    all_files_in_base_path=DAG_keep_only_numeric_cell_entries({dir_folder_with_session_days.name}); % all files from the main monkey folder
else
    all_files_in_base_path=[];
    ctr=1;
    for k=1: length(dir_folder_with_session_days)
        X=str2double(dir_folder_with_session_days(k).name);
        if X==dates(1) ||  ( X<=  dates(2) && X >  dates(1))
            all_files_in_base_path{ctr}= dir_folder_with_session_days(k).name;
            ctr=ctr+1;
        end
    end
    
end

i_run=1;
for in_folders = 1:length(all_files_in_base_path)
    individual_day_folder = [folder_with_session_days all_files_in_base_path{in_folders}]; % session of interest
    d_individual_day_folder=dir(individual_day_folder); % dir
    files_inside_session_folder={d_individual_day_folder.name}'; % files inside session folders
    for number_of_files = 1:length(files_inside_session_folder) % start looping within the session folder
        if length(files_inside_session_folder{number_of_files}) > 4 && strcmp(files_inside_session_folder{number_of_files}(end-3:end),'.mat')
            filelist_complete(i_run,:)=[individual_day_folder filesep files_inside_session_folder{number_of_files}];
            filelist_formatted(i_run,:)= {filelist_complete(i_run,1:end-21) str2double(filelist_complete(i_run,end-5:end-4))};
            i_run=i_run+1;
        end
    end
    clc;
end
end

