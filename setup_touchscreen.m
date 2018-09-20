function setup_touchscreen(displayID)

global tMain tImm

% Claim line for touchscreen
fprintf(tImm, sprintf('DisplayClaim %d', displayID));
if ~(strcmp(fgetl(tImm), 'Success') && strcmp(fgetl(tMain), sprintf('Info: ClaimAccepted: Display %d', displayID)))
    error('Failed to claim display');
end
% t_main.BytesAvailable and t_imm.BytesAvailable should now both be zero

% Get display size
fprintf(tImm, sprintf('DisplayGetSize %d', displayID));
display_size_cell = strsplit(fgetl(tImm));
width = str2num(display_size_cell{1, 2});
height = str2num(display_size_cell{1, 3});

% Create touchscreen document
fprintf(tImm, 'DisplayCreateDocument touchscreen');
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to create document touchscreen');
end

% Set document size to display size
fprintf(tImm, sprintf('DisplaySetDocumentSize touchscreen %d %d', width, height));
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to set document touchscreen size');
end

% Show touchscreen document on display
fprintf(tImm, sprintf('DisplayShowDocument %d touchscreen', displayID));
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to show touchscreen document on display');
end

% Create and set touch event on document background
fprintf(tImm, 'DisplaySetBackgroundEvent touchscreen TouchDown TouchDetected');
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to set touch event on document');
end

% Record coordinates of all touch events
fprintf(tImm, 'DisplayEventCoords on');
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to set event coords on');
end

end

