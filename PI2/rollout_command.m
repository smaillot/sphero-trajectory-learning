function [data,r]=rollout_command( K, sigma, gamma, nb_update, theta_i, r)
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
        data{k}{1}=result.yd_xr
        data{k}{2}=eps;
        data{k}{3}=result.yd_yr
        data{k}{4}=eps;
        data{k}{5}=result.f_replay_x;
        data{k}{6}=result.f_replay_y;
        data{k}{7}=result.y_xr;
        data{k}{8}=result.y_yr;
        data{k}{9}=r.stime;
    end
