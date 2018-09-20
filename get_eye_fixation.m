function flag = get_eye_fixation(objCoords, pxErr) 
% returns flag = 1 when fixation is initiated

% need object coords and err (in pixels) this can be converted from degree
% actually don't bother, we can convert that to degrees later,
% 15 pixels seems to be a good radius or maybe use 1.5*radius?
global env
% env.eyeside = 1;  %1= left 2= right
% For different monkeys/rigs the eye tracked might be different

% Watch for keyboard interaction
key_capture();

% Successful fixation flag
flag = 0;

% Eyelink function to get eye position in screen coordinates
e = Eyelink('NewestFloatSample');
x = e.gx(env.eyeside);      % x gaze
y = e.gy(env.eyeside);      % y gaze
pup = e.pa(env.eyeside);    % pupil size

xpos = objCoords(1);
ypos = objCoords(2);

% Check pupil size and difference in both directions error margin
if (pup > 0) && (abs(x-xpos) <= pxErr) && (abs(y-ypos) <= pxErr)
    flag = 1;
end

            

end