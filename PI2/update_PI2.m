function theta_i=update_PI2( theta_i, control, Path_weight, M, K, g)
    % This function update the theta
    % Initialization 
    theta={};
    theta{1}=[];
    theta{2}=[];
    dtheta={};
    ddtheta={};
    ddtheta{1}=[];
    ddtheta{2}=[];
    dtheta{1}=[];
    dtheta{2}=[];
    sum_base=0;
    N=length(g.times);
    basef=[];
    w=[];
    
    for a=1:2
        for i=1:size(Path_weight,2) % Through the time
            compdtheta=0;
            for j=1:K % Through the iterations
                compdtheta=compdtheta+Path_weight(:,i,j)*M(:,:,i,j)*control{j}{2*a}; % For me before, M was a number and not a matrix
            end 
            ddtheta{a}=[ddtheta{a}, compdtheta];
        end
        for k=1:length(theta_i.x)
            comp=0;
            const=0;
            for i=1:N-1
                if a==1
                    comp=comp+(N-i)*psiF(g.h, g.c, g.times(i), k)*ddtheta{a}(k,i);
                    const=const+(N-i)*psiF(g.h, g.c, g.times(i), k);
                else
                    comp=comp+(N-i)*psiF(g.h, g.c, g.times(i), k)*ddtheta{a}(k,i);
                    const=const+(N-i)*psiF(g.h, g.c, g.times(i), k);
                end
            end
            dtheta{a}=[dtheta{a}; comp/const];
        end  
        if a==1
            theta_i.x=theta_i.x+dtheta{a};
        else
            theta_i.y=theta_i.y+dtheta{a};
        end
    end
