function theta = pi2(param, cost_function, r, sigma, theta_i, K, init_pos, gamma, desPath)
    % parameters :
    % r : immediate cost, 
    % theta_i, initial weights of the basis function
    % phi : terminal cost, 
    % g : basis function from the system dynamics, contain h, c and time 
    % sigma : variance of the mean-zero noise
    % theta_i : initial parameter vector, 
    % K : number of roll-outs per update,
    % init_pos: initial osition of the robot
    % gamma: the reduction of the variance of the noise with the number of
    % roll out
    % nb_update: number of update of the parameters
    % param contain the parameters of the dynamical equation, K, D, tau, dt
    addpath('../DMP-LWR')
    
    tolerance = 1e-5;
    S_last = -1;
    S = 1;
    S_k = [];
    nb_update=0;
    theta=theta_i;
    while abs(S - S_last) > tolerance
        
        r.ng=param.ng;
        r.stime=param.times;
        r.dt=param.dt(1);
        r.x0=init_pos(1);
        r.y0=init_pos(3);
        r.gx=param.gx;
        r.gy=param.gy;
        r.K=param.K;
        r.D=param.D;
        r.tau=param.tau;
        
        [contr, r]=rollout_command( K, sigma, gamma, nb_update, theta_i, r);
        plot_trajectory(contr,K)
   %     data=execute_RO(control, init_pos, g); % in commentary when we
   %     test the algorithm
        
        S_last=S;
        for j=1:K
            [ M, S ] = rollout_iteration( theta, r, cost_function, contr{j}, desPath);
            S_k = cat(3,S_k,S); 
        end
        P = compute_P(S_k');
        
        if max(S - S_last) > tolerance
            theta=update_PI2( theta_i, contr, P, M, K, r);
        end
    end
end

function P=compute_P(S)
    lambda=0.95;
    P=[];
    sum_P_i=[];
    for i=1:size(S, 2)
        sum_at_i=0;
        for k=1:size(S, 3)
            sum_at_i=sum_at_i+exp(-(1/lambda)*S(:,i,k));
        end
        sum_P_i=[sum_P_i,sum_at_i];
    end
    for k=1:size(S, 3)
        for i=1:size(S, 2)
            P(:,i,k)= exp(-(1/lambda)*S(:,i,k))/sum_P_i(i);
        end
    end
end