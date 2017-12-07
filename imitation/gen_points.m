function dat=gen_points(resolution,data)
    timec=gen_time(resolution,data);
    dat.y_xr=interp1(data.times,data.y_xr,timec);
    dat.y_yr=interp1(data.times,data.y_yr,timec);
    dat.yd_xr=interp1(data.times,data.yd_xr,timec);
    dat.yd_yr=interp1(data.times,data.yd_yr,timec);
    dat.ydd_xr=interp1(data.times,data.ydd_xr,timec);
    dat.ydd_yr=interp1(data.times,data.ydd_yr,timec);
    dat.times=timec;
end