function r=basis_parameter(desPath, param)
    
    stime = [];
    for i=1:length(desPath(3,:))
        t=desPath(3,i);
        s=exp((-1*param.as*t)/param.tau);
        stime=[stime s];
    end
    
    incr=(max(stime)-min(stime))/(param.ng-1);
    c=min(stime):incr:max(stime);
    lrc=fliplr(c);
    ctime=(-1*param.tau*log(lrc))/param.as;
    d=diff(c);
    c=c/d(1); % normalize for exp correctness
    r.d1=d(1);
    r.c=c;
    r.ctime=ctime;
    r.times=desPath(3,:);
    r.h=ones(1,param.ng);
end