%% include folders libraries

currmfile = mfilename('fullpath');
currPath = currmfile(1:end-length(mfilename()));

addpath([currPath 'sphero-video-pose-estimation']);

%% connect sphero and set the system parameters (heading,collision detection...)

cam = init_ipcam();

%%

sph = sphero();
sph.Color = [0 0 255];
sph.BackLEDBrightness = 255;


%% save the data

sph.MotionTimeout=2;
espeed = 30; % exploration speed
t0=cputime;

pose = get_position(cam);

x=pose(1);
y=pose(2);
[xcur, ycur, ~, ~, ~] = sph.readLocator();
pos2 = [xcur, ycur];
x2 = pos2(1);
y2 = pos2(2);
vid = [];
binvid = [];

t=0;
for i=0:90:180
tic
result = roll(sph, espeed, i);
    while toc<2

            [pos, ~, binim] = get_position(cam);
            [xcur, ycur, ~, ~, ~] = sph.readLocator();
            pos2 = [xcur, ycur];
            x(end+1)=pos(1);
            y(end+1)=pos(2);
            x2(end+1)=pos2(1);
            y2(end+1)=pos2(2);
            t(end+1) = cputime-t0;
            vid = cat(4, vid, snapshot(cam));
            binvid = cat(3, binvid, binim);
    end
end
tic
result = roll(sph, espeed, 270);

while toc<3
    
        [pos, ~, binim] = get_position(cam);
        [xcur, ycur, ~, ~, ~] = sph.readLocator();
        pos2 = [xcur, ycur];
        x(end+1)=pos(1);
        y(end+1)=pos(2);
        x2(end+1)=pos2(1);
        y2(end+1)=pos2(2);
        t(end+1) = cputime-t0;
        vid = cat(4, vid, snapshot(cam));
        binvid = cat(3, binvid, binim);
end
x2 = x2 - x2(1);
y2 = y2 - y2(1);