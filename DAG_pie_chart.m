function hh=DAG_pie_chart(x,r_input,All_colors,center,txtradius,txtlabels)
%%

% x=[8,2,10,100];
% r_input=[1];
% center= [-10, 15]; % it is the coordinates of the center of chart
% All_colors=[[0 0 1];[1 0 0];[1 0 1];[1 1 0];;
% txtlabels={'1','2','2','2'};
% txtradius =0.7;


% x=[20,100];
% r_input=[0.5];
% center= [-10, 15]; % it is the coordinates of the center of chart
% All_colors=[[0 0 1];[1 0 0];
% txtlabels={'1','2'};
% txtradius =0.7;
set(0, 'DefaultFigureRenderer', 'painters');
% hold on
%%
if nargin<4
    center =[0,0];
end
if nargin<5
    txtradius =0.7;
end


[cax,args,nargs] = axescheck(x);
xsum = sum(x);
if xsum > 1+sqrt(eps), x = x/xsum; end

% Look for labels
if nargin<6
    for i=1:length(x)
        if x(i)<.01,
            txtlabels{i} = '';
        else
            txtlabels{i} = sprintf('%d',round(x(i)*100));
        end
    end
end


cax = newplot(cax);
next = lower(get(cax,'NextPlot'));

theta0 = pi/2;
maxpts = 100;

h = [];
for i=1:length(x)
    n = max(1,ceil(maxpts*x(i)));
    r = [0;ones(n+1,1)*r_input;0];
    theta = theta0 + [0;x(i)*(0:n)'/n;0]*2*pi;
    [xtext,ytext] = pol2cart(theta0 + x(i)*pi,txtradius*r_input);
    [xx,yy] = pol2cart(theta,r);
    xx = xx+center(1);
    yy = yy+center(2);
    
   xtext = xtext+center(1);
   ytext = ytext+center(2);
    
    theta0 = max(theta);
    if i<50
        h = [h,patch('XData',xx,'YData',yy,'CData',i*ones(size(xx)), 'FaceColor',All_colors(i,:),'parent',cax), ...
            text(xtext,ytext,txtlabels{i},'HorizontalAlignment','center','parent',cax, 'fontsize',7,'interpreter','none')];
    else
        if x(i)~=0
            patch('XData',xx,'YData',yy,'CData',i*ones(size(xx)),'FaceColor',All_colors(i,:),'parent',cax), ...
                text(xtext,ytext,txtlabels{i},'HorizontalAlignment','center','parent',cax,'fontsize',7,'interpreter','none');
        end
    end
end
view(cax,2); set(cax,'NextPlot',next);
%axis(cax,'equal','off',[-1.2 1.2 -1.2 1.2])
axis(cax,'equal','off')

if nargout>0, hh = h; end

% Register handles with m-code generator
% if ~isempty(h)
%   mcoderegister('Handles',h,'Target',h(1),'Name','pie_chart');
% end
