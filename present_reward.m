function [thisReward] = present_reward(w,trialNum,vbl,myinput,coords,thisChoice)

global setup

% Define targets and coords to be used in functions
%{
if myinput.Stim(trialNum) == 1
    firstTarget = myinput.Stim(trialNum) + 4;
    secondTarget = myinput.Stim(trialNum) + 4;
    % see draw_simple_targets.m
    % case 5 means dot in left/right, case 6 means dot in up/down
    sideIndex = thisChoice ;
elseif myinput.Stim(trialNum) == 2 % modulatory
    firstTarget = setup.modStimAction + 4;
    secondTarget = setup.modStimAction + 4;
end
%}
% Case 5 means dot in left/right, case 6 means dot in up/down
firstTarget = 5;
secondTarget = 5;

% Specify some parameters for reward display
thisReward = myinput.reward(thisChoice,trialNum);

% Visual feedback if the choice is rewarded
if thisReward
    feedbackColor(thisChoice,:) = setup.correctFeedback;
else
    feedbackColor(thisChoice,:) = setup.wrongFeedback;
end

unchosen = setdiff(1:2,thisChoice);
% Visual feedback if the choice is rewarded
if myinput.reward(unchosen,trialNum)
    feedbackColor(unchosen,:) = setup.correctFeedback;
else
    feedbackColor(unchosen,:) = setup.wrongFeedback;
end

tStart = GetSecs;
tPresent = tStart;
rewardPresentationT = setup.rewardPresentationT ;  % how long is the reward feedback duration

% Neutral feedback if visual feedback off
if setup.feedbackOn == 0
    feedbackColor = repmat(setup.neutralFeedback,2,1);
end

while tPresent < tStart + rewardPresentationT
    draw_targets(w,firstTarget,secondTarget,coords,thisChoice,thisReward);
    vbl = Screen('Flip', w, vbl + 0.5 * coords.ifi);
    tPresent = vbl;
    key_capture();
end

if thisReward
    if strcmp(setup.deviceName,'eye')
        reward_juice(setup.rewardJuiceAmount);
    elseif strcmp(setup.deviceName, 'touch')
        reward_pellet(setup.rewardPelletAmount);
    end
end


end