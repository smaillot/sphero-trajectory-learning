function [param, cost_function, sigma, theta_i, K, gamma]=adapt_input(input_struct)

    param.ng=input_struct.PMD.ng;
    param.K=input_struct.PMD.K;
    param.D=input_struct.PMD.D;
    param.as=input_struct.PMD.as;
    param.s=input_struct.PMD.s;
    param.tau=input_struct.PMD.tau;
    
    cost_function=input_struct.cost_function;
    
    sigma=0.1;
    
    theta_i=input_struct.theta_i;
    
    K=input_struct.nb_roll_out.K;
    
    gamma=input_struct.iteration.gamma;
    
    