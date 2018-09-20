function init_default_env(box)

global env

env.box = box;

% Setup the environment struct - used by many task functions
portraitMode = 0;

% Rat chamber specific parameters (look up using Whisker settings and I/O map)
switch box
    case 1
        env.whiskerServer = '127.0.0.1';      % Whisker server IPv4 address
        env.displayID = 0;                    % touchscreen display ID in Whisker
        env.trayLightLine = 33;               % digital line for tray light
        env.feederLine = 34;                  % digital line for feeder
        env.screenNumber = 0;                 % monitor number
        %env.screenNumber = max(Screen('Screens'));
    case 2
        env.whiskerServer = '127.0.0.1';
        env.displayID = 1;
        env.trayLightLine = 41;
        env.feederLine = 42;
        env.screenNumber = 2;
    case 3
        env.whiskerServer = '127.0.0.1';
        env.displayID = 2;
        env.trayLightLine = 49;
        env.feederLine = 50;
        env.screenNumber = 3;
    case 4
        env.whiskerServer = '127.0.0.1';
        env.displayID = 3;
        env.trayLightLine = 57;
        env.feederLine = 58;
        env.screenNumber = 4;
    case 5
        env.whiskerServer = '192.168.1.12';
        env.displayID = 0;
        env.trayLightLine = 33;
        env.feederLine = 34;
        env.screenNumber = 1;
    case 6
        env.whiskerServer = '192.168.1.12';
        env.displayID = 1;
        env.trayLightLine = 41;
        env.feederLine = 42;
        env.screenNumber = 2;
    case 7
        env.whiskerServer = '192.168.1.12';
        env.displayID = 2;
        env.trayLightLine = 49;
        env.feederLine = 50;
        env.screenNumber = 3;
    case 8
        env.whiskerServer = '192.168.1.12';
        env.displayID = 3;
        env.trayLightLine = 57;
        env.feederLine = 58;
        env.screenNumber = 4;
    case 0   % testing on laptop or getting dummy human data
        env.screenNumber = 0;
end
        
env.resolution = Screen('Resolution',env.screenNumber);

if portraitMode
    temp = env.resolution.width;
    env.resolution.width = env.resolution.height;
    env.resolution.height = env.resolution.width;
end

env.pixwidth = env.resolution.width;
env.distance = 100;              % in cm, monkey from screen
env.physicalWidth = 30;          % in cm, width of the visible screen
env.rigID = 'Office';
env.eyeside = 1;                 %1= left 2= right

save('RigEnvSpecifications.mat','env');

end
