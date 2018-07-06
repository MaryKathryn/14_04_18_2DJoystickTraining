% Find take off angle relative to trajectory of shortest path
% Before using this run: bhv2Struct = mlread and choose today's bhv2 file
% July 4th 2018
% Kathryn McIntosh 

function [takeOffAngles] = trajecEval(bhv2Struct)

takeOffAngles=[]; %Take-off angles relative to trajectory of shortest path
angleNumber=1; %Just the index used to add angles as they're calculated

%How many trials were there in this experiment? 
dataDims = size(bhv2Struct); 
numTrials = dataDims(1,2);

trial = 1; %This will be the index so that we make sure we don't exceed 
          %dimensions of our data / go through all trials
           
%Keep doing the stuff in this loop until the last trial
while trial < numTrials
    
    %Does this trial have a center fix error? (error missage 1 or 2)
    %1 means the joystick was not in the center at the start of the trial
    %2 means it was in the center at the start but it left too soon
    if(bhv2Struct(trial).TrialError==1 || bhv2Struct(trial).TrialError==2)
        trial=trial+1; %There was a center fix error, move on to next trial
    else
    
        %No center fix error so lets find out if a real attempt was made
        %Extract the position samples from this trial 
        x=bhv2Struct(trial).AnalogData.Joystick(:,1); %Stored in col 1
        y=bhv2Struct(trial).AnalogData.Joystick(:,end); %Stored in col 2
        
        %Was an attempt to hit the target made? We will decide that by 
        %looking at how much the position changes in x and y 
        %I chose 4 degrees of position change from the starting position 
        %(which should be almost 0,0)(because the fixation radius is 3 deg)
        
        %Get starting position 
        badStart = false; %Assume first tht we start at ~(0,0)
        startX=x(1);
        startY=y(1);
        
        %Make sure we start at ~(0,0)
        absStartX = abs(startX);
        absStartY = abs(startY);
        intStartX = fix(startX);
        intStartY = fix(startY);
        if intStartX>1 || intStartY>1 
            badStart = true; %We didnt start at 0, must do extra work
        end
        
        %Traverse x and y samples until you get a difference of > 4
        sampleDims=size(x);
        numSamples=sampleDims(1); %# of position samples I can check 
        sample=2; %Index to traverse through all samples 
        
        angleObtained=false;
        
        while(sample < numSamples && angleObtained==false)
            %Absolute difference between start x position and this sample
            
            if badStart == true %We didnt start at 0 
                fprintf('this trial is bad: %d \n',trial);
                while x(sample)<1 && y(sample)<1
                        sample = sample+1; %Keep  incrementing until (0,0)
                end
                badStart = false;
            end
            
            %Now we have a new sample number to start from if we started in
            %a weird place

            xdiff = abs(0 - abs(x(sample)));
            %Absolute difference between start y position and this sample
            ydiff = abs(0 - abs(y(sample))); 
           
             if  (xdiff<10 && ydiff<10)
                 %No attempt yet, move on to next position sample in trial
                 sample=sample+1; 
                 %printThisSamp = sample
             else
                 fprintf('%d %d %d \n',xdiff, ydiff, sample);
                 %An attempt is being made
                 %Make vector with this first sign of attempt, this will be
                 %the "take-off trajectory"
                 trajectory = [x(sample);y(sample)];
                 
                 %Now get the trajectory of the shortest path to the target
                 %This is just a vector to the center of the target
                 xTargCenter = bhv2Struct(trial).TaskObject.Attribute{1, 1}{1, 2}; %x component of target center 
                 yTargCenter = bhv2Struct(trial).TaskObject.Attribute{1, 1}{1, 3};  %y component of target center 
                 shortestTraj = [xTargCenter,yTargCenter];
                 
                 %Now we can find the angle between the take off trajectory
                 %and the shortest path trajectory (Theta) using the dot 
                 %product formula. 
                 
                 %CosTheta = dot(u,v)/(norm(u)*norm(v));
                 %ThetaInDegrees = acosd(CosTheta);
                 
                 cosTheta = dot(trajectory,shortestTraj)/(norm(trajectory)*norm(shortestTraj));
                 ThetaInDegrees = acosd(cosTheta);
                 
                 %Now we have our take-off angle relative to the trajectory
                 %angle of the shortest path, lets save it in a variable we
                 %can output 
                 
                takeOffAngles(angleNumber)=ThetaInDegrees;
                angleNumber=angleNumber+1;
                angleObtained = true;
                fprintf("angle obtained for trial %d \n", trial );
             end %If statement for checking position difference
        end %While statement for number of position samples in this trial
        trial = trial+1;
    end
end%while statement for number of trials

%Plot the take off angles against the valid attempts 
goodAttempts = size(takeOffAngles);
xAxisPoints = goodAttempts(1,2);
xAxis = linspace(1,xAxisPoints, xAxisPoints);
plot(xAxis, takeOffAngles)


end

%We finished all the trials in this data file. Lets plot take off angle vs
%valid trial number. 

% Find take off angle relative to trajectory of shortest path
% Before using this run: bhv2Struct = mlread and choose today's bhv2 file
% July 4th 2018
% Kathryn McIntosh 

function [takeOffAngles] = trajecEval(bhv2Struct)

takeOffAngles=[]; %Take-off angles relative to trajectory of shortest path
angleNumber=1; %Just the index used to add angles as they're calculated

%How many trials were there in this experiment? 
dataDims = size(bhv2Struct); 
numTrials = dataDims(1,2);

trial = 1; %This will be the index so that we make sure we don't exceed 
          %dimensions of our data / go through all trials
           
%Keep doing the stuff in this loop until the last trial
while trial < numTrials
    
    %Does this trial have a center fix error? (error missage 1 or 2)
    %1 means the joystick was not in the center at the start of the trial
    %2 means it was in the center at the start but it left too soon
    if(bhv2Struct(trial).TrialError==1 || bhv2Struct(trial).TrialError==2)
    %if(bhv2Struct(trial).TrialError~=0) %For "only correct" case
        trial=trial+1; %There was a center fix error, move on to next trial
    else
    
        %No center fix error so lets find out if a real attempt was made
        %Extract the position samples from this trial 
        x=bhv2Struct(trial).AnalogData.Joystick(:,1); %Stored in col 1
        y=bhv2Struct(trial).AnalogData.Joystick(:,end); %Stored in col 2
        
        %Was an attempt to hit the target made? We will decide that by 
        %looking at how much the position changes in x and y 
        %I chose 4 degrees of position change from the starting position 
        %(which should be almost 0,0)(because the fixation radius is 3 deg)
        
        %Get starting position 
        badStart = false; %Assume first tht we start at ~(0,0)
        startX=x(1);
        startY=y(1);
        
        %Make sure we start at ~(0,0)
        absStartX = abs(startX);
        absStartY = abs(startY);
        intStartX = fix(startX);
        intStartY = fix(startY);
        if intStartX>1 || intStartY>1 
            badStart = true; %We didnt start at 0, must do extra work
        end
        
        %Traverse x and y samples until you get a difference of > 4
        sampleDims=size(x);
        numSamples=sampleDims(1); %# of position samples I can check 
        sample=2; %Index to traverse through all samples 
        
        angleObtained=false;
        
        while(sample < numSamples && angleObtained==false)
            %Absolute difference between start x position and this sample
            
            if badStart == true %We didnt start at 0 
                %fprintf('this trial is bad: %d \n',trial);
                while x(sample)<1 && y(sample)<1
                        sample = sample+1; %Keep  incrementing until (0,0)
                end
                badStart = false;
            end
            
            %Now we have a new sample number to start from if we started in
            %a weird place

            xdiff = abs(0 - abs(x(sample)));
            %Absolute difference between start y position and this sample
            ydiff = abs(0 - abs(y(sample))); 
           
             if  (xdiff<10 && ydiff<10)
                 %No attempt yet, move on to next position sample in trial
                 sample=sample+1; 
                 %printThisSamp = sample
             else
                 %fprintf('%d %d %d \n',xdiff, ydiff, sample);
                 %An attempt is being made
                 %Make vector with this first sign of attempt, this will be
                 %the "take-off trajectory"
                 trajectory = [x(sample);y(sample)];
                 
                 %Now get the trajectory of the shortest path to the target
                 %This is just a vector to the center of the target
                 xTargCenter = bhv2Struct(trial).TaskObject.Attribute{1, 1}{1, 2}; %x component of target center 
                 yTargCenter = bhv2Struct(trial).TaskObject.Attribute{1, 1}{1, 3};  %y component of target center 
                 shortestTraj = [xTargCenter,yTargCenter];
                 
                 %Now we can find the angle between the take off trajectory
                 %and the shortest path trajectory (Theta) using the dot 
                 %product formula. 
                 
                 %CosTheta = dot(u,v)/(norm(u)*norm(v));
                 %ThetaInDegrees = acosd(CosTheta);
                 
                 cosTheta = dot(trajectory,shortestTraj)/(norm(trajectory)*norm(shortestTraj));
                 ThetaInDegrees = acosd(cosTheta);
                 
                 %Now we have our take-off angle relative to the trajectory
                 %angle of the shortest path, lets save it in a variable we
                 %can output 
                 
                takeOffAngles(angleNumber)=ThetaInDegrees;
                angleNumber=angleNumber+1;
                angleObtained = true;
                %fprintf("angle obtained for trial %d \n", trial );
             end %If statement for checking position difference
        end %While statement for number of position samples in this trial
        trial = trial+1;
    end
end%while statement for number of trials

%We finished all the trials in this data file. Lets plot take off angle vs
%valid attempt number.  
goodAttempts = size(takeOffAngles);
xAxisPoints = goodAttempts(1,2);
xAxis = linspace(1,xAxisPoints, xAxisPoints);
plot(xAxis,takeOffAngles,'-ro','LineWidth',2);
title('Take-off Angles')
xlabel('Attempt Number')
ylabel('Take-off Angle')
end





