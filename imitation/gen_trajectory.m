function input_matrix=gen_trajectory(r,Xo,Yo,alpho,tau,resolution)
    timec=gen_time(resolution,r);
    x=[Xo];
    y=[Yo];
    vx=[0];
    vy=[0];
    alpha=[alpho];
    speed=[0];
    
    for k=1:length(timec)-1
        
        incr=timec(k+1)-timec(k);
        f=weigh_sum_basis_func(r,k,timec);
        vx=[vx (1-incr*r.D/tau)*vx(k)+incr/tau*((r.K)*(r.gx-x(k))+(r.w_x)*f*(r.gx-Xo))];
        vy=[vy (1-incr*r.D/tau)*vy(k)+incr/tau*((r.K)*(r.gy-y(k))+(r.w_y)*f*(r.gy-Yo))];
        speed=[speed norm([vx(k);vy(k)])];
        x=[x incr*vx(k+1)+x(k)];
        y=[y incr*vy(k+1)+y(k)];
        
        if vx(k)~=0 && vy(k)~=0
            alpha=[alpha atan2(vx(k),vy(k))*180/pi];
        else
            alpha=[alpha alpha(k)];
        end
        
    end
    input_matrix=cat(1,speed,alpha,timec);
end
