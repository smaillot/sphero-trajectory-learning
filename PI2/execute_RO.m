function data=execute_RO(control, init_pos, g, K)
    % We have g a structure with 3 lists. The first one is c for all the
    % gaussian, then h and the time
    prompt='Begin ? {y/n}';
    uiwait(msgbox('execute the first roll out?','Data_Collecting','modal'))
    x=inputdlg(prompt);
    x=x{1};
    for k=1:K
        speed.x=[];
        speed.y=[];
        com_speed=[];
        com_angle=[];
        if x='y'
            for j=1:2
                if j==1
                    speed.x=control.x{k};
                else
                    speed.y=control.y{k};
                end
            end
            for i=1:length(g.times)
                com_speed=[com_speed, sqrt(speed.x(i)^2+speed.y(i)^2)];
                com_angle=[com_angle, atan2(speed.y(i),speed.x(i))*180/3.14];
            end
            command=cat(1,com_speed,com_angle,g.times);
            
            %% Command Part of Susana
            
        
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
    
    