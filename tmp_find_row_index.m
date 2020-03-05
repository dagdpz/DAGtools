function row_index=tmp_find_row_index(input,title)
disp('find_row_index should be replaced!!!')
row_index=NaN;
if iscell(input)
    for m=1:size(input,1)
        if strcmp(input{m,1},title)
            row_index=m;
        end
    end
else
    for m=1:size(input,1)
        if input(m,1)==title
            row_index=m;
            break
        end
    end
end