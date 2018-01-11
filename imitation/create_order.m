f = figure;
axis equal
xlim([0, 300])
ylim([0, 300])
[x, y] = getpts(f)
close(f)
t = 1; % control period
v = [diff(x)',x(1)-x(end) ; diff(y)',y(1)-y(end)];
speed = sqrt(v(1,:).^2 + v(2,:).^2);
angle = atan2(v(2,:), v(1,:));