% Plot the pathfrom early to late in the same session for same targets
% Before using this run: bhv2Struct = mlread and choose today's bhv2 file
% July 13th 2018
% Kathryn McIntosh 

function [] = plotTrials(bhv2Struct)

%How many trials were there in this experiment? 
dataDims = size(bhv2Struct); 
numTrials = dataDims(1,2);

trial = 1; %This will be the index so that we make sure we don't exceed 
         %dimensions of our data / go through all trials 
figure(4)
figure(3)
figure(2)
figure(1)


hold on

r = 13; % radius
N= 1000;

THETA=linspace(0,2*pi,N);
RHO=ones(1,N)*r;
center1 = [0,20];
center2 = [-20,0];
center3 = [0,-20];
center4 = [20,0];
color = 'b';

figure(1)
[X,Y] = pol2cart(THETA,RHO);
X=X+center1(1);
Y=Y+center1(2);
h=fill(X,Y,color);
axis([-15 15 -15 15])

figure(2)
[X,Y] = pol2cart(THETA,RHO);
X=X+center2(1);
Y=Y+center2(2);
h=fill(X,Y,color);
axis([-15 15 -15 15])

figure(3)
[X,Y] = pol2cart(THETA,RHO);
X=X+center3(1);
Y=Y+center3(2);
h=fill(X,Y,color);
axis([-15 15 -15 15])

figure(4)
[X,Y] = pol2cart(THETA,RHO);
X=X+center4(1);
Y=Y+center4(2);
h=fill(X,Y,color);
axis([-15 15 -15 15])

%Keep doing the stuff in this loop until the last trial
while trial < numTrials
    
    %Does this trial have a center fix error? (error missage 1 or 2)
    %1 means the joystick was not in the center at the start of the trial
    %2 means it was in the center at the start but it left too soon
    %if(bhv2Struct(trial).TrialError==1 || bhv2Struct(trial).TrialError==2)     
    if(bhv2Struct(trial).TrialError~=0) %For "only correct" (trialerror 0) case
        trial=trial+1; %There was a center fix error, move on to next trial
    else
    
        %No center fix error we're going to plot the attempt 
        %Extract the position samples from this trial 
        x=bhv2Struct(trial).AnalogData.Joystick(:,1); %Stored in col 1
        y=bhv2Struct(trial).AnalogData.Joystick(:,end); %Stored in col 2
        if bhv2Struct(trial).Condition == 4
            figure(4) 
            plot(x,y) 
        elseif bhv2Struct(trial).Condition == 3
            figure(3) 
            plot(x,y)
        elseif bhv2Struct(trial).Condition == 2
            figure(2) 
            plot(x,y)
        elseif bhv2Struct(trial).Condition == 1
            figure(1) 
            plot(x,y)
            
        end 
        trial = trial + 1; 
        hold on 
end 


end 