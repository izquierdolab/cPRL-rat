function main_learning_uncertainty(box, testMode, subName)
% keyboard controls found in key_capture

%% Initialize and Define Paths

% Clear and close screens
sca; clearvars -except box testMode subName; clc; close all;

filepath = fileparts( which( mfilename ) );
cd(filepath)
addpath(genpath(filepath));

% Load environment variable (RigEnvSpecifications.mat)
init_default_env(box);

DataDir = './SubjectData';


%% Set Globals

global setup continuing paused iStage tMain tImm


%% Get Function Inputs

% Prompt user if no subject initials given
if nargin < 3
    subName = input('Initials of subject? [tmp]  ','s');
end

% Default subject initials
if isempty(subName)
    subName = 'tmp';
end

% This number gives whether it is the first file/second file etc. saved for that day
sessionNum = 1;

fileName = [DataDir, '/', subName,'_', datestr(now,'yyyymmdd'),'_', num2str(sessionNum, '%02.f'), '.mat'];
while exist(fileName,'file')
    sessionNum = sessionNum + 1;
    fileName = [DataDir, '/', subName,'_', datestr(now,'yyyymmdd'),'_', num2str(sessionNum, '%02.f'), '.mat'];
end


%% Run Setup

setup = init_setup;
if testMode
    load('expr_test.mat', 'expr');
else
    expr = init_expr;
end


%% Generate Input By Block

if testMode
    load('input_test.mat', 'myinput');
else
    myinput = init_input(expr);
end
save(fileName,'expr','myinput','setup');


%% Initialize Necessary Devices

% If device set to eye tracker, initialize
if strcmp(setup.deviceName,'eye')
    if ~Eyelink('IsConnected')
        % Connect to eyelink
        Eyelink('initialize');
    end
    Eyelink('startrecording');
    % Test juicer, see if a click sound is heard
    reward_juice(.1);
end

% If set to touchscreen, initialize
if strcmp(setup.deviceName, 'touch')
    % Connect to Whisker server
    [tMain, tImm] = connect_whisker(env.whiskerServer);
    disp('Whisker server successfully connected');
    
    % Claim display for touchscreen
    setup_touchscreen(env.displayID);
    disp('Touchscreen successfully claimed');
    
    % Claim lines for tray light and feeder
    setup_pellet(env.trayLightLine, env.feederLine);
    disp('Feeder/traylight successfully claimed');
    
    % Test pellet dispenser
    reward_pellet(1);
end

% Otherwise, just proceed with key commands


%% Open Screen

[w, coords] = setup_screen;
if strcmp(setup.deviceName,'eye')
    % Draw fixation boxes on eyelink screen
    setup_eyelink(setup, coords)
end


%% Start Trial in Blocks

totalReward  = 0  ; blockReward = 0 ;
blockIndex = 1;
trialNum = 1;

% Binary values: rewarded or not
reward = [];

% 1 = left/up, 2 = right/down
choice = [];

% Binary values: whether choice was the better one or not
betterChoice = [];

responseTime = [];

vbl = start_check(w);
results.startTime = datetime('now');
fprintf('Experiment started at %s\n',datestr(results.startTime));
sessionStartTime = GetSecs;
continuing = 1; paused = 0;

try
    while continuing == 1
        %% Run main loop of experiment
        iStage = 1;
        while iStage < 6 && continuing == 1
            switch iStage
                case 1 % center fixation
                    [vbl] = obtain_initiation(w,coords);
                case 2 % cue presentation
                    fprintf('\n--- Block %d, trial %d ---\n', blockIndex, trialNum);
                    draw_stimulus(w,myinput(blockIndex).gaborTilt(trialNum), coords);
                    WaitSecs(setup.cueDur);
                    ITI(w,0.5)
                case 3 % target and choice
                    [responseTime(trialNum),choice(trialNum),betterChoice(trialNum)] = present_target(w,trialNum,myinput(blockIndex),coords);
                case 4 % reward
                    [reward(trialNum)] = present_reward(w,trialNum,vbl,myinput(blockIndex),coords,choice(trialNum));
                    % If rewarded, add to cumulative totals
                    if reward(trialNum) == 1
                        totalReward = totalReward + 1;
                        blockReward = blockReward + 1;
                    end
                case 5 % ITI draw blank screen
                    ITI(w,setup.ITI)        
            end
            
            %fprintf('trial %d, block index: %d, iStage: %d, paused: %d, contuining: %d\n\n', trialNum, blockIndex, iStage, paused, continuing);
            
            if paused == 1
                fprintf('Experiment paused, press G to continue...\n');
                
                % If just obtained reward, undo count to avoid overcounting
                if iStage == 4 && reward(trialNum) == 1
                    totalReward = totalReward - 1;
                    blockReward = blockReward - 1;
                end
                
                while paused == 1
                    Screen('FillRect',w,0);   % blank screen
                    vbl = Screen('Flip', w);
                    
                    % Wait for further key command
                    key_capture();
                end
                fprintf('Experiment unpaused\n\n');
            else
                % Repeat the stage if the experiment is paused or there is an error, otherwise proceed to next
                iStage = iStage + 1;
            end
        end
        
        %% Save Results
        results(blockIndex).choice = choice;
        results(blockIndex).betterChoice = betterChoice;
        results(blockIndex).responseTime = responseTime;
        results(blockIndex).reward = reward;
        save(fileName,'results','-append');
        
        %% Broadcast Results
        
        % Don't broadcast if stopped or paused
        %{
        if continuing == 1 && paused == 0
            disp(expr.Seq)
            disp(block_index)
            schedule = expr.Seq(block_index);
            fprintf('Trial # %i: RULE ''%s'', Prob L: %2.1f / R:%2.1f. ',trialNum,expr.schedulestring{schedule},[myinput(block_index).Prob_LU_RD(:,trialNum)]);
            fprintf('Choice: %s .',expr.sidestring{myinput(block_index).Stim(trialNum),choice(trialNum)});
            if reward(trialNum)==1
                fprintf('REWARDED =] ');
            else
                fprintf('UNREWARDED =[ ');
            end
            
            if myinput(block_index).betterChoice(trialNum) == choice(trialNum)
                fprintf('BETTER OPTION + \n');
            else
                fprintf('WORSE OPTION - \n');
            end
            
            if trialNum >= 20
                fprintf('Performance in the most recent 20 trials = %2.1f %% \n\n',nanmean(betterChoice(trialNum-19:trialNum))*100);
            else
                fprintf('Cumulative performance = %2.1f %% \n\n',nanmean(betterChoice(1:trialNum))*100);
            end
        end
        %}
        
        % Finish one block
        if trialNum == expr.nTrialsBlock
            fprintf('The total reward obtained in this block: %i \n\n', blockReward);
            trialNum = 0;
            blockIndex = blockIndex + 1;
            blockReward = 0;
            choice = []; betterChoice = []; responseTime = []; reward = [];
        end
        
        % Stop when all the blocks are run
        if blockIndex > expr.nBlocks
            continuing = 0;
        end
        
        % Proceed to the next trial
        trialNum = trialNum + 1;
        
    end
    
catch err
    
end


%% Cleanup Session
results(1).runTime = (GetSecs-sessionStartTime)/60;   % in minutes
results(1).endTime = datetime('now');
fprintf('Experiment ended at %s\n',datestr(results(1).endTime));
save(fileName,'setup','coords','results','-append');
fprintf('Total number of trials complete:  %i \n',(blockIndex-1)*expr.nTrialsBlock+trialNum-1);
fprintf('Total time (mins) taken for this session: %4.2f \n',results(1).runTime);
fprintf('Total reward obtained:  %i \n\n',totalReward);
% plot_performance(results,expr.nTrialsBlock);

% Remove eyelink/whisker settings
clean_up();

% Clear all screens
sca;

% Listen for keyboard input
ListenChar(1);

% Show mouse
ShowCursor;

% Report errors if any
if exist('err','var')
    % Save the whole workspace to work on error
    save('error.mat');
    fprintf('Something went wrong.\n')
    rethrow(err);
end


end
