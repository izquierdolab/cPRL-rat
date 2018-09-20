% Choose screen with maximum id - the secondary display:
load('RigEnvSpecifications.mat', 'env');
screenID = env.screenNumber;

PsychImaging('PrepareConfiguration');

% Open a window on that display
% Choose a background color of 0.5 = gray with 50% max intensity
rect = [0 0 200 300];
%w = PsychImaging('OpenWindow', screenID, 0.5);
[w, coords] = setup_screen;
% [windowPtr, windowRect] = PsychImaging('OpenWindow', screenid, [backgroundcolor], ....);

% Test your function here that requires a screen to run
tilt = 90;
%draw_stimulus(w, tilt, coords)

%draw_initiation(w, [255, 255, 255], coords.fixCoords)
%vbl = Screen('Flip', w);

draw_targets(w, 5, 5, coords, 2, 1); vbl = Screen('Flip', w);

