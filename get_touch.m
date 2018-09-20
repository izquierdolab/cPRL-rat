function [flag1, flag2] = get_touch(pxErr, objCoords1, objCoords2)
% returns flag = 1 when touch is detected

global tMain

% Watch for keyboard interaction
key_capture();

% If only one coords given, set as center / trial initiation
if nargin < 3
    
    % Successful fixation flags
    flag1 = 0; flag2 = 0;

    xpos = objCoords1(1); ypos = objCoords1(2);

    % Get touch position in screen coordinates
    if tMain.BytesAvailable > 0
        msg_cell = strsplit(fgetl(tMain));
        if strcmp(msg_cell{1, 1}, 'Event:') && strcmp(msg_cell{1, 2}, 'TouchDetected')
            x = str2num(msg_cell{1, 3});
            y = str2num(msg_cell{1, 4});
            % Check deviation in both directions
            if (abs(x-xpos) <= pxErr) && (abs(y-ypos) <= pxErr)
                flag1 = 1;
            end
        end
    end
    
% If two coords given, target choice
elseif nargin == 3

    % Successful fixation flags
    flag1 = 0; flag2 = 0;

    xpos1 = objCoords1(1); ypos1 = objCoords1(2);
    xpos2 = objCoords2(1); ypos2 = objCoords2(2);

    % Get touch position in screen coordinates
    if tMain.BytesAvailable > 0
        msg_cell = strsplit(fgetl(tMain));
        if strcmp(msg_cell{1, 1}, 'Event:') && strcmp(msg_cell{1, 2}, 'TouchDetected')
            x = str2num(msg_cell{1, 3});
            y = str2num(msg_cell{1, 4});

            % Check flag 1
            if (abs(x-xpos1) <= pxErr) && (abs(y-ypos1) <= pxErr)
                flag1 = 1;
                %fprintf('xdiff: %d, ydiff: %d, pxErr: %d, flag1 --> 1\n', abs(x-xpos1), abs(y-ypos1), pxErr);
            end

            % Check flag 2
            if (abs(x-xpos2) <= pxErr) && (abs(y-ypos2) <= pxErr)
                flag2 = 1;
                %fprintf('xdiff: %d, ydiff: %d, pxErr: %d, flag2 --> 1\n', abs(x-xpos2), abs(y-ypos2), pxErr);
            end
        end
    end
end

    
end