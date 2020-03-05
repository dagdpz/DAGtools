function [outputstructure] = DAG_create_nan_structure_with_subfields(inputstructure)

field_names=fieldnames(inputstructure);
nan_cell=repmat({NaN},numel(field_names),numel(inputstructure));
outputstructure=cell2struct(nan_cell,field_names,1);
outputstructure=reshape(outputstructure,size(inputstructure,1),size(inputstructure,2));
for k= 1: numel(field_names)
    if isstruct(inputstructure(1).(field_names{k}))
        substructure=DAG_create_nan_structure(inputstructure(1).(field_names{k}));
        substructurecell=repmat({substructure},size(inputstructure,1),size(inputstructure,2));
        tmp_struct=struct(field_names{k},substructurecell);
        [outputstructure.(field_names{k})]=tmp_struct.(field_names{k});
    end
end
end
