function data=execute_RO(control, init_pos, g, K,data)
    % We have g a structure with 3 lists. The first one is c for all the
    % gaussian, then h and the time
    prompt='Begin ? {y/n}';
    uiwait(msgbox('execute the first roll out?','Data_Collecting','modal'))
    x=inputdlg(prompt);
    x=x{1};
    com_speed=[];
    com_angle=[];
    for k=1:K
        speed.x=[];
        speed.y=[];
        com_speed=[];
        com_angle=[];
        if x=='y'
            for j=1:2
                if j==1
                    speed.x=control{k}{1};
                else
                    speed.y=control{k}{3};
                end
            end
            for i=1:length(g.times)
                com_speed=[com_speed, sqrt(speed.x(i)^2+speed.y(i)^2)];
                com_angle=[com_angle, atan2(speed.y(i),speed.x(i))*180/3.14];
            end
            command=cat(1,com_speed,com_angle,g.times);
            
            %% Command Part of Susana
            a=cputime;
            % send command to sphero
            sph.Motiontimeout=0.2;
            roll(sph,command(1),command(2));
            % Here you have the the matrix command. 
            %The firstline is the amplitude of the speed, the second line
            %is the angle and the last line is the time of application of
            %the command.
            
             % get sensor data
            [xcur, ycur, ~, ~, ~] = sph.readLocator();
            s = [double(xcur);double(ycur);command(3)+cputime-a];
            data=[data,s];
            % For the output we would like the position of the robot and
            % the time when the measure was taken in a matrix (the first
            % line is the x position, the second line is the y position and
            % the last line is the time of aquisition of the position. And 
            % this for each roll out. (A list of matrix)  
            
        
        %% End of command part
        strcat('roll out number',num2str(k));
        end
        prompt='end of recording';
        uiwait(msgbox('Execute the next roll out?','Data_Collecting','modal'))
        x=inputdlg(prompt);
        x=x{1};
        if x=='n'
            break;
        end
    end
    