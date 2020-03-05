function histogram2Ddiscrete=DAG_hist2Dd(A,B,binsA,binsB)

if numel(A) ~= numel(B)
    error('A and B must contain the same number of elements')
else
    if nargin == 2
        binsA=unique(A);
        binsB=unique(B);
    end
    
    for m=1:numel(binsA)
        for n=1:numel(binsB)
            histogram2Ddiscrete(m,n)=sum(A==binsA(m)&B==binsB(n));
        end
    end
end

end