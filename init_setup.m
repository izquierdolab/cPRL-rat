function setup = init_setup

global env
%load('RigEnvSpecifications.mat', 'env');

% For turning feedback on or off
setup.feedbackOn = 1;

if env.box == 1
    % 0 = run full-screen, 1 = run in window
    setup.windowedMode = 0;
    setup.deviceName = 'touch';    % 'key', 'eye', or 'touch'
    setup.va2p = deg2px(1, env);   % pixels per visual degree
else
    setup.windowedMode = 1;
    % size of window, if windowedMode == 1
    setup.windowWidth = env.resolution.width*0.25;
    setup.windowHeight = env.resolution.height*0.3;
    setup.deviceName = 'key';
    setup.va2p = deg2px(0.25, env); 
end

% Reward amount parameters
setup.fixationJuiceAmount = .05;    % tiny reward for fixation
setup.rewardJuiceAmount = .2;
setup.manualJuiceAmount = .1;       % should be less than reward ideally
setup.rewardPelletAmount = 1;

% setup.pxErr = 200;                % radius of fixation position tolerance in pixels
setup.pxErr = setup.va2p * 1;

% Response/fixation time in seconds
% Change to 0.4 for monkeys, 0 for humans
setup.fixationTime = 0.4;
setup.responseTime = 40;            

% Feedback colors
setup.centerFeedback = [255 255 255];     % white
setup.neutralFeedback = [255 255 255];    % white
setup.correctFeedback = [0 255 0];        % green
setup.wrongFeedback = [255 0 0];          % red
setup.bgdColor = 0; %0.5                  % gray

% Screen parameters
%setup.modStimAction = 1;                      % same as stim1 (1) or stim2 (2)
setup.targRadius = round(setup.va2p*0.3) ;
setup.fixRadius = round(setup.va2p*0.3) ;     % for now, it can be changed in deg
setup.targSize = round(setup.va2p*0.3) ;      % size of target
setup.targSizeN = round(setup.va2p*3) ;       % size of choice/reward circle
setup.targDist = round(setup.va2p*5) ;        % target distance from center
setup.gaborSize = round(setup.va2p*5);        % size of Gabor stimulus (pixels)

% Time parameters (secs)
% setup.choicePresentationT = .5;    % not used in this task
setup.rewardPresentationT = 1.0 ;
setup.initDur = 40;                  % duration to initiate trial
setup.cueDur = 1;                    % Gabor stimulus duration
setup.dispDur = 40;                  % target display duration
setup.extraDur = .5;                 % Extra decision time after stimuli is removed duration
setup.fix = .4;                      % Delay after fixation complete
setup.beforeWait = [0.5 1];
setup.ITI = 1.5;              % inter-trial-interval in seconds

% Keyboard controls
KbName('UnifyKeyNames') ;
setup.leftKey = KbName('LeftArrow') ;         % left/up choice
setup.rightKey = KbName('RightArrow') ;       % right/down choice
setup.upKey = KbName('UpArrow') ;             % left/up choice
setup.downKey = KbName('DownArrow') ;         % right/down choice
setup.gpKey = KbName('g') ;                   % go key

% If testing on separate laptop, save setup to be imported
save('setup.mat', 'setup');

end