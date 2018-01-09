function input_struct=init_PI2_learning()
    %% PMD parameter
    dlg_title="choose PMD parameter";
    prompt={'ng, number of gaussian', 'as, decrease of the time dx/dt = as*x','s, initial time','K, Stifness coefficient', 'D, Damping coefficient'};
    default={'20','1','1','5000','500'};
    uiwait(msgbox('Choose PMD parameter','Parameter','modal'))
    num_lines = 1;
    answer= inputdlg(prompt,dlg_title,num_lines, default);
    uiwait(msgbox('PMD parameter entered','Parameter','modal'))
    input_struct.PMD.ng=str2num(answer{1});
    input_struct.PMD.as=str2num(answer{2});
    input_struct.PMD.s=str2num(answer{3});
    input_struct.PMD.K=str2num(answer{3});
    input_struct.PMD.D=str2num(answer{3});
    %% Cost function parameter
    
    dlg_title="choose cost function parameter";
    prompt={'p, penalization of final point Psi_N=p*distance(final_point_roll_out, goal)', 'R, minimization of input amplitude u^T.R.u','parameter_following_path','viapoint','viapoint gain'};
    default={'10','[1 0;0 1]','1','n','n'};
    uiwait(msgbox('Choose cost parameter','Parameter','modal'))
    num_lines = 1;
    answer2= inputdlg(prompt,dlg_title,num_lines, default);
    uiwait(msgbox('Cost parameter entered','Parameter','modal'))
    input_struct.cost_function.pena_final=str2num(answer2{1});
    input_struct.cost_function.pena_input=str2num(answer2{2});
    input_struct.cost_function.pena_path=str2num(answer2{3});
    if answer2{4}~='n'
        input_struct.cost_function.viapoint=str2num(answer2{4});
        input_struct.cost_function.viapointgain=str2num(answer2{5});
    end
    
    %% Number of roll out per upgrade
    
    dlg_title="choose cost function parameter";
    prompt={'K, number of roll out'};
    default={'2'};
    uiwait(msgbox('Choose number of roll out','Parameter','modal'))
    num_lines = 1;
    answer3= inputdlg(prompt,dlg_title,num_lines, default);
    input_struct.nb_roll_out.K=str2num(answer3{1});
    
    %% initial parameter (Theta)
    
    dlg_title="choose initial weights of your basis functions";
    a='Enter your vector of weights [ ; ; ;... ; ] (';
    b='times)';
    prompt={cat(2,a,num2str(g.ng),b)};
    uiwait(msgbox('Choose initial weights','Parameter','modal'))
    num_lines = 1;
    answer= inputdlg(prompt,dlg_title,num_lines, default);
    theta_i=str2num(answer);
    
end

function psi_N=terminal_cost(final_point,goal_point, penalization)
    %This function takes as an entry the the final point of the roll-out
    % and the goal both in the form (x;y). 
    % The output is a radial penalization of the distance between the final
    % point of the roll out and the goal
    d=norm(final_point-goal_point);
    psi_N=penalization*d;
end
    
    