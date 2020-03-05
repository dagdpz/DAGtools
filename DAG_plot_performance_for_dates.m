function DAG_plot_performance_for_dates(monkey,dates,DatesToMark,MarkStrings)
% plot_performance_for_dates('Cornelius',[20151101 20151130])
% plot_performance_for_dates('Cornelius',[20140701 20151130],[20140702 20140809 20140902 20141001 20141218 20150128 20150325 20150428 20150708 20151016 20151124], {'2 targets','4 targets', 'Reaches', 'Placeholders', 'Basic tasks rep', 'Shifting Offsets', 'More targets', '7 targets', 'Unilateral shapes', 'Exploration in dark', 'bilateral cues'})
drive=DAG_get_server_IP;
 data=[drive, 'Protocols', filesep, monkey, filesep, monkey, '_protocol.xls'];
[~,~,completetable] = xlsread(data,'Sessions');
columns_to_index={'Session','N_Trials','initiated','completed','hits'};
for FN=columns_to_index
   idx.(FN{:})=DAG_find_column_index(completetable,FN{:});
   values.(FN{:})=vertcat(completetable{2:end,idx.(FN{:})});
end
range=values.Session>=dates(1) & values.Session<=dates(2);

DateTicks=datenum(num2str(values.Session(range)),'yyyymmdd');

figure('units','normalized','outerposition',[0 0 1 1]);
subplot(2,1,1)
hold on
%bar(DateTicks,values.N_Trials(range)','r')
% bar(DateTicks,values.initiated(range)','facecolor',[1 0.5 0])
bar(DateTicks,values.completed(range)','r');
bar(DateTicks,values.hits(range)','g');

% plot(DateTicks,values.N_Trials(range)','r','linewidth',2);
% plot(DateTicks,values.initiated(range)','color',[1 0.5 0],'linewidth',2);
% plot(DateTicks,values.completed(range)','y','linewidth',2);
% plot(DateTicks,values.hits(range)','g','linewidth',2);

[num,ww]=weekday(DateTicks);

X_tick_lables=cellstr(num2str(values.Session(range)));
X_tick_lables(num~=2)=deal({''});

set(gca,'xlim',DateTicks([1,end]),'XTick',DateTicks,'XTickLabel',X_tick_lables);
rotateXLabels(gca,90);
ylabel('N');
xlabel('Session');
legend('completed trials', 'succesful trials');

DateTicksTomark=datenum(num2str(DatesToMark'),'yyyymmdd');

y_lim=get(gca,'ylim');
x_lim=get(gca,'xlim');
for d=1:numel(DateTicksTomark)
    line([DateTicksTomark(d) DateTicksTomark(d)],y_lim);
    text(DateTicksTomark(d)+diff(x_lim)/100,y_lim(2)*6.5/8,MarkStrings{d},'rotation',90);
end
title('Performance per session');



subplot(2,1,2)

hold on
DateTicksTomark=datenum(num2str(DatesToMark'),'yyyymmdd');

bar(DateTicks,(values.hits(range)./values.completed(range))'*100,'g');
set(gca,'xlim',DateTicks([1,end]),'XTick',DateTicks,'XTickLabel',X_tick_lables);
rotateXLabels(gca,90);
ylabel('% Success');
xlabel('Session');
legend('succesful trials');

y_lim=get(gca,'ylim');
x_lim=get(gca,'xlim');
for d=1:numel(DateTicksTomark)
    line([DateTicksTomark(d) DateTicksTomark(d)],y_lim);
    text(DateTicksTomark(d)+diff(x_lim)/100,y_lim(2)*6.5/8,MarkStrings{d},'rotation',90);
end
title('Success rate per session');
end


