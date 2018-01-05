function [ M, S, P ] = rollout_iteration( theta, r, data )
%ROLLOUT_ITERATION roolout iteration to run for each k in K
    % create epsillon vect
    g = basis_function(r, data);
    M = compute_M(g);
    S = compute_S('...');
    P = compute_P(T);
end

function M = compute_M (g)
    R = eye(size(g,1));
    M = zeros(size(g, 1), size(g, 1), size(g, 2), size(g, 3));
    for t=1:size(g, 3)
        for j=1:size(g, 2)
            g = g(:,j,t);
            M(:,:,j,t) = R \ (g * g' / (g' / R * g));
        end
    end
end

function S = compute_S ()
    S = 
end