function filelist_formatted=DAG_format_filelist(filelist_unformatted)
id_file=0;
%filelist_formatted=NaN(n-size(filelist_unformatted,2),1);
for id_session = 1: length(filelist_unformatted(:,1));
    d=dir(filelist_unformatted{id_session,1});
    d=d(3:end);
    for run_per_session = 1:numel(filelist_unformatted{id_session,2})
        run_number_string=sprintf('%.2d', filelist_unformatted{id_session,2}(run_per_session));     
        for id_comp = 1:length(d)
            if strcmp(d(id_comp).name(end-5:end-4),run_number_string)
                run_name = d(id_comp).name;
                id_file=id_file+1;
            end
        end
        filelist_formatted{id_file,1}=[filelist_unformatted{id_session,1} filesep run_name];
    end
   
end
end
