% Example Calibration code
% for i = 1:100
% reward_juice(.1);
% pause(.5);
% end
% To Get The Amount Each 0.1 s Call, divide the total amount of juice
% obtained after running this code and divde by 100.

function reward_juice(rewardDuration)
% calls the juicer for the time stated in input
% the exact amount in ml is dependent by juicer and could be calibrated

try
    %Pin 17/P0.0 (Juicer 1) and 25/GND(ground)
    %Pin 18/P0.1 (Juicer 2) and 26/GND(ground)
    warning('off','all');
    global sess;
    sess = daq.createSession('ni');
    addDigitalChannel(sess,'Dev3','Port2/line0:1','OutputOnly'); % This is the rig-specific part
    
    % outputSingleScan(s,[1 0])= juicer1
    % outputSingleScan(s,[0 1])= juicer2
    outputSingleScan(sess,[1 0]);
    tic;
    while toc < rewardDuration
    end
    outputSingleScan(sess,[0 0]);
    
    pause(0.001);

catch
    
end

end