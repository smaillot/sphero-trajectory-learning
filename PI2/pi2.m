function [theta,data_log] = pi2(param, cost_function, r, sigma, theta_i, K, init_pos, gamma, desPath, sph)
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
    data_log = [];
    tolerance = 1e-5;
    S_last = zeros(length(param.times),2 ,K);
    S_k = [];
    M_k.x = [];
    M_k.y = [];
    nb_update=0;
    theta=theta_i;
    S2=0;
    S1=100;
    z=0;
    
    while max(S1,S2) > tolerance && z<50
        
        if z>=1
            S_last=S_k;
        end
        S_last;
        S_k = [];
        M_k.x = [];
        M_k.y = [];
        r.ng=param.ng;
        r.dt=param.dt(1);
        r.x0=init_pos(1);
        r.y0=init_pos(3);
        r.gx=param.gx;
        r.gy=param.gy;
        r.K=param.K;
        r.D=param.D;
        r.tau=param.tau;
        
        [contr, r]=rollout_command( K, sigma, gamma, nb_update, theta_i, r,sph);
        % plot_trajectory(contr,K)
        
        data=execute_RO(contr, init_pos, param, K, sph); % in commentary when we test the algorithm
        
        
        
        for j=1:K
%             [ M, S ] = rollout_iteration( theta, r, cost_function, contr{j}, data);
            [ M, S ] = rollout_iteration( theta, r, cost_function, data{j}, desPath);
            S_k = cat(3,S_k,S'); 
            M_k.x = cat(4, M_k.x, M.x);
            M_k.y = cat(4, M_k.y, M.y);
        end
        
        P = compute_P(S_k);
        Sl1=S_last(:,:,1);
        Sl2=S_last(:,:,2);
        if size(S_last(:,:,1))~=size(S_k(:,:,1))
            Sl1=S_last(:,:,1)';
        end
        if size(S_last(:,:,2))~=size(S_k(:,:,2))
            Sl2=S_last(:,:,2)';
        end
        S1=norm(S_k(:,:,1)-Sl1);
        S2=norm(S_k(:,:,2)-Sl2);
        if max(S1,S2) > tolerance
            theta.x=update_PI2( theta.x, contr, P, M_k.x, K, r);
            theta.y=update_PI2( theta.y, contr, P, M_k.y, K, r);
        end
        
        z=z+1;
        a=theta.x;
        b=theta.y;
        log.a = a;
        log.b = b;
        
        result=dmpReplay(r);
        %¡¡plot(result.y_xr,result.y_yr)
        contr{1}{1}=result.yd_xr;
        contr{1}{3}=result.yd_yr;
        data=execute_RO(contr, init_pos, param, 1, sph);
        [ ~, S ] = rollout_iteration( theta, r, cost_function, data{j}, desPath);
        log.cost = norm(S)
        log.data = data;
        
        data_log = [data_log log];
        
%             figure(2);
%             hold on
%             subplot(1,2,1)
%             plot(data(1,:),data(2,:));
%             subplot(1,2,2)
%             plot(log.cost);

       
    end
end

function P=compute_P(S_k)
    lambda=50;
    P=[];
    sum_P_i=[];
    for a=1:2
        for i=1:size(S_k, 1)
            sum_at_i=0;
            for k=1:size(S_k, 3)
                sum_at_i=sum_at_i+exp(-(1/lambda)*S_k(i,a,k));
            end
            sum_P_i=[sum_P_i,sum_at_i];
        end
        for k=1:size(S_k, 3)
            for i=1:size(S_k, 1)
                P(a,i,k)= exp(-(1/lambda)*S_k(i,a,k))/sum_P_i(i);
            end
        end
    end
end