function [ M, S ] = rollout_iteration( theta, r, cost_function, data, desired_traj, l)
% addpath('../DMP-LWR')

%ROLLOUT_ITERATION roolout iteration to run for each k in K
    % create epsillon vect
    data2.x=data{1};
    data2.y=data{3};
    data2.times=data{9};
    g = basis_function(r, data2);
    M = compute_M(g)
    S = compute_S(g, theta, M, data2, desired_traj, cost_function, l);
%    P = compute_P(S);
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

function S = compute_S (g, theta, M, data, desired_traj, cost_function, l)
    addpath('../DMP-LWR')
    S=[];
    sum1=0;
    sum2=0;
    e = random('norm',0,0.02,2,length(theta)); % zero mean noise
    psi=terminal_cost([data.x(end);data.y(end)],desired_traj(1:2,end), cost_function.pena_final);
    for i = 1:(size(g,3)-1)
        for j=i+1:(size(g,3)-1)
            sum1 = sum1 + cost_function.pena_path*norm(cat(2,data.x(i),data.y(i))-desired_traj(1:2,i))^2;
        end
        for j=i+1:size(g,3)
            sum2 = (theta+M(:,:,i,j)*e)'*cost_function.pena_input*(theta+M(:,:,i,j)*e);
        end
        S(:,i,l)=psi + sum1(j) + 1/2*sum2(j);
    end

end

% function P=compute_P(S)
%     lambda=0.95;
%     P=[];
%     sum_P_i=[];
%     for i=1:size(S, 2)
%         sum_at_i=0;
%         for k=1:size(S, 3)
%             sum_at_i=sum_at_i+exp(-(1/lambda)*S(:,i,k));
%         end
%         sum_P_i=[sum_P_i,sum_at_i];
%     end
%     for k=1:size(S, 3)
%         for i=1:size(S, 2)
%             P(:,i,k)= exp(-(1/lambda)*S(:,i,k))/sum_P_i(i);
%         end
%     end
% end