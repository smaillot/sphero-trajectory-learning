function input_struct=init_PI2_learning()
    %% PMD parameter
    dlg_title="choose PMD parameter";
    prompt={'ng, number of gaussian', 'as, decrease of the time dx/dt = as*x','s, initial time','K, Stifness coefficient', 'D, Damping coefficient','tau'};
    default={'2','1','1','1','1','1'};
    uiwait(msgbox('Choose PMD parameter','Parameter','modal'))
    num_lines = 1;
    answer= inputdlg(prompt,dlg_title,num_lines, default);
    uiwait(msgbox('PMD parameter entered','Parameter','modal'))
    input_struct.PMD.ng=str2num(answer{1});
    input_struct.PMD.as=str2num(answer{2});
    input_struct.PMD.s=str2num(answer{3});
    input_struct.PMD.K=str2num(answer{4});
    input_struct.PMD.D=str2num(answer{5});
    input_struct.PMD.tau=str2num(answer{6});
    
    %% Iteration parameter
    dlg_title="choose iteration parameter";
    prompt={'Gamma'};
    default={'0.98'};
    uiwait(msgbox('Choose iteration parameter','Parameter','modal'))
    num_lines = 1;
    answer5= inputdlg(prompt,dlg_title,num_lines, default);
    uiwait(msgbox('Iteration parameter entered','Parameter','modal'))
    input_struct.iteration.gamma=str2num(answer5{1});
    
    
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
    b='times) for x';
    prompt={cat(2,a,num2str(input_struct.PMD.ng),b)};
    default={'[0;0]'};
    uiwait(msgbox('Choose initial weights','Parameter','modal'))
    num_lines = 1;
    answer4= inputdlg(prompt,dlg_title,num_lines, default)
    input_struct.theta_i.x=str2num(answer4{1});
    
    dlg_title="choose initial weights of your basis functions";
    a='Enter your vector of weights [ ; ; ;... ; ] (';
    b='times) for y';
    prompt={cat(2,a,num2str(input_struct.PMD.ng),b)};
    uiwait(msgbox('Choose initial weights','Parameter','modal'))
    num_lines = 1;
    answer4= inputdlg(prompt,dlg_title,num_lines, default)
    input_struct.theta_i.y=str2num(answer4{1});
    
end

function psi_N=terminal_cost(final_point,goal_point, penalization)
    %This function takes as an entry the the final point of the roll-out
    % and the goal both in the form (x;y). 
    % The output is a radial penalization of the distance between the final
    % point of the roll out and the goal
    d=norm(final_point-goal_point);
    psi_N=penalization*d;
end
    
    