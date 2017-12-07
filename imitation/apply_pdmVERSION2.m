%% connect sphero and set the system parameters (heading,collision detection...)
% connectsph();
% setsystem();

%% save the data

ax = [];
ay = [];

from_camera = 0;
sph.MotionTimeout=5;
espeed = 60; % exploration speed
t0=cputime;

%pose = get_position(cam);

%x=pose(1);
%y=pose(2);
[xcur, ycur, ~, ~, ~] = sph.readLocator();
pos2 = [xcur, ycur];
x2 = pos2(1);
y2 = pos2(2);

dis=0;
t=0;
%for i=0:90:180
%tic
% result = roll(sph, espeed, i);
% while toc<2
%         [accX, accY, accZ] = readSensor(sph, {'accelX', 'accelY', 'accelZ'});
%         
%         aax = double(accX);
%         ax(end+1)=aax;
%         aay = double(accY);
%         ay(end+1)=aay;
%         %pos = get_position(cam);
%         [xcur, ycur, ~, ~, ~] = sph.readLocator();
%         pos2 = [xcur, ycur];
%         %x(end+1)=pos(1);
%         %y(end+1)=pos(2);
%         x2(end+1)=pos2(1);
%         y2(end+1)=pos2(2);
%         t(end+1) = cputime-t0;
% end
% end
tic
result = roll(sph, espeed, 0);
while toc<3
        [accX, accY, accZ] = readSensor(sph, {'accelX', 'accelY', 'accelZ'});
        
        aax = double(accX);
        ax(end+1)=aax;
        aay = double(accY);
        ay(end+1)=aay;
        %pos = get_position(cam);
        [xcur, ycur, ~, ~, ~] = sph.readLocator();
        pos2 = [xcur, ycur];
        %x(end+1)=pos(1);
        %y(end+1)=pos(2);
        x2(end+1)=pos2(1);
        y2(end+1)=pos2(2);
        t(end+1) = cputime-t0;
end
x2 = x2 - x2(1);
y2 = y2 - y2(1);

%% Parameter of the Gaussian and the system
% Parameter of the system
%Getting_Started.m

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
[tau,data]=get_data2();

% tau = t(end);
% data.x = double(x);
% data.y = double(y);
% data.ax = ax;
% data.ay = ay;
% dt = diff(t);
% dx = diff(x) ./ dt;
% dy = diff(y) ./ dt;
% data.vx = dx;
% data.vy = dy;
%% resize
% data.t = data.t(3:end);
% data.x = data.x(3:end);
% data.y = data.y(3:end);


dlg_title="choose parameter";
prompt={'K, Stifness coefficient', 'D, Damping coefficient', 'ng, number of gaussian', 'as, decrease of the time dx/dt = as*x','s, initial time'};
default={'500','100','100','1','1'};
uiwait(msgbox('Choose parameter','Parameter','modal'))
num_lines = 1;
answer= inputdlg(prompt,dlg_title,num_lines, default);
par=generate_param(answer);
r=dmpTrain(data, par);
wx=r.w_x;
wy=r.w_y;

%% Test the imiation 

% In this part I put the test function of alpx then I take the result to
% give the command of the Sphero

% k is to choose what you want to plot, k=1 (x, x_replay as function of
% time), k=3 (y, y_replay as function of time), k=14 (the curbs (x,y) and
% (x_replay, y_replay)

k=14;

result=dmpReplay(r);
result.options=[k];
res=dmpPlot(data, result);

% Now we generate the command matrix of the Sphero (1rst line is the speed,
% 2nd line is the angle, 3rd line is the time)
speed=[];
alpha=[];
for k=1:length(result.yd_xr)
speed=[speed, norm(result.yd_xr(k),result.yd_yr(k))];
alpha=[alpha, atan2(result.yd_yr(k),result.yd_xr(k))];
end
command_matrix=cat(1,speed,alpha,result.times);



% Xo=0;
% Yo=0;
% alpho=0;
% resolution=100;
%input_matrix=gen_trajectory(r,Xo,Yo,alpho,tau,resolution);

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




