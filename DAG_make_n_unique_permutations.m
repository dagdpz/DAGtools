function M=DAG_make_n_unique_permutations(A,n)

A=A(:);
A_row=A';
M=NaN(n+1,numel(A));
M(1,:)=A;
nan_permutations=sum(isnan(M(:,1)));
n_attempts=0;
maxattempts=100;

while nan_permutations>0
    to_replace=isnan(M(:,1));    
    [~,ix]=sort(rand(nan_permutations,numel(A)),2);
    M=[M(~to_replace,:); A_row(ix)]; % needs to be a row in case ix is one row only
    [~,ndx] = unique(M,'rows','first');
    nan_permutations=n+1-numel(ndx);
    M=[M(1,:); M(ndx(ndx~=1),:); NaN(nan_permutations,numel(A))];
    n_attempts=n_attempts+1;    
    if n_attempts>=maxattempts
        break;
    end    
end
end