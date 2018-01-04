function theta = pi2(param,r, phi, a, g, sigma, theta_i, K, init_pos, gamma)
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
    R_last = -1;
    R = 0;
    nb_update=0;
    theta=theta_i;
    while abs(R - R_last) > tolerance

        control=rollout_command(param,init_pos, K, sigma, gamma, nb_update, theta_i, g);
        plot_trajectory(control)
        data=execute_RO(control, init_pos, g); 
        
        R_last=R;
        
        [Path_weight,M, R]=asso_to_weight();
        
        if abs(R - R_last) > tolerance
            theta=update_PI2( theta_i, control, Path_weight, M, K, g);
        end
    end
end