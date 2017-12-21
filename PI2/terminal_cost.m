function psi_N=terminal_cost(final_point,goal_point, penalization)
    % This function takes as an entry the the final point of the roll-out
    % and the goal both in the form (x;y). 
    % The output is a radial penalization of the distance between the final
    % point of the roll out and the goal
    d=norm(final_point-goal_point);
    psi_N=penalization*d;
end
    
    