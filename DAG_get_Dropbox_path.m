function name = DAG_get_Dropbox_path ()
    if isunix() 
        name = getenv('USER'); 
    else 
        if strcmp(getenv('username'), 'rbirner')
            name = ['C:' filesep 'Users' filesep 'rbirner.DPZ' filesep 'Dropbox'];
        else
            name = ['C:' filesep 'Users' filesep getenv('username') filesep 'Dropbox'];
        end
    end
end
