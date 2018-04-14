%joystick training task phase 1 
%timing file

joystickTarget = 1; %So we can remember what this task object is 
toggleobject(joystickTarget, 'eventmarker', 10, 'status','on'); %show the target, mark this with behavioural code 10
showcursor(1) %show the joystick cursor on screen 

% [ontarget rt] = eyejoytrack(fxn, object_number, threshold(degrees of visual angle)% how big the invisible target circle is, duration(ms))
[ontarget rt] = eyejoytrack('acquiretarget', joystickTarget, 8, 5000);   
if ~ontarget, 
    trialerror(2); % no or late response (did not land on either the target or distractor) ontarget will return 0
    toggleobject([joystickTarget])
    return
end

trialerror(0); % correct
goodmonkey(50, 3); % 50ms of juice x 3

