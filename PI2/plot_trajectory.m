function plot_trajectory(command,K)
    hold on
    for k=1:K
        plot(command{k}{7},command{k}{8})
    end
end

