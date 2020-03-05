function hh=DAG_pie_chart_2(x,r_input,All_colors,txtradius,txtlabels)
if nargin<4
    txtradius =0.7;
end
% x=[1,2,3,4];
% r_input=[1];
% All_colors=[[0 0 1];[1 0 0];[0 1 0];[1 1 1]];
% txtlabels={'1','2','3','4'};

[cax,args,nargs] = axescheck(x);
xsum = sum(x);
if xsum > 1+sqrt(eps), x = x/xsum; end

% Look for labels
if nargin<5 
  for i=1:length(x)
    if x(i)<.01,
      txtlabels{i} = '';
    else
      txtlabels{i} = sprintf('%d%%',round(x(i)*100));
    end
  end
end


cax = newplot(cax);
next = lower(get(cax,'NextPlot'));

theta0 = pi/2;
maxpts = 100;

h = zeros(2*length(x),1);
for i=1:length(x)
  n = max(1,ceil(maxpts*x(i)));
  r = [0;ones(n+1,1)*r_input;0];
  theta = theta0 + [0;x(i)*(0:n)'/n;0]*2*pi;
  [xtext,ytext] = pol2cart(theta0 + x(i)*pi,txtradius*r_input);
  [xx,yy] = pol2cart(theta,r);
  theta0 = max(theta);
  h(i) = patch('XData',xx,'YData',yy,'CData',i*ones(size(xx)), ...
               'FaceColor',All_colors(i,:),'parent',cax);
  h(i+1) = text(xtext,ytext,txtlabels{i},...
              'HorizontalAlignment','center','parent',cax);
end
  view(cax,2); set(cax,'NextPlot',next); 
  axis(cax,'equal','off',[-1.2 1.2 -1.2 1.2])
  
if nargout>0, hh = h; end

% Register handles with m-code generator
% if ~isempty(h)
%   mcoderegister('Handles',h,'Target',h(1),'Name','pie_chart');
% end
