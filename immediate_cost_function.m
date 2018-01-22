function [ cost ] = immediate_cost_function( state, goal, control )
%IMMEDIATE_COST_FUNCTION Compute the immediate cost function from current
% and goal states (x;y;t) and control action (vx;vy).
    R = eye(2);
    cost = state_dep(state-goal) + 0.5 * control' * R * control;
end

function cost = state_dep( state )
    cost = norm(state(1:2));
end