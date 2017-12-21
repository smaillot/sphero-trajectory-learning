function [Path_weight,M, R]=asso_to_weight(position_matrix)
%this function take into account the path of the roll outs (the list of
%matrix of the previous function and associate the weight of the path after
%computing the cost performed by the path.


% As an output, the cost R of the path and the weight associated to each
% roll out and Mtjk (see the article). Mtjk is a list of matrix. The first
% line of the matrix is the value of M of the rollout k (the first element
% is its time at t0 and the last element at tN ) the second line is the
% time t0 until tN.
% For the weight of the path, just a matrix with the weight of the path for
% each lines (iteration 1, weight of the path on the first line, iteration
% 2, weight of the path inthe second line etc...)
