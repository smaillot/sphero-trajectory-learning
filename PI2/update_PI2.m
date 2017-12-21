function theta=update_PI2(Path_weight, M, epsi, K, r)
    % This function update the theta
    dtheta=[];
    ddtheta=[];
    for i=1:length(M{1}(2,:))
        compdtheta=0;
        for j=1:K
            compdtheta=compdtheta+Path_weight(j)*M{j}(1,i)*epsi(j);
        end 
        dtheta=[dtheta, compdtheta];
    end 
    for j=1:size(dtheta,1)
        comp=0;
        const=0;
        for i=1:length(M{1}(2,:))
           comp=comp+(length(M{1}(2,:))-i)*dtheta(j,i)
           const=const+(length(M{1}(2,:))-i)
        end  
    end
