function theta_i=update_PI2( theta_i, control, Path_weight, M, K, basis)
    % This function update the theta
    % Initialization 
    addpath('../DMP-LWR')
    dtheta=[];
    ddtheta=[];
    sum_base=0;
    basef=[];
    w=[];
    N=size(Path_weight,2);
    
    for i=1:size(Path_weight,2) % Through the time
        compdtheta=0;
        for j=1:K % Through the iterations
            compdtheta=compdtheta+Path_weight(:,i,j)*M(:,:,i,j)*cat(2,control{j}{2},control{j}{4})'; % For me before, M was a number and not a matrix
        end 
        ddtheta(:,:,i)=compdtheta;
    end
    ddtheta
    for a=1:2
        for k=1:length(theta_i.x)
            comp=0;
            const=0;
            for i=1:N-1
                if a==1
                    comp=comp+(N-i)*psiF(basis.h, basis.c, basis.times(i), k)*ddtheta(a,k,i);
                    const=const+(N-i)*psiF(basis.h, basis.c, basis.times(i), k);
                else
                    comp=comp+(N-i)*psiF(basis.h, basis.c, basis.times(i), k)*ddtheta(a,k,i);
                    const=const+(N-i)*psiF(basis.h, basis.c, basis.times(i), k);
                end
            end
            dtheta(k,a)=comp/const;
        end  
    end
    theta_i.x=theta_i.x+dtheta(:,1);
    theta_i.y=theta_i.y+dtheta(:,2);


