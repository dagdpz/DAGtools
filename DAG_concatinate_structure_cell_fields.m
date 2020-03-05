function [combined_struct] = concatinate_structure_cell_fields(structure_cell,varargin)
% for concatinating elements of structure array fields, so that the result has only
% one element in the main structure array
% combined_struct{1}.fieldname_N(1:N)=structure_cell{1:c}.fieldname_N(1:n)
% N=sum of all n (for 1:c)
for f=1:numel(varargin)
    subfieldnames=fieldnames(structure_cell{1}.(varargin{f}));    
    fieldnamesforemptystructure=[subfieldnames'; repmat({{}},1,size(subfieldnames,1))];
    A=reshape(fieldnamesforemptystructure,numel(fieldnamesforemptystructure),1);
    combined_struct{1}.(varargin{f})=struct(A{:});
    for k=1:numel(structure_cell)
        combined_struct{1}.(varargin{f})=[combined_struct{1}.(varargin{f}); structure_cell{k}.(varargin{f})];        
    end
end
end
