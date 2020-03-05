function DAG_clean_subfolders(main_folder,extension)
%clean_subfolders('W:\Data\Curius_phys_combined_monkeypsych_TDT','pdf')
data_in_main_folder=dir(main_folder);
subfolders=data_in_main_folder([data_in_main_folder.isdir]);
subfolders(1:2)=[];
for sub=1:numel(subfolders)
    folder=[main_folder filesep subfolders(sub).name];
    files_in_folder=dir([folder filesep '*.' extension]);
    for f=1:numel(files_in_folder)
        delete([folder filesep files_in_folder(f).name])
    end
end
end