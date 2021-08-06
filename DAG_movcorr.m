function [out_corr out_p]=DAG_movcorr (x,y,N)

out_corr=NaN(size(x));
out_p=NaN(size(x));
for k=1:numel(x)
   if k < N/2+1
       [c,p]=corr(x(1:N),y(1:N));
   elseif k > numel(x)-N/2
       [c,p]=corr(x(end-N:end),y(end-N:end));
   else
       [c,p]=corr(x(k-N/2:k+N/2),y(k-N/2:k+N/2));
   end
    out_corr(k)=c;
    out_p(k)=p;
end
end