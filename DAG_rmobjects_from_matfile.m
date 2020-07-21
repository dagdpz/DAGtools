function DAG_rmobjects_from_matfile(folder)

matfiles=dir([folder filesep '*.mat']);
matfiles=strcat([folder filesep],{matfiles.name});
for f=1:numel(matfiles)
    load(matfiles{f})
    all_var_names=who;
    all_var_names=all_var_names(~ismember(all_var_names,{'all_var_names','folder','matfiles','f','v'}));
    for v=1:numel(all_var_names)
        %eval( ['handls=' all_var_names{v}]);
        eval([all_var_names{v} '=DAG_rmobjects_from_struct(eval(all_var_names{v}),1);']);
    end
    save(matfiles{f},all_var_names{:});
end

end
