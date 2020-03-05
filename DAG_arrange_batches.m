function arranged_batches = DAG_arrange_batches(to_arrange,reference_batches,excel_table,varargin)
%row_index=DAG_find_row_index(mastertable_cell,'20150101','Session')
[num,masterstring_orig,RAW_orig] = xlsread(excel_table,'mastertable');
for k=1:numel(reference_batches)
    arranged_batches{k}={};
    row_index=find(DAG_find_row_index(RAW_orig,str2num(reference_batches{k}{1,1}(end-7:end)),'Session') & DAG_find_row_index(RAW_orig,reference_batches{k}{1,2},'Run'));
    for m=1:numel(to_arrange)
        to_arrange_temp=to_arrange{m};
        for v=1:numel(varargin)
            c_idx=DAG_find_column_index(RAW_orig,varargin{v});
            if isempty(c_idx)
                disp(['title ' varargin{v} ' not found in current table']);
                continue;
            end
            to_arrange_temp_v=[];
            for n=1:size(to_arrange_temp,1)                
                t_row_index=find(DAG_find_row_index(RAW_orig,str2num(to_arrange_temp{n,1}(end-7:end)),'Session') & DAG_find_row_index(RAW_orig,to_arrange_temp{n,2},'Run'));
                if strcmp(RAW_orig{row_index,c_idx},RAW_orig{t_row_index,c_idx})
                    to_arrange_temp_v=[to_arrange_temp_v; to_arrange_temp(n,:)];
                elseif ~ischar(RAW_orig{row_index,c_idx}) && RAW_orig{row_index,c_idx}==RAW_orig{t_row_index,c_idx}
                    to_arrange_temp_v=[to_arrange_temp_v; to_arrange_temp(n,:)];
                end
            end
            to_arrange_temp=to_arrange_temp_v;
            if isempty(to_arrange_temp_v)
                continue;
            end
        end
        if ~isempty(to_arrange_temp)
            arranged_batches{k}=to_arrange_temp;
            continue;
        end
    end
end
end