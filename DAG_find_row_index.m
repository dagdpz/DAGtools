function row_index=DAG_find_row_index(input,string_to_match,varargin)
%row_index=find_row_index_working(mastertable_cell,'20150101','Session')
% disp('function find_row_index_working should be revised!!!')
if numel(varargin)==0
    row_index=NaN;
    if iscell(input)
%         disp('find_row_index should be replaced!!!')
        for m=1:size(input,1)
            if strcmp(input{m,1},string_to_match)
                row_index(m)=true;
            elseif ~ischar(input{m,1}) && input{m,1}==string_to_match
                row_index(m)=true;
            else
                row_index(m)=false;
            end
        end
    else
%         disp('find_row_index should be replaced!!!')
        for m=1:size(input,1)
            if input(m,1)==string_to_match
                row_index(m)=true;
            else
                row_index(m)=false;
            end
        end
    end
else
    row_index=NaN;
    if iscell(input)
        c_idx=DAG_find_column_index(input,varargin{1});
        for m=1:size(input,1)
            if strcmp(input{m,c_idx},string_to_match)
                row_index(m)=true;
            elseif ~ischar(input{m,c_idx}) && input{m,c_idx}==string_to_match
                row_index(m)=true;
            else
                row_index(m)=false;
            end
        end
    else
        for m=1:size(input,1)
            if input(m,1)==string_to_match
                row_index(m)=true;
            else
                row_index(m)=false;
            end
        end
    end
end
