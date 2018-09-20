function [vbl] = obtain_initiation(w,coords)

global setup continuing paused tImm

tStart = GetSecs;
vbl = tStart;
flag = 0;

% ITI: Draw fixation point for random time U(0.5, 1.5)
% draw fixation object (dot)
draw_initiation(w,setup.centerFeedback,coords.fixCoords,'dot');
vbl = Screen('Flip', w);

% Ensure tray light and feeder are off
if strcmp(setup.deviceName, 'touch')
    fprintf(tImm, 'LineSetState Feeder off');
    fprintf(tImm, 'LineSetState TrayLight off');
end

%%%% To-do: printstrobe(fixation dot appear); %%%%%%
while flag~=1 && continuing==1 && paused~=1
    if strcmp(setup.deviceName,'eye')
        flag = get_eye_fixation(coords.center,setup.pxErr);
        %{
        if flag
            %fprintf('Fixation on dot was initiated\n'); % print fixation start strobe %
            tfix = vbl;
        end
        while flag == 1 && tfix-vbl < setup.responseTime && paused~=1
            flag = get_eye_fixation(coords.center,setup.pxErr); % check fixation here
            tfix = GetSecs; % how long is the fixation for
            if flag == 0
                % fprintf('Fixation on dot was broken\n');
                % print fixation broken strobe
            elseif tfix-vbl >setup.responseTime
                % fprintf('Fixation on dot was complete\n');
                % print fixation complete strobe
            end
        end
        %}
    elseif strcmp(setup.deviceName, 'touch')
        [flag, ~] = get_touch(setup.pxErr, coords.center);
    else
        flag = 1;
    end
    draw_initiation(w,setup.centerFeedback,coords.fixCoords,'dot');
end

% If response made, change color of dot
if flag == 1
    draw_initiation(w,setup.correctFeedback,coords.fixCompleteCoords,'dot');
    vbl = Screen('Flip', w);
end

WaitSecs(setup.fix);


end