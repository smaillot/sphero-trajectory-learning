function data=rollout_command(param,pos_ini, K, sigma, gamma, nb_update, theta_i, g)
    for k=1:K
        %% initialization
        x=pos_ini(1);
        dx=pos_ini(2);
        y=pos_ini(3);
        dy=pos_ini(3);
        K=param.K;
        D=param.D;
        tau=param.tau;
        dt=param.dt(1);
        gx=param.gx;
        gy=param.gy;
        sec_Term=[];
        pos_x=[pos_ini(1)];
        pos_y=[pos_ini(2)];
        %% Computation of the inputs
        for a=1:2 %(generate random for x (1) or y (2) axis)
            eps = normrnd(0,(gamma^nb_update)*sigma,size(theta_i.x));
            if a==1
                theta_ir=theta_i.x+eps;
            elseif a==2
                theta_ir=theta_i.y+eps;
            end
            u=[];
            
            for j=1:length(g.times)
                basef=[];
                sum_base=0;
                for i = 1 : length(theta_i.x)
                    basef=[basef;psiF(g.h, g.c, g.times(j), i)];
                end
                sum_base=sum(basef);
                basef=basef/sum_base;
                if a==1
                    dx=(1-D*dt/tau)*dx+K*(gx-x)+theta_ir'*basef;
                    x=dx*dt+x;
                    pos_x=[pos_x,x];
                    u=[u; dx];
                    sec_Term=[sec_Term; theta_ir'*basef];
                else
                    dy=(1-D*dt/tau)*dy+K*(gy-y)+theta_ir'*basef;
                    y=dy*dt+y;
                    pos_y=[pos_y,y];
                    u=[u; dy];
                    sec_Term=[sec_Term; theta_ir'*basef];
                end
                u=[u; theta_ir'*basef];
            end
            
            if a==1
                data{k}{1}=u;
                data{k}{2}=eps;
                data{k}{5}=sec_Term;
                data{k}{7}=pos_x;
            elseif a==2
                data{k}{3}=u;
                data{k}{4}=eps;
                data{k}{6}=sec_Term;
                data{k}{8}=pos_y;
            end
        end
    end
