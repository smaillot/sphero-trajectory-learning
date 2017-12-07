function theta = pi2(r, phi, a, g, sigma, theta_i, K)
    % parameters :
    % r : immediate cost, 
    % phi : terminal cost, 
    % g : basis function from the system dynamics, 
    % sigma : variance of the mean-zero noise
    % theta_i : initial parameter vector, 
    % K : number of roll-outs per update
    tolerance = 1e-5;
    R_last = -1;
    R = 0;
    gamma = 1;
    
    while abs(R - R_last) > tolerance
        
        for k=1:K
           
            eps = normrnd(0,gamma*sigma,size(theta_i));
            
        end
        
    end
    
end