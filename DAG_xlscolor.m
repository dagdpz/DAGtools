function DAG_xlscolor(file, data, change_matrix)
%%
% modified: 20140707
% Danial

% using the following links:
% http://www.mathworks.com/matlabcentral/answers/102070-how-do-i-write-data-to-an-excel-spreadsheet-with-a-custom-cell-background-color-and-custom-font-colo
% http://www.mathworks.com/matlabcentral/answers/96794-how-can-i-open-an-existing-excel-file-and-communicate-with-it-using-activex
%%

% file= 'W:\Projects\ChangeExp\Changexp Analysis\test.xlsx';
% data= rand(5,5);
% range= 'A21:E25';

%%
%Open an ActiveX connection to Excel
h = actxserver('excel.application');

Workbooks = h.Workbooks;
h.Visible=1;
Workbook=Workbooks.Open(file);
% invoke(Workbooks,'Open', file)
Sheets = h.ActiveWorkBook.Sheets; 
sheet1 = get(Sheets, 'Item', 1);
invoke(sheet1, 'Activate');
Activesheet = h.Activesheet;

[total_rows,total_columns]=size(change_matrix);
[total_xlsind]=DAG_index_to_xls_column(total_rows, total_columns);
TotalRange = get(Activesheet,'Range',['A1:' total_xlsind]);
set(TotalRange, 'Value', data);

[All_colored_rows,All_colored_columns]=find(change_matrix);

for k=1:numel(All_colored_columns)
[colored_xlsindex]=DAG_index_to_xls_column(All_colored_rows(k), All_colored_columns(k));
ActivesheetRange = get(Activesheet,'Range',colored_xlsindex);
ActivesheetRange.interior.Color=hex2dec('B1C66B'); %light green
ActivesheetRange.font.Color=hex2dec('0');     % black
end

% http://www.mathsisfun.com/hexadecimal-decimal-colors.html
%       	Decimal                     Hexadecimal
%  Color   (Red, Green, Blue)           #RRGGBB
% Black 	(0, 0, 0)=0                 #000000
% White 	(255, 255, 255)=16777215 	#FFFFFF
% Red       (255, 0, 0)=16711680        #FF0000
% Green 	(0, 255, 0)=65280           #00FF00
% Blue      (0, 0, 255)=255             #0000FF
% Yellow 	(255, 255, 0)=16776960      #FFFF00
% Cyan      (0, 255, 255)=65535         #00FFFF
% Magenta 	(255, 0, 255)=16711935      #FF00FF

Workbook.Save
invoke(Workbook,'Save')
%invoke(Workbook,'Quit')
%Workbook.Quit;
invoke(h,'Quit');
delete(h);
clear h;

end