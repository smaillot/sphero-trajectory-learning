function [ cost ] = cost_function( dmp_traj, record_traj, terminal_ratio )
%COST_FUNCTION Summary compute the total cost to evaluate the current
%trajectory with the current parameters
%It is assumed that both time series have been interpolated with the same
%time vector.
    delta = dmp_traj(1:2,:) - record_traj(1:2,:);
    dist = sqrt(delta(1,:).^2+delta(2,:).^2));
    cost = (1 - terminal_ratio) * mean(dist) + terminal_ratio * terminal_cost(dmp_traj(1:2,end),record_traj(1:2,:), 1);
end