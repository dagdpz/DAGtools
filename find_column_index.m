function column_index=find_column_index(inputcell,title)
column_index=[];
for m=1:size(inputcell,2)
    if strcmp(inputcell{1,m},title)
        column_index=m;
    end
end
end