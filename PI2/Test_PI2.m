%% Init_test
% We have little chance to test our program on the real robot so this
% file is made in order to test the program and generate plots that
% show that it works
close all

addpath(['../imitation']);
addpath(['../DMP-LWR']);

%% Generate the desired trajectory

% This function take the number of points in which we want our trajectory
% to pass throgh

%desPath=genDesiredTrajectory(2,10);

%% Determine parameters of the DMP

% input_struct=init_PI2_learning()

[param, cost_function, sigma, theta_i, K, gamma]=adapt_input(input_struct);

param.gx=desPath(1,end);
param.gy=desPath(2,end);
param.dt=desPath(3,2:end)-desPath(3,1:end-1);
param.times=desPath(3,1:end);

init_pos=[desPath(1,1);0;desPath(2,1);0];

r=basis_parameter(desPath, param);

theta = pi2(param, cost_function, r, sigma, theta_i, K, init_pos, gamma, desPath);


% %% Parameters of the DMP 
% 
% dlg_title="choose parameter";
% prompt={'K, Stifness coefficient', 'D, Damping coefficient', 'ng, number of gaussian', 'as, decrease of the time dx/dt = as*x','s, initial time'};
% default={'5000','500','100','1','1'};
% uiwait(msgbox('Choose parameter','Parameter','modal'))
% num_lines = 1;
% answer= inputdlg(prompt,dlg_title,num_lines, default);
% par=generate_param(answer);
% 
% g=gen_dmp_param(par,desPath);
% 
% %% Initial weights of the basis function
% dlg_title="choose initial weights of your basis functions";
% a='Enter your vector of weights [ ; ; ;... ; ] (';
% b='times)';
% prompt={cat(2,a,num2str(g.ng),b)};
% uiwait(msgbox('Choose initial weights','Parameter','modal'))
% num_lines = 1;
% answer= inputdlg(prompt,dlg_title,num_lines, default);
% theta_i=str2num(answer);
% 
% %% Initial Position
% 
% init_pos=[desPath.x(1);desPath.y(1)];
% 
% %% Other initialization
% param.K=g.K;
% param.tau=g.tau;
% param.D=g.D;
% param.times=g.times;
% 
% gamma=0.95;
% 
% nb_rollout=5;
% 
% %% Stephane, you need to initialize this
% r=0;
% phi=0;
% a=0;
% 
% 
% %% Launch the learning
% theta = pi2(param,r, phi, a, g, sigma, theta_i, nb_rollout, init_pos, gamma)
