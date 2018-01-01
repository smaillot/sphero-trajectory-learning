function g=gen_dmp_param(par,data)
    % number of gaussian basis functions
    if ~isfield(par, 'ng')
        ng=len;
        par.ng=ng;
    else
        ng=par.ng;
    end

    % decay of s phase var
    if ~isfield(par, 'as')
        as=4;
        par.as=as;
    else
        as=par.as;
    end

    % init of phase var
    if ~isfield(par, 's')
        s=1;
        par.s=s;
    else
        s=par.s;
    end

    % time scaling constant
    if ~isfield(par, 'tau')
        % % tau should be duration of data
        % Miguel Prada and Anthony Remazeilles* Dynamic Movement Primitives for Human Robot interaction
    %     tau=max(data.times)-min(data.times);
        tau=max(data.times);
        par.tau=tau;
    else
        tau=par.tau;
    end


    % dynamical system parameters
    % alpha*beta=K   beta=(K-D)/tau ?
    % dynamical system
    % tau*tau*ydd = K*(g-y)-D*yd+(g-y0)*f;
    % tau*yd=yd;
    if ~isfield(par, 'K')
        K=5;
        par.K=K;
    else
        K=par.K;
    end
    % dynamical system parameters
    if ~isfield(par, 'D')
        D=5;
        par.D=D;
    else
        D=par.D;
    end

    % widths of gaussians
    if ~isfield(par, 'h')
        % widths of gaussians. same but maybe adjustable according to the movement
        % maybe? check this later.
        h=ones(1,ng)*1; 
        par.h=h;
    else
        h=par.h;
    end
    
    % centers of gaussian are placed even in s time
    if ~isfield(par, 'c')
        % gaussian centers are distributed evenly in s axis.
        incr=(max(stime)-min(stime))/(ng-1);
        c=min(stime):incr:max(stime);
        lrc=fliplr(c);
        ctime=(-1*tau*log(lrc))/as;
        d=diff(c);
        c=c/d(1); % normalize for exp correctness
        par.c=c;
    else
        c=par.c;
    end
    
    g.h=h;
    g.D=D;
    g.c=c;
    g.tau=tau;
    g.K=K;
    g.ng=ng;
    g.as=as;
    g.s=s;
    
end