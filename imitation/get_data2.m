function [tau,data]=get_data2(name)
    % Preparation of the data
    load(name);
    
%     data.ax=ax;
%     data.ay=ay;

    data.x=double(x)/100;
    data.y=double(y)/100;
    
    dx=double(diff(data.x));
    dy=double(diff(data.y));
    
    ddx=double(diff(dx));
    ddy=double(diff(dy));
    
    data.times=t;
    dt=double(diff(data.times));
    dt2=dt(1:end-1);
    data.vx=dx./dt;
    data.vy=dy./dt;
    
    data.ax=ddx./dt2;
    data.ay=ddy./dt2;
    
    data.x=double(data.x(1:end-2));
    data.y=double(data.y(1:end-2));
    
    data.vx=double(data.vx(1:end-1));
    data.vy=double(data.vy(1:end-1));
    
    data.times=data.times(1:end-2);
    
    tau=data.times(end);
    