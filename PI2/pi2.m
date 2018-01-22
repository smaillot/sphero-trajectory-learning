function theta = pi2(param, cost_function, r, sigma, theta_i, K, init_pos, gamma, desPath, sph)
    % parameters :
    % r : immediate cost, 
    % theta_i, initial weights of the basis function
    % phi : terminal cost, 
    % g : basis function from the system dynamics, contain h, c and time 
    % sigma : variance of the mean-zero noise
    % theta_i : initial parameter vector, 
    % K : number of roll-outs per update,
    % init_pos: initial osition of the robot
    % gamma: the reduction of the variance of the noise with the number of
    % roll out
    % nb_update: number of update of the parameters
    % param contain the parameters of the dynamical equation, K, D, tau, dt
    addpath('../DMP-LWR')
    
    hold on
    tolerance = 1e-5;
    S_last = zeros(length(param.times),2 ,K);
    S_k = [];
    M_k.x = [];
    M_k.y = [];
    nb_update=0;
    theta=theta_i;
    S2=0;
    S1=100;
    z=0;
    
    while max(S1,S2) > tolerance && z<50
        
        if z>=1
            S_last=S_k;
        end
        S_last;
        S_k = [];
        M_k.x = [];
        M_k.y = [];
        r.ng=param.ng;
        r.dt=param.dt(1);
        r.x0=init_pos(1);
        r.y0=init_pos(3);
        r.gx=param.gx;
        r.gy=param.gy;
        r.K=param.K;
        r.D=param.D;
        r.tau=param.tau;
        
        [contr, r]=rollout_command( K, sigma, gamma, nb_update, theta_i, r);
%        plot_trajectory(contr,K)
%        data=execute_RO(contr, init_pos, param, K, sph); % in commentary when we test the algorithm
        
        
        
        for j=1:K
            [ M, S ] = rollout_iteration( theta, r, cost_function, contr{j}, desPath);
            S_k = cat(3,S_k,S'); 
            M_k.x = cat(4, M_k.x, M.x);
            M_k.y = cat(4, M_k.y, M.y);
        end
        
        P = compute_P(S_k);
        Sl1=S_last(:,:,1);
        Sl2=S_last(:,:,2);
        if size(S_last(:,:,1))~=size(S_k(:,:,1))
            Sl1=S_last(:,:,1)';
        end
        if size(S_last(:,:,2))~=size(S_k(:,:,2))
            Sl2=S_last(:,:,2)';
        end
        S1=norm(S_k(:,:,1)-Sl1);
        S2=norm(S_k(:,:,2)-Sl2);
        if max(S1,S2) > tolerance
            theta.x=update_PI2( theta.x, contr, P, M_k.x, K, r);
            theta.y=update_PI2( theta.y, contr, P, M_k.y, K, r);
        end
        z=z+1;
        a=theta.x;
        b=theta.y;
        r.w_x=theta.x;
        r.w_y=theta.y;
        result=dmpReplay(r);
        plot(result.y_xr,result.y_yr)
    end
end

function P=compute_P(S_k)
    lambda=50;
    P=[];
    sum_P_i=[];
    for a=1:2
        for i=1:size(S_k, 1)
            sum_at_i=0;
            for k=1:size(S_k, 3)
                sum_at_i=sum_at_i+exp(-(1/lambda)*S_k(i,a,k));
            end
            sum_P_i=[sum_P_i,sum_at_i];
        end
        for k=1:size(S_k, 3)
            for i=1:size(S_k, 1)
                P(a,i,k)= exp(-(1/lambda)*S_k(i,a,k))/sum_P_i(i);
            end
        end
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