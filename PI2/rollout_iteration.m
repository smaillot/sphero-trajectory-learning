function [ M, S, P ] = rollout_iteration( theta, r, data)
% addpath('../DMP-LWR')

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
            g1 = g(:,j,t);
            M(:,:,j,t) = R \ (g1 * g1' / (g1' / R * g1));
        end
    end
end

function S = compute_S (g, theta, M, q)
addpath('../DMP-LWR')
    R = eye(size(g,1));
    e = random('norm',0,0.02,2,length(theta)); % zero mean noise
    for i = 1:(size(g,2)-1)
        for j=1:(size(g,3)-1)
        sum1 = sum1 + q;
        end
    end
    
    for i = 1:size(g,3)
        for j=1:size(g,2)
        sum2 = (theta+M(:,:,i,j)*e)'*R*(theta+M(:,:,i,j)*e);
        end
    end

    for i=1:size(g,3)
        for j=1:size(g,2)
        S(:,i,j) = phi + sum1(j) + sum2(j);
        end
    end
   
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