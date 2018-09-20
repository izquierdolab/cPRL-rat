function [thisResponseTime,thisChoice,thisBetterChoice] = present_target(w,trialNum,myinput,coords)

global continuing paused setup tMain tImm

% Initial default no response
responseOut = 0;

% Flush out messages from server
if strcmp(setup.deviceName, 'touch')
    while tMain.BytesAvailable > 0
        msg_cell = strsplit(fgetl(tMain));
    end
    while tImm.BytesAvailable > 0
        msg_cell = strsplit(fgetl(tImm));
    end
end
 
% Case 5 means dot in left/right, case 6 means dot in up/down
firstTarget = 5;
secondTarget = 5;

objCoords1 = coords.objCoordsL;
objCoords2 = coords.objCoordsR;

% Default output to prevent error crashing when paused/stopped
thisResponseTime = NaN;
thisChoice = NaN;
thisBetterChoice = NaN;

% Draw targets
draw_targets(w,firstTarget,secondTarget,coords);

% Output system time of flip
vbl = Screen('Flip', w);

% Assign this time to be the trial start time
tStart = vbl;

% Initialize the RT/trial duartion timer
tPresent = tStart;

% Repeat drawing
while (tPresent < tStart + setup.dispDur + setup.extraDur) && responseOut==0 && continuing==1 && paused==0
    if tPresent < tStart + setup.dispDur
        % target disappears after certain time, fixation strobe
        [responseOut, whichOut] = check_response_2AFC(objCoords1,objCoords2);

        % Wait for other key commands (pause, stop)
        key_capture();

        if responseOut
            fprintf('Response to targets was initiated\n');
            tFix = vbl;
        end
        
        % if working with eye tracker, do fixation analytics
        if strcmp(setup.deviceName,'eye')
            while responseOut == 1 && tFix-vbl < setup.fixationTime && continuing==1 && paused==0
                % Check for persistent fixation
                [responseOut, whichOut] = check_response_2AFC(objCoords1,objCoords2);

                % Wait for other key commands (pause, stop)
                key_capture();

                tFix = GetSecs; % how long is the fixation for
                if responseOut == 0
                    %fprintf('Fixation on target was broken\n'); % print fixation broken strobe
                elseif tFix-vbl > setup.fixationTime
                    %fprintf('Fixation on target was complete\n'); % print fixation complete strobe
                end
            end
        end
        
        draw_targets(w,firstTarget,secondTarget,coords);
    end
    % Now the stimulus is on screen
    vbl = Screen('Flip', w);
    
    % Get the present time for screen
    tPresent = vbl;
end

% Exit while loop if response is made
if responseOut
    thisResponseTime = GetSecs - tStart ;
    thisChoice = whichOut; % this line and below are to replace the original keyboard check
    if ~isnan(thisChoice)
        thisBetterChoice = (myinput.betterChoice(trialNum) == thisChoice);
    end
end

end
