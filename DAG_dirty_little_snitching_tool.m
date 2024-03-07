sorting_table='Y:\Data\Sorting_tables\Bacchus\Bac_sorted_neurons.xlsx';
%sorting_table='Y:\Data\Sorting_tables\Magnus\Mag_sorted_neurons.xlsx';
% ecg_folder='Y:\Data\BodySignals\ECG\Bacchus';
ecg_folder='Y:\Data\BodySignals\ECG\Magnus';



[data, text, rawData]=xlsread(sorting_table,'final_sorting');
Sess_column=DAG_find_column_index(rawData,'Date');
block_column=DAG_find_column_index(rawData,'Block');
set_column=DAG_find_column_index(rawData,'Set');


Sets=cell2mat(rawData(2:end,set_column));
Blocks=cell2mat(rawData(2:end,block_column));
Sessions=cell2mat(rawData(2:end,Sess_column));

Suspicious=[];

U_Sessions=unique(Sessions);
for s=1:numel(U_Sessions)
    S=U_Sessions(s);
    session_rows=Sessions==S;    
    U_Blocks=unique(Blocks(session_rows));

    for b=1:numel(U_Blocks)
        B=U_Blocks(b);
        block_rows=session_rows & Blocks==B;
        
        blocksets=Sets(block_rows);
        
        if numel(unique(blocksets))~=1
            Suspicious=[Suspicious; S B];
        end
        
        
    end
end
Suspicious

subfolders=dir(ecg_folder);
subfolders=subfolders([subfolders.isdir]);

% empty_ecg_sessions={};
% empty_ecg_blocks={};
% for f=1:numel(subfolders)
%     matfilename=dir([ecg_folder filesep subfolders(f).name filesep '*ecg.mat' ]);
%     
%     
%     if ~isempty(matfilename)
%         load([ecg_folder filesep subfolders(f).name filesep matfilename.name]);
%         if ~isfield(out,'nrblock_combinedFiles')
%             nanblocks='field missing!';
%         else            
%         nanblocks=find(arrayfun(@(x) isempty(x.nrblock_combinedFiles),out)); 
%         end
%         if any(nanblocks)
%             empty_ecg_blocks=[empty_ecg_blocks; {subfolders(f).name}, {nanblocks}];
%         end
%     else
%         empty_ecg_sessions=[empty_ecg_sessions {subfolders(f).name}];
%     end
%     
%     
% end