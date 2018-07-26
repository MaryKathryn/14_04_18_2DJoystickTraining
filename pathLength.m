function [pathLengths] = pathLength(bhv2Struct)

%How many trials were there in this experiment? 
dataDims = size(bhv2Struct); 
numTrials = dataDims(1,2);

trial = 1; %This will be the index so that we make sure we don't exceed 
         %dimensions of our data / go through all trials 
pathLengths = []; % Will fill with the path lengths for each trial 
pathNumber = 1; %index for filling path lengths array 


         
while trial < numTrials
    
    trialDistance = 0;
    
    %Does this trial have a center fix error? (error missage 1 or 2)
    %1 means the joystick was not in the center at the start of the trial
    %2 means it was in the center at the start but it left too soon
    %if(bhv2Struct(trial).TrialError==1 || bhv2Struct(trial).TrialError==2)  
    if(bhv2Struct(trial).TrialError~=0)
         trial=trial+1; %There was a center fix error, move on to next trial
    else
        x=bhv2Struct(trial).AnalogData.Joystick(:,1); %Stored in col 1
        y=bhv2Struct(trial).AnalogData.Joystick(:,end); %Stored in col 2
        i=1;
        
        %Traverse x and y samples
        sampleDims=size(x);
        numSamples=sampleDims(1); %# of position samples I can check 
        sample=2; %Index to traverse through all samples 
        
        while(sample < numSamples)
            if(x(sample) == x(sample+1) && y(sample) == y(sample+1)) 
                %the current position is the same as the next one - move on
                sample = sample + 1;
            else
                points = [x(sample), y(sample); x(sample+1), x(sample+1)];
                distance = pdist(points,'euclidean');
                trialDistance = trialDistance + distance;
                sample = sample + 1;
            end
        end
        %Now we have our total distance travelled for this trial. Add it to
        % the array of paths and move on to the next trial 
         pathLengths(pathNumber)=trialDistance;
         pathNumber = pathNumber + 1;
         trial = trial + 1;
        
    end

    goodAttempts = size(pathLengths);
    xAxisPoints = goodAttempts(1,2);
    xAxis = linspace(1,xAxisPoints, xAxisPoints);
    plot(xAxis,pathLengths,'-bo','LineWidth',2);
    title('July 13th Path Lengths (Correct)')
    xlabel('Trial Number')
    ylabel('Path Length')
end