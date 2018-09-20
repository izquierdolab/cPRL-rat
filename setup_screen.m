function [w, coords] = setup_screen

global env setup
% if working outside main_learning_uncertainty loop then run:
       load('RigEnvSpecifications.mat', 'env');
       setup = init_setup;

% Determine which monitor in the rig for the task display
screenID = env.screenNumber;
% screenId = max(Screen('Screens'));
screenColor = setup.bgdColor;
windowedMode = setup.windowedMode; % 0 = run full-screen, 1 = run in window

% Make sure this is running on OpenGL Psychtoolbox:
AssertOpenGL;

% Low latency sound playback for making the beeps!
InitializePsychSound(1);

Screen('Preference','SkipSyncTests', 1);
Screen('Preference', 'SuppressAllWarnings', 1);
PsychImaging('PrepareConfiguration'); % configuration
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');

if ~windowedMode
    % Open screen full screen
    [w, rect] = PsychImaging('OpenWindow', screenID, screenColor);
    % w is the window ID I think? rect is a vector of position
    % 0 is the background color?
else
    % Run as a small window
    [w, rect] = PsychImaging('OpenWindow', screenID,screenColor, [0,0,setup.windowWidth,setup.windowHeight]);
end
% Now the onscreen window is ready for drawing and display of stimuli

% Retrieve video redraw interval for later control of our animation timing
ifi = Screen('GetFlipInterval', w);

% Make sure the GLSL shading language is supported: whatever that is
AssertGLSL;

Screen('BlendFunction', w, GL_ONE, GL_ONE);
Screen('TextFont', w, 'Arial');
Screen('TextSize', w, 25);
KbReleaseWait;    % wait until all keys on the keyboard are released

% Call to state where to draw whatever given the screen resolution
coords = setup_coords;
coords.ifi = ifi;

end