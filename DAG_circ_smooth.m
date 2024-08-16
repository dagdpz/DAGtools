function out = DAG_circ_smooth(input)
% Function to compute circular rlowess smoothing
% 
% By Liubov N. Vasileva, lvasileva@dpz.eu
%

input = input(:); % make input vertical

A = repmat(input, 3, 1);
A_smoothed = smooth(A, 7, 'rlowess');

out = A_smoothed(length(input)+1:end-length(input));

end
