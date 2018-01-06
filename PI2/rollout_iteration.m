function [ M, S, P ] = rollout_iteration( theta, r, data )
%ROLLOUT_ITERATION roolout iteration to run for each k in K
    % create epsillon vect
    g = basis_function(r, data);
    M = compute_M(g);
    S = compute_S('...');
    P = compute_P(S);
end

function M = compute_M (g)
    R = eye(size(g,1));
    M = zeros(size(g, 1), size(g, 1), size(g, 2), size(g, 3));
    for t=1:size(g, 3)
        for j=1:size(g, 2)
            g2 = g(:,j,t);
            M(:,:,j,t) = R \ (g2 * g2' / (g2' / R * g2));
        end
    end
end

function S = compute_S ()
    S = 
end

function P=compute_P(S, r)
    P=[];
    sum_P_i=[];
    for i=1:size(S, 2)
        sum_at_i=0;
        for k=1:size(S, 3)
            sum_at_i=sum_at_i+exp(-(1/r.lambda)*S(:,i,k));
        end
        sum_P_i=[sum_P_i,sum_at_i];
    end
    for k=1:size(S, 3)
        for i=1:size(S, 2)
            P(:,i,k)= exp(-(1/r.lambda)*S(:,i,k))/sum_P_i(i);
        end
    end
end