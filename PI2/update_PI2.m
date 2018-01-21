function theta_i=update_PI2( theta_i, control, Path_weight, M, K, basis)
    % This function update the theta
    % Initialization 
    addpath('../DMP-LWR')
    dtheta=[];
    ddtheta=[];
    sum_base=0;
    basef=[];
    w=[];
    N=length(control{1}{1});
    
    for i=1:length(control{1}{1}) % Through the time
        compdtheta=0;
        for j=1:K % Through the iterations
            compdtheta=compdtheta+M(:,:,i,j)*cat(2,control{j}{2},control{j}{4})*Path_weight(:,i,j); % For me before, M was a number and not a matrix
        end 
        ddtheta(:,i)=compdtheta;
    end
    a=ddtheta
    for k=1:length(theta_i)
        comp=0;
        const=0;
        for i=1:N-1
            comp=comp+(N-i)*psiF(basis.h, basis.c, basis.stime(i)/basis.d1, k)*ddtheta(k,i);
            const=const+(N-i)*psiF(basis.h, basis.c, basis.stime(i)/basis.d1, k);
        end
        dtheta(k)=comp/const;
    end  
    b=dtheta
    
    theta_i=theta_i+dtheta(:,1);
end 

function r=psiF(h, c, s, i)
    r=exp(-h(i)*(s-c(i))^2);  % h= 1/(2c^2)
end

