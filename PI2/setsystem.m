%%
function setsystem(sph)
% set every rotation time last 10 seconds
sph.MotionTimeout=10; 

%Turn on handshaking 
sph.Handshake = 1;  

%turn on the back LED
sph.BackLEDBrightness = 255; 

%Calibrate the orientation of the sphero.
% Use this command with different values of the angle in order to 
% initialize the orientation of the Sphero in the desired direction.
calibrate(sph, 0); 

% turn on the collision detection
sph.CollisionDetection=1;
end