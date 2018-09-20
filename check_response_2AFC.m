function [responseOut,whichOut] = check_response_2AFC(objCoords1,objCoords2)
% check for keyboard/eye/joystick response for 2AFC task

global setup
load('setup.mat', 'setup');

if ~isfield(setup,'deviceName')
    error('You need to state the input deviceName in the setup');

elseif strcmp(setup.deviceName,'key')
    %deviceType = 1;
    FlushEvents('keyDown');

    % Look for response (left/right key)
    [~, ~, keyCode] = KbCheck;
    if objCoords1(2) == objCoords2(2) % if same y coordinates
        temp = keyCode([setup.leftKey,setup.rightKey]);
    else
        temp = keyCode([setup.upKey,setup.downKey]);   
    end
    out1 = temp(1);   out2 = temp(2);

elseif strcmp(setup.deviceName,'eye')
    %deviceType = 2;
    pxErr = setup.pxErr; % fixation window radius in pixels
    out1 = get_eye_fixation(objCoords1, pxErr);
    out2 = get_eye_fixation(objCoords2, pxErr);
    
elseif strcmp(setup.deviceName, 'touch')
    pxErr = setup.pxErr; % fixation window radius in pixels
    [out1, out2] = get_touch(pxErr, objCoords1, objCoords2);

end

% Binary flag for whether there is a response
responseOut = xor(out1,out2);

% 1 if left/up chosen, 2 if right/down chosen
whichOut = find([out1,out2]);

end