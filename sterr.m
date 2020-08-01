function o=sterr(i,DIM,flag)
% function originally from NaN toolbox, Copyright (C) 2000-2002 Alois Schloegl <a.schloegl@ieee.org> https://pub.ist.ac.at/~schloegl/matlab/NaN/
% Modified by Igor Kagan (IK) and Lukas Schneider (LS)

if nargin < 3,
        flag = 0; % IK 2011-06-03: 0 - default
end

if nargin<2,
        o=nanstd(i);
        i = i(:); % !!! added by IK 2010-09-06 Fixed the bug: when i was a row, DIM(1) would be 1, and sterr would return std!
        DIM = 1;
else
        o=nanstd(i,flag,DIM); % o=std(i,DIM);
end;

% o = o/sqrt(size(i,DIM)); % !!! added by LS 2017-02-07 Fixed the bug: when NaNs were present, they were wrongly counted as datapoints in sqrt
o = o./sqrt(sum(~isnan(i),DIM)); % added by IK 2017-02-07 Added "." to divider to take care of inputs with >1 dimension


% if flag
%         o = o*(size(i,DIM)-1)/size(i,DIM);
% end