function a = key_capture()

global setup continuing paused skip

KbName('UnifyKeyNames')
goKey = KbName('G');
stopKey = KbName('ESCAPE');
pauseKey = KbName('P');
reward = KbName('space');
%lessJuice = KbName('DownArrow');
%moreJuice = KbName('UpArrow');
nextTrial = KbName('N');

[keyIsDown,~,keyCode] = KbCheck;
if keyCode(stopKey)
    a = -1;
    continuing = 0;
elseif keyCode(goKey)
    a = 1;
    paused = 0;
    continuing = 1;
elseif keyCode(reward)
    a = 2;
    %reward_juice(setup.manualJuiceAmount);
elseif keyCode(pauseKey)
    a = 3;
    paused = 1;
%{
elseif keyCode(lessJuice)
    a = 4;
    setup.rewardJuiceAmount = setup.rewardJuiceAmount*.8;
elseif keyCode(moreJuice)
    a = 5;
    setup.rewardJuiceAmount = setup.rewardJuiceAmount*1.2;
%}
elseif keyCode(nextTrial)
    a = 6;
    skip = 1;
else
    a = 0;
end

while keyIsDown
    [keyIsDown,~,keyCode] = KbCheck; % Not sure whether we need this
end

%fprintf('keyIsDown: %d\n', keyIsDown);


end