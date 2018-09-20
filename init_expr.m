function expr = init_expr

expr.gaborTilt(1) = 90;   % main, vertical
expr.gaborTilt(2) = 0;    % mod, horizontal

% Define sequence of stimuli to appear in order
% Each number represents a single block
expr.seq = [12, 12, 12];      % "Stim 1 and m"

expr.stimCombination{1} = [1];   expr.scheduleString{1} = 'stim 1 only';
expr.stimCombination{2} = [2];   expr.scheduleString{2} = 'stim m only';

% Reserve some slots (4-10) to other stimuli
expr.stimCombination{12} = [1 2];       expr.scheduleString{12} = 'stim 1, m';

% Define switch length for stimuli [1 m]
expr.switchLength = [20 45];

% Set block length so that there is at least one switch per stimulus
expr.nTrialsBlock = 1*2*max(expr.switchLength);
expr.nBlocks = length(expr.seq);
expr.nTrialsTotal = expr.nTrialsBlock * expr.nBlocks;

% Define probabilistic choices, can be changed to [0.7; 0.3] for example
prob = [0.75; 0.25];

% Randomize which side is first
nFlip = randi([0 1], 2, 1);   % random 0 or 1, twice
if nFlip(1)
    expr.prob{1,1} = prob;
else
    expr.prob{1,1} = flipud(prob);
end
if nFlip(2)
    expr.prob{2,1} = [1; 0];
else
    expr.prob{2,1} = [0; 1];
end

% Define actions to be Left/Right or Up/Down
%expr.modStimAction = setup.modStimAction;
expr.sideString{1,1} = 'Left';   expr.sideString{1,2} = 'Right';
expr.sideString{2,1} = 'Left';   expr.sideString{2,2} = 'Right';

save('expr.mat', 'expr');

end