load('control2.mat');
for j = 1 : 1
calibrate(sph,0)
speed = 7*control2(1,:);
angle = control2(2,:)*180/pi;
time = control2(3,:);

k = length(time);
ts = 0.6;
sph.MotionTimeout=ts;
i=1;

t0=cputime;
[xcur, ycur, ~, ~, ~] = sph.readLocator();
x2 = double(xcur);
y2 = double(ycur);
t = 0;
while i<=k
    roll(sph,speed(i),angle(i));
    [xcur, ycur, ~, ~, ~] = sph.readLocator();
    x2(end+1) = double(xcur);
    y2(end+1) = double(ycur);
    t(end+1) = cputime-t0;
    i=i+10;
end
    [xcur, ycur, ~, ~, ~] = sph.readLocator();
    x2(end+1) = double(xcur);
    y2(end+1) = double(ycur);
    t(end+1) = cputime-t0;

    data.rollout{1,j}=[x2;y2;t];
    x2=[];
    y2=[];
    t=[];
end