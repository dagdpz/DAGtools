function DAG_delete_last_empty_trial(datapath)

% This function deletes the last trial of each run in one session(datapath)
% which has empty fields (eg. state, x y hand,  ...)
%clear; close ; clc
%datapath='C:\Users\dagadmin\Dropbox\DAG\Danial\monkey analysis\20131223';
%DeleteLastTrial('Y:\Data\Curius_microstim_with_parameters\20140719')

disp('DeleteLastTrial will be replaced, consider using monkeypsych_clean_data');

dir_datapath=dir(datapath);
for l=1: length(dir_datapath)
    if ismember('mat', dir_datapath(l).name)
        % load each run in one session
        load([datapath filesep dir_datapath(l).name])
        LastTrial_ind= length(trial); % take the index of last trial
        % check if the last trial is empty.... we check its state field
        
        if isfield(SETTINGS,'dio')
            SETTINGS=rmfield(SETTINGS,'dio');
            disp(strcat('Deleting SETTINGS.dio object of file: ', dir_datapath(l).name))
            save([datapath filesep dir_datapath(l).name], 'task', 'SETTINGS', 'trial')
        end
        
        if isempty(trial(1,LastTrial_ind ).state)
            disp(strcat('Deleting last empty trial of file: ', dir_datapath(l).name))
            trial= trial(1: LastTrial_ind-1);
            save([datapath filesep dir_datapath(l).name], 'task', 'SETTINGS', 'trial')
        end
    end
end