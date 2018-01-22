function [data,r]=rollout_command( K, sigma, gamma, nb_update, theta_i, r,sph)
    addpath(['../imitation']);
    addpath(['../DMP-LWR']);
    for k=1:K

        %% Computation of the inputs
        eps = normrnd(0,(gamma^nb_update)*sigma,size(theta_i.x));
        theta_ir=theta_i.x+eps;
        r.w_x=theta_ir;
        data{k}{2}=eps;
        eps = normrnd(0,(gamma^nb_update)*sigma,size(theta_i.x));
        theta_ir=theta_i.y+eps;
        r.w_y=theta_ir;
        data{k}{4}=eps;
%         for a=1:2 %(generate random for x (1) or y (2) axis)
            
%             eps = normrnd(0,(gamma^nb_update)*sigma,size(theta_i.x));
%             sec_Term=[];
%             if a==1
%                 theta_ir=theta_i.x+eps;
%                 r.w_x=theta_ir;
%                 data{k}{2}=eps;
%             else
%                 theta_ir=theta_i.y+eps;
%                 r.w_y=theta_ir;
%                 data{k}{4}=eps;
%             end
%             u=[];
            
%             for j=1:length(g.times)
%                 basef=[];
%                 sum_base=0;
%                 for i = 1 : length(theta_i.x)
%                     basef=[basef;psiF(g.h, g.c, g.times(j), i)];
%                 end
%                 sum_base=sum(basef);
%                 basef=basef/sum_base;
%                 if a==1
%                     dx=(1-D*dt/tau)*dx+K*(gx-x)+theta_ir'*basef;
%                     x=dx*dt+x;
%                     pos_x=[pos_x,x];
%                     u=[u; dx];
%                     sec_Term=[sec_Term; theta_ir'*basef];
%                 else
%                     dy=(1-D*dt/tau)*dy+K*(gy-y)+theta_ir'*basef;
%                     y=dy*dt+y;
%                     pos_y=[pos_y,y];
%                     u=[u; dy];
%                     sec_Term=[sec_Term; theta_ir'*basef];
%                 end
%                 u=[u; theta_ir'*basef];
            %end
            
%              if a==1
%                 data{k}{1}=u;
%                  data{k}{2}=eps;
%                 data{k}{5}=sec_Term;
%                 data{k}{7}=pos_x;
%              elseif a==2
%                 data{k}{3}=u;
%                  data{k}{4}=eps;
%                 data{k}{6}=sec_Term;
%                 data{k}{8}=pos_y;
%              end
%         end
        result=dmpReplay(r);
        data{k}{1}=result.yd_xr;
        data{k}{2}=eps;
        data{k}{3}=result.yd_yr;
        data{k}{4}=eps;
        data{k}{5}=result.f_replay_x;
        data{k}{6}=result.f_replay_y;
        data{k}{7}=result.y_xr;
        data{k}{8}=result.y_yr;
        data{k}{9}=r.stime;
    end
end

function result=dmpReplay(r)

% set new x0 goal
if isfield(r, 'sx0')
    r.x0=r.sx0;
end

% set new gy0 goal
if isfield(r, 'sy0')
    r.y0=r.sy0;
end

% set new gx goal
if isfield(r, 'sgx')
    r.gx=r.sgx;
end

% set new gy goal
if isfield(r, 'sgy')
    r.gy=r.sgy;
end

% from now on it dmp replay and plots
f_replay_x=[];
fr_x_zeros=[];

f_replay_y=[];
fr_y_zeros=[];

ydd_x_r=0;
yd_x_r=0;
y_x_r=r.x0;
dtx=r.dt;

ydd_y_r=0;
yd_y_r=0;
y_y_r=r.y0;
dty=dtx;


% r.gx=r.gx*3/2;  % replay da goal'u scale edebilirim 


for j=1:length(r.times)
    psum_x=0; 
    pdiv_x=0;
    psum_y=0; 
    pdiv_y=0;
    for i=1:r.ng
        % I am dividing the stime with d1=which is the dt of movement
        % therefore I normalize the centers of gaussians 
        % which were evenly distributed in time before.
        % now they are evenly place with 1 sec time diff.
        psum_x=psum_x+psiF(r.h, r.c, r.stime(j)/r.d1,i)*r.w_x(i);
        pdiv_x=pdiv_x+psiF(r.h, r.c, r.stime(j)/r.d1,i);

        psum_y=psum_y+psiF(r.h, r.c, r.stime(j)/r.d1,i)*r.w_y(i);
        pdiv_y=pdiv_y+psiF(r.h, r.c, r.stime(j)/r.d1,i);
    end
% replay of f with trained weights
% ijspeert nc2013 page 333 formula 2.3
    f_replay_x(j)=(psum_x/pdiv_x)*r.stime(j)*(r.gx-r.x0);
    %? I had to put -1 here in saveddata. otherwise y axis was reverse
    f_replay_y(j)=(psum_y/pdiv_y)*r.stime(j)*(r.gy-r.y0); 

    %detect zero crossing. sign change and list them
    if(j>1)
       if sign(f_replay_x(j-1))~=sign(f_replay_x(j))
           fr_x_zeros=[fr_x_zeros j-1];
       end
       
       if sign(f_replay_y(j-1))~=sign(f_replay_y(j))
           fr_y_zeros=[fr_y_zeros j-1];
       end
    end
    
    % We are calculating accelleration with ftarget replays on the system
    % then calculate the velocity and accelleration.
    % glatzMaster page 8 / eq 2.1   
    % tau*ydd= K(g-x)-Dv+(g-x0)f
    ydd_x_r=(r.K*(r.gx-y_x_r)-(r.D*yd_x_r)+(r.gx-r.x0)*f_replay_x(j))/r.tau;
    yd_x_r= yd_x_r+ (ydd_x_r*dtx)/r.tau;
    y_x_r= y_x_r+ (yd_x_r*dtx)/r.tau;
    
    ydd_xr(j)=ydd_x_r;
    yd_xr(j)=yd_x_r;
    y_xr(j)=y_x_r;
    
    %%%%%%%
    ydd_y_r=(r.K*(r.gy-y_y_r)-(r.D*yd_y_r)+(r.gy-r.y0)*f_replay_y(j))/r.tau;
    yd_y_r= yd_y_r + (ydd_y_r*dty)/r.tau;
    y_y_r= y_y_r + (yd_y_r*dty)/r.tau;
    
    ydd_yr(j)=ydd_y_r;
    yd_yr(j)=yd_y_r;
    y_yr(j)=y_y_r;
end

result=r;
result.ydd_yr=ydd_yr;
result.yd_yr=yd_yr;
result.y_yr=y_yr;
result.ydd_xr=ydd_xr;
result.yd_xr=yd_xr;
result.y_xr=y_xr;
result.fr_x_zeros=fr_x_zeros;
result.fr_y_zeros=fr_y_zeros;

result.f_replay_x=f_replay_x;
result.f_replay_y=f_replay_y;


end

function r=psiF(h, c, s, i)
    r=exp(-h(i)*(s-c(i))^2);  % h= 1/(2c^2)
end