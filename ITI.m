function ITI(windowPtr, dt)
% Draw the blank screen for a period of time
%   windowPtr: window ID
%   dt: length of delay in seconds

global setup

if nargin < 2
    dt = setup.ITI;
end

tStart = GetSecs;
tPresent = tStart;
while tPresent < tStart + dt
    % Make each trial is at least dt seconds by increasing ITI
    vbl = Screen('Flip', windowPtr);
    tPresent = vbl;

    % Wait for other key commands (pause, stop)
    key_capture();
end

end
