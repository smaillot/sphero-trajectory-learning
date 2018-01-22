function control=execute_RO(control, init_pos, g, K, sph)
    % We have g a structure with 3 lists. The first one is c for all the
    % gaussian, then h and the time
    data=[];
    max_speed = 60;
%     prompt='Begin ? {y/n}';
%     uiwait(msgbox('execute the first roll out?','Data_Collecting','modal'))
%     x=inputdlg(prompt);
%     x=x{1};
    pause();
    com_speed=[];
    com_angle=[];
    for k=1:K
        speed.x=[];
        speed.y=[];
        com_speed=[];
        com_angle=[];
%         if x=='y'
            for j=1:2
                if j==1
                    speed.x=control{k}{1};
                else
                    speed.y=control{k}{3};
                end
            end
            command=cat(1,min(max_speed, sqrt((speed.x).^2+(speed.y).^2)),atan2(speed.x,speed.y)*180/pi);
            
            %% Command Part of Susana
            % send command to sphero
%             dt = g.times(end)-g.times(end-1);
            dt=0.3;
            sph.MotionTimeout = dt;
            
            for i= 1:size(command,2)
            roll(sph,command(1,i),command(2,i));
            tic
            while toc < dt + 0.01
            [xcur, ycur, ~, ~, ~] = sph.readLocator();
            if length(data)==0
                s = [double(xcur);double(ycur);toc];
            else
            s = [double(xcur)/100;double(ycur)/100;data(3,end)+toc];
            end
            data=[data,s];
            control{k}{7} = data(1,:);
            control{k}{8} = data(2,:);
            control{k}{9} = data(3,:);
            end
            end
            figure(2);
            hold on
            plot(data(1,:),data(2,:));
            % Here you have the the matrix command. 
            %The firstline is the amplitude of the speed, the second line
            %is the angle and the last line is the time of application of
            %the command.
            
             % get sensor data

            % For the output we would like the position of the robot and
            % the time when the measure was taken in a matrix (the first
            % line is the x position, the second line is the y position and
            % the last line is the time of aquisition of the position. And 
            % this for each roll out. (A list of matrix)  
            
        
        %% End of command part
        strcat('roll out number',num2str(k));

        pause();
        calibrate(sph,0);
        end
%         prompt='end of recording';
%         uiwait(msgbox('Execute the next roll out?','Data_Collecting','modal'))
%         x=inputdlg(prompt);
%         x=x{1};
%         if x=='n'
%             break;
%         end
    end