function [h,p]=DAG_permutation_test(A,B,N_permutations)
%% so far we are assuming A and B are vectors
A=A(:);
B=B(:);


na=numel(A);
nb=numel(B);
alpha=0.05;
testcharacteristic='mean';
tail='two_sided';
method='conservative';
data_vect=[A;B];


% M=rand(N_permutations,N_samples);

M=DAG_make_n_unique_permutations([zeros(na,1);ones(nb,1)],N_permutations);
[~,idx]=sort(M,2);
MM=data_vect(idx);

switch testcharacteristic
    case 'mean'
        A_perm      =mean(MM(:,1:na),2);
        B_perm      =mean(MM(:,na+1:end),2);
        A_measured  =mean(A);
        B_measured  =mean(B);
end

switch tail
    
    case 'two_sided'
        %Phibson 2010 Permutation P-values should never be zero: calculating exact P - NCBI
        %this is "conservative" in a sense that the exact p-value is lower!
        p_t=(sum(abs(A_perm-B_perm)>abs(A_measured-B_measured))+1)/(N_permutations+1);
        
end

if strcmp(method, 'conservative')
    p = p_t;
    h=p<alpha;
    return
end
end

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

%% taken from nchoosek
function P = combs(v,m)
%COMBS  All possible combinations.
%   COMBS(1:N,M) or COMBS(V,M) where V is a row vector of length N,
%   creates a matrix with N!/((N-M)! M!) rows and M columns containing
%   all possible combinations of N elements taken M at a time.
%
%   This function is only practical for situations where M is less
%   than about 15.

if nargin~=2, error(message('MATLAB:nchoosek:WrongInputNum')); end

v = v(:).'; % Make sure v is a row vector.
n = length(v);
if n == m
    P = v;
elseif m == 1
    P = v.';
else
    P = [];
    if m < n && m > 1
        for k = 1:n-m+1
            Q = combs(v(k+1:n),m-1);
            P = [P; [v(ones(size(Q,1),1),k) Q]];
        end
    end
end
end