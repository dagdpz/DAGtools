function string_array=DAG_read_file_parts(filename,start_string,end_string)
fileID = fopen(filename,'r');
tmp='';
while strcmp(tmp,start_string)==0
    tmp = fscanf(fileID,'%s',1);
end
start_position = ftell(fileID);

while strcmp(tmp,end_string)==0
    tmp = fscanf(fileID,'%s',1);
end
end_position = ftell(fileID);
bytes_to_read=end_position-start_position;
fseek(fileID, start_position, 'bof');

string_array=fscanf(fileID,'%c',bytes_to_read);

fclose(fileID);
end