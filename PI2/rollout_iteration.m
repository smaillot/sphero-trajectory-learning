function [ M, S ] = rollout_iteration( theta, r, cost_function, data, desired_traj)
% addpath('../DMP-LWR')
 
%ROLLOUT_ITERATION roolout iteration to run for each k in K
    % create epsillon vect
    data2.x=data{7};
    data2.y=data{8};
    data2.ex=data{2};
    data2.ey=data{4};
    data2.times=data{9};
    g = basis_function(r, data2);
    Mx = compute_M(g, 'x',r);
    My = compute_M(g, 'y',r);
    Sx = compute_S(g, theta, Mx, data2, desired_traj, cost_function, 'x');
    Sy = compute_S(g, theta, My, data2, desired_traj, cost_function, 'y');
    M.x = Mx;
    M.y = My;
    S = [Sx;Sy];
%    P = compute_P(S);
end
 
function M = compute_M (g, param,r)
    n1 = r.ng;
    N = size(g,3);
    R = eye(n1);
    if param == 'x'
        g = squeeze(g(1,:,:));
    else
        g = squeeze(g(2,:,:));
    end
    M = zeros(n1, n1, N);
    for t=1:N
            g1 = g(:,t);
            M(:,:,t) = R^(-1)*(g1 * g1' / (g1' / R * g1));
    end
end

function S = compute_S (g, theta, M, data, desired_traj, cost_function, param)
    addpath('../DMP-LWR')
    N = length(data.times);
    S=zeros(1,N);
    sum1=0;
    sum2=0;
    if param == 'x'
        e = data.ex;
        psi=terminal_cost(data.x(end),desired_traj(1,end), cost_function.pena_final);
    else
        e = data.ey;
        psi=terminal_cost(data.y(end),desired_traj(2,end), cost_function.pena_final);
    end
    for i = 1:N
        for j=i+1:(N-1)
            sum1 = sum1 + cost_function.pena_path*norm(cat(2,data.x(i),data.y(i))-desired_traj(1:2,i));
            if param == 'x'
                theta_mat = theta.x;
            else
                theta_mat = theta.y;
            end
            sum2 = sum2 + (theta_mat+M(:,:,j)*e)'*cost_function.pena_input*(theta_mat+M(:,:,j)*e);
        end
        S(i)=psi + sum1 + 1/2*sum2;
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
