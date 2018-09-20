function reward_pellet(rewardAmount)
% rewards given number of pellets

global tImm

% Ensure tray light off and turn on
fprintf(tImm, 'LineSetState TrayLight off');
fprintf(tImm, 'LineSetState TrayLight on');
if ~strcmp(fgetl(tImm), 'Success') && ~strcmp(fgetl(tImm), 'Success')
    error('Failed to turn tray light on');
end

% Turn feeder on/off repeatedly for however many rewards
for i=1:rewardAmount
    fprintf(tImm, 'LineSetState Feeder off');
    fprintf(tImm, 'LineSetState Feeder on');
    if ~strcmp(fgetl(tImm), 'Success') && ~strcmp(fgetl(tImm), 'Success')
        error('Failed to dispense pellet');
    end
end

end

