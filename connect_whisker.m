function [tMain, tImm] = connect_whisker(server)

global tMain tImm

tMain = tcpip(server, 3233);
fopen(tMain);
disp('trying...');
try
    % Info: WhiskerServer v1.0, ...
    msg = fgetl(tMain);
    disp(msg);

    % Info: You are client number XXX
    msg = fgetl(tMain);
    disp(msg);

    % ImmPort: XXXX
    msg = fgetl(tMain);
    disp(msg);
    portImm = str2num(msg(10:end));

    % Code: X_XX
    msg = fgetl(tMain);
    disp(msg);
    codeImm = msg(7:end);
    
    % Create and connect to immediate socket
    tImm = tcpip(server, portImm);
    fopen(tImm);
    fprintf(tImm, sprintf('Link %s', codeImm));
catch
    error('Could not find immediate socket port or code');
end

disp('getting tImm confirmation...');
% Immediate socket should send 'Success' message
if ~strcmp(fgetl(tImm), 'Success')
    error('Failed to link to immediate socket');
end

end