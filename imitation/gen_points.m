function dat=gen_points(resolution,data)
    timec=gen_time(resolution,data);
    dat.x=interp1(data.times,data.x,timec);
    dat.y=interp1(data.times,data.y,timec);
    dat.vx=interp1(data.times,data.vx,timec);
    dat.vy=interp1(data.times,data.vy,timec);
    dat.ax=interp1(data.times,data.ax,timec);
    dat.ay=interp1(data.times,data.ay,timec);
    dat.times=timec;
end