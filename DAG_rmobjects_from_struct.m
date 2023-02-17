function handles=DAG_rmobjects_from_struct(handles,closefig)
if nargin<2
closefig=0;
end
for fn=fieldnames(handles)'
    if isobject(handles.(fn{:}))
        if closefig && all(isvalid(handles.(fn{:}))) && all(strcmp(get(handles.(fn{:}),'type'),'figure'))
            close(handles.(fn{:}));
        end
        handles=rmfield(handles,fn{:});
    end
end
end