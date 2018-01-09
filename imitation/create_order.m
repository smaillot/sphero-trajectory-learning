f = figure;
axis equal
xlim([0, 300])
ylim([0, 300])
[x, y] = getpts(f)
t = 1; % control period
speed = norm(