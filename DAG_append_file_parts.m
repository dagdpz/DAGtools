function DAG_append_file_parts(filename,to_append,start_string)

%% read full file and find target position
fileID = fopen(filename,'r');
% tmp='';
% while strcmp(tmp,start_string)==0
%     tmp = fscanf(fileID,'%s',1);
% end
% start_position = ftell(fileID);
% 
% fseek(fileID, 0, 'bof');
Old_file_content = textscan( fileID, '%s', 'Delimiter','\n', 'CollectOutput',true );  
start_position =find(ismember(Old_file_content{1},start_string)); 
fclose(fileID);


%write first part
fileID = fopen(filename, 'w' );
for idx=1:start_position(1)
fwrite(fileID,Old_file_content{1}{idx});
fwrite(fileID,[ 13 10 ],'char');
end


%append the rest
fwrite(fileID,to_append);
fwrite(fileID,[ 13 10 ],'char');
for idx=start_position(1)+1:numel(Old_file_content{1})
fwrite(fileID,Old_file_content{1}{idx});
fwrite(fileID,[ 13 10 ],'char');
end
fclose(fileID);

end