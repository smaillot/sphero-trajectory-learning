function r=basis_parameter(desPath, param)
    incr=(max(desPath(3,:))-min(desPath(3,:)))/(param.ng-1);
    c=min(desPath(3,:)):incr:max(desPath(3,:));
    lrc=fliplr(c);
    ctime=(-1*param.tau*log(lrc))/param.as;
    d=diff(c);
    c=c/d(1); % normalize for exp correctness
    r.c=c;
    r.ctime=ctime;
    r.times=desPath(3,:);
    r.h=ones(1,param.ng);
end