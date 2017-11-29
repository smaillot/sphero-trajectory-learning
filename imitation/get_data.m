function [tau,data]=get_data()
    % Preparation of the data
    load("sensor.mat");
    data.ax=accxlog;
    data.ay=accylog;

    data.x=xlog;
    data.y=ylog;
    
    dx=double(diff(data.x));
    dy=double(diff(data.y));
    
    data.times=t;
    
    dt=double(diff(data.times));
    
    data.vx=dx./dt;
    data.vy=dy./dt;
    
    data.x=data.x(1:end-1);
    data.y=data.y(1:end-1);
    
    data.ax=data.ax(1:end-1);
    data.ay=data.ay(1:end-1);
    
    data.times=data.times(1:end-1);
    
    tau=t(end);
    