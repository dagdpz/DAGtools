function [full_path name directory date_modified]= DAG_most_recent_version(main_directory,name_fragment,varargin)
if numel(varargin)>0
    look_in_subfolders=1;
else
    look_in_subfolders=0;    
end
directory=main_directory;
dir_content=dir(main_directory);
filenames={dir_content.name};
last_modified_dates=cellstr(datestr({dir_content.date},'yyyymmddHHMMSS'));
%last_modified_dates=cellfun(@(x) [x(1:8) x(10:15)],last_modified_dates,'UniformOutput',false);
isdirectory=[dir_content.isdir];
date_modified=0;
for k=3:numel(filenames)
    folderflag=false;
    if isdirectory(k) && look_in_subfolders
        [filenames{k} subfolder last_modified_dates{k}]= DAG_most_recent_version([main_directory filesep filenames{k}],name_fragment);
        folderflag=true;
    end
    if ~isempty(strfind(filenames{k},name_fragment))
        potential_date=str2double(last_modified_dates{k});
        if potential_date  > date_modified
            date_modified= potential_date;
            if folderflag                
                directory=subfolder;
                name=filenames{k};
            else
                n_file_extension_chars=numel(filenames{k})-strfind(filenames{k},'.');
                up_to_char=numel(filenames{k})-n_file_extension_chars-1;
                name=filenames{k}(1:up_to_char);
            end
        end
    end
end
if date_modified==0    
    name=[];
    full_path=[];
else
    full_path=[directory filesep name];
end
date_modified=num2str(date_modified);
end

