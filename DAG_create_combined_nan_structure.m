function [outputstructure] = DAG_create_combined_nan_structure(inputstructure1, inputstructure2)

field_names=unique([fieldnames(inputstructure1); fieldnames(inputstructure2)]);
nan_cell=repmat({NaN},numel(field_names),max(numel(inputstructure1),numel(inputstructure2)));
outputstructure=cell2struct(nan_cell,field_names,1);

size1=max(size(inputstructure1,1),size(inputstructure2,1));
size2=max(size(inputstructure1,2),size(inputstructure2,2));

outputstructure=reshape(outputstructure,size1,size2);
for k= 1: numel(field_names)
    if isfield(inputstructure1(1),field_names{k}) && isfield(inputstructure2(1),field_names{k}) && isstruct(inputstructure1(1).(field_names{k})) && isstruct(inputstructure2(1).(field_names{k}))
        substructure=DAG_create_combined_nan_structure(inputstructure1(1).(field_names{k}),inputstructure2(1).(field_names{k}));
        substructurecell=repmat({substructure},size1,size2);
        tmp_struct=struct(field_names{k},substructurecell);
        [outputstructure.(field_names{k})]=tmp_struct.(field_names{k});
        
    elseif isfield(inputstructure1(1),field_names{k}) && isstruct(inputstructure1(1).(field_names{k}))
        substructure=DAG_create_combined_nan_structure(inputstructure1(1).(field_names{k}),inputstructure1(1).(field_names{k}));
        substructurecell=repmat({substructure},size1,size2);
        tmp_struct=struct(field_names{k},substructurecell);
        [outputstructure.(field_names{k})]=tmp_struct.(field_names{k});
        
    elseif isfield(inputstructure2(1),field_names{k}) && isstruct(inputstructure2(1).(field_names{k}))
        substructure=DAG_create_combined_nan_structure(inputstructure2(1).(field_names{k}),inputstructure2(1).(field_names{k}));
        substructurecell=repmat({substructure},size1,size2);
        tmp_struct=struct(field_names{k},substructurecell);
        [outputstructure.(field_names{k})]=tmp_struct.(field_names{k});
        
    end
end
end
