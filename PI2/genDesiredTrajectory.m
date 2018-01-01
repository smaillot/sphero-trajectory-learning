function struct=genDesiredTrajectory(n, resolution)
% This function has been created in the suspition that we wouldn't be able
% to test our program on the real robot before the presentation. 
% It takes the number of viapoint+final point and their times of the 
% desired path of the user and return a trajectorywith the desired resolution
% It is just a way to test that our program work
    addpath(['../imitation']);
    addpath(['../DMP-LWR']);
    movement=[];
    for k=0:n
        if k==0
            prompt={'select initial point [X;Y]'};
            uiwait(msgbox('Write your points','Data_Collecting','modal'))
            x=inputdlg(prompt);
            position=str2num(x{1});
            movement=cat(1,position,0);
        else
            prompt={'selectpoint [X;Y]','Time during which it passes through'};
            uiwait(msgbox('Write your points','Data_Collecting','modal'))
            x=inputdlg(prompt);
            position=str2num(x{1});
            time=str2num(x{2});
            movement=[movement,cat(1,position,time)];
        end
    end
    d.stime=movement(3,:);
    times=gen_time(resolution,d);
    struct.x=interp1(d.stime,movement(1,:),timec);
    struct.y=interp1(d.stime,movement(2,:),timec);
    struct.times=times;
    plot(struct.x,struct.y)
    
    
