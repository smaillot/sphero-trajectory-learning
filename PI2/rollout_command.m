function data=rollout_command(K, sigma, gamma, nb_update, theta_i, g)
    for k=1:K
        for a=1:2 %(generate random for x (1) or y (2) axis)
            eps = normrnd(0,(gamma^nb_update)*sigma,size(theta_i));
            if a==1
                theta_ir=theta_i.x+eps;
            elseif a==2
                theta_ir=theta_i.y+eps;
            end
            u=[];
            for j=1:length(g.times)
                basef=[];
                sum_base=0;
                for i = 1 : length(theta_i)
                    basef=[basef;psiF(g.h, g.c, g.times(j), i)]
                end
                sum_base=sum(basef);
                basef=basef/sum_base;
                u=[u; theta_ir'*basef]
            end
            if a==1
                data.x{k}=u;
            elseif a==2
                data.y{k}=u;
            end
        end
    end
