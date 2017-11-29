%% This code aim to retrieve acceleration data in a .mat file


%% Parameter of the Gaussian and the system
% Parameter of the system
%Getting_Started.m

% We begin by the initialisation of the object Sphero
% if ~exist('s') 
%     remote_name = 'Sphero-GRO'; % Change WPP to match your device name
%     s = Sphero(remote_name);
% end

close all

% Now we want to retrieve the data of the Sphero in a log.mat file
prompt='Begin ? {y/n}';
uiwait(msgbox('You re about to save a movement','Data_Collecting','modal'))
x=inputdlg(prompt);
x=x{1};
while x~='y' && x~='n'
    uiwait(msgbox('You made an error.','Retry','modal'))
    x=inputdlg(prompt);
    x=x{1};
end
    

if x=='y'
    %% XIAOXUAN, YOU SHOULD PUT YOUR CODE HERE TO TAKE DATA FROM SPHERO
    
    % You need to take acceleration ax and ay, velocity vx and vy and
    % position x and y
%    time_period=take_move(freq,1,50);
end
[tau,data]=get_data();
data=gen_points(200,data);
dlg_title="choose parameter";
prompt={'K, Stifness coefficient', 'D, Damping coefficient', 'ng, number of gaussian', 'as, decrease of the time dx/dt = as*x','s, initial time'};
default={'500','30','100','1','1'};
uiwait(msgbox('Choose parameter','Parameter','modal'))
num_lines = 1;
answer= inputdlg(prompt,dlg_title,num_lines, default);
uiwait(msgbox('Chosen','Parameter','modal'))
par=generate_param(answer);
r=dmpTrain(data, par);
wx=r.w_x;
wy=r.w_y;
result=dmpReplay(r);

    result.options=[14];
    res=dmpPlot(data, result);


%% 
% Xo=0;
% Yo=0;
% alpho=0;
% resolution=floor(max(r.times)-min(r.times));
% input_matrix=gen_trajectory(r,Xo,Yo,alpho,tau,resolution);

% prompt='You have the choice \n 1) Learning by imitation \n 2) Learning by reinforcement';
% x=inputdlg(prompt)
% uiwait(msgbox('Ready ?','Ready ?','modal'))
% x=str2num(x);
% 
% if x==1
%    % Learning of the movement by imitation
%    learn_by_imit()
% else
%     stop=0;
%     while stop==0
%         % Reinforcement learning
%         prompt='Stop ? {y/n}';
%         y=inputdlg(prompt);
%         uiwait(msgbox('Continue','Continue','modal'))
%         if y=='y'
%             stop=1;
%         end
%     end
% end
% 
% % Both should return the list of weights associated to the bases functions 
% 
% % We get 2 vectors, the vector THETA and the vector of the Basis Function
% 
% 
% 



