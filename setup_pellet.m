function setup_pellet(trayLightLine, feederLine)

global tMain tImm

% Claim line for trayLight
fprintf(tImm, sprintf('LineClaim %d -alias TrayLight', trayLightLine));
if ~(strcmp(fgetl(tImm), 'Success') && strcmp(fgetl(tMain), sprintf('Info: ClaimAccepted: Line %d -output, alias TrayLight', trayLightLine)))
    error('Failed to claim line for tray light');
end

% Claim line for feeder
fprintf(tImm, sprintf('LineClaim %d -alias Feeder', feederLine));
if ~(strcmp(fgetl(tImm), 'Success') && strcmp(fgetl(tMain), sprintf('Info: ClaimAccepted: Line %d -output, alias Feeder', feederLine)))
    error('Failed to claim line for feeder');
end


end

