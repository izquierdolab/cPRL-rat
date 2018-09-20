%% Set Up and Load Data

% Clear and close screens
clear;
set(0,'defaultAxesFontSize',12);

% Load file
DataDir = '../SubjectData/';
subName = 'BY45';
mydate = '20180818';
sessionNum = 1;
fileName = [subName, '_', mydate, '_', num2str(sessionNum, '%02.f'), '.mat'];
load(fullfile(DataDir,fileName));

% Concatenate blocks
tempResults = struct('choice', [], 'betterChoice', [], 'reward', []);
tempInput = struct('betterChoice', [], 'stimulus', [], 'prob', []);
for blockIndex = 1:3
    tempResults.choice = [tempResults.choice results(blockIndex).choice];
    tempResults.betterChoice = [tempResults.betterChoice results(blockIndex).betterChoice];
    tempResults.reward = [tempResults.reward results(blockIndex).reward];
    tempInput.betterChoice = [tempInput.betterChoice myinput(blockIndex).betterChoice];
    tempInput.stimulus = [tempInput.stimulus myinput(blockIndex).stim];
    tempInput.prob = [tempInput.prob myinput(blockIndex).prob];
end
results = tempResults;
myinput = tempInput;

[~,myinput.betterChoice] = max(myinput.prob);

numCompleteTrials = length(results.reward);


%% WSLS Individual

% Filter out trials with main stimulus
reward = results.reward(myinput.stimulus == 1);
betterChoice = myinput.betterChoice(myinput.stimulus == 1);
choice = results.choice(myinput.stimulus == 1);

% Count total number of left, right, rewarded, unrewarded
ri = find(choice-1);
le = find(~(choice-1));
re = find(reward);
un = find(~reward);

% Count number of intersections
leRe = length(intersect(le, re));
riRe = length(intersect(ri, re));
leUn = length(intersect(le, un));
riUn = length(intersect(ri, un));

switches = zeros(2);
for i=1:length(reward)-1
    if choice(i) ~= choice(i+1)
        % increment ++
        temp = switches((choice(i)==1)+1, (reward(i)==0)+1);
        switches((choice(i)==1)+1, (reward(i)==0)+1) = temp + 1;
    end
end

switches = num2cell(reshape(switches, [1, 4]));
[leReSw, riReSw, leUnSw, riUnSw] = deal(switches{:});

counts = [leRe, riRe, leUn, riUn, leReSw, riReSw, leUnSw, riUnSw];
save([subName, '_WSLS.mat'], 'counts');

%% Plot WSLS Individual Results

leReFrac = counts(5)./counts(1);
riReFrac = counts(6)./counts(2);
leUnFrac = counts(7)./counts(3);
riUnFrac = counts(8)./counts(4);

figure;
xlabel = categorical({'left rewarded', 'left unrewarded', 'right rewarded', 'right unrewarded'});
bar(xlabel, [leReFrac, leUnFrac, riReFrac, riUnFrac]);
ylim([0, 1]); ylabel('Switch fraction');

%% WSLS Aggregate

%[leReTemp, riReTemp, leUnTemp, riUnTemp, leReSwTemp, riReSwTemp, leUnSwTemp, riUnSwTemp] = deal(0);
counts45 = zeros(1, 8);
fileNames45 = {'BY45_WSLS'};
for i = 1:length(fileNames45)
    load(fileNames45{i});
    counts45 = counts45 + counts;
end
fracs45 = zeros(1, 4);
for i=1:4
    fracs45(i) = counts45(i+4)./counts45(i);
end

counts15 = zeros(1, 8);
fileNames15 = {};
for i = 1:length(fileNames15)
    load(fileNames15{i});
    counts15 = counts15 + counts;
end
fracs15 = zeros(1, 4);
for i=1:4
    fracs15(i) = counts15(i+4)./counts15(i);
end

% order is [leRe, riRe, leUn, riUn]
toPlot = reshape([fracs45, fracs15], [4, 2]);
toPlot([3 2], :) = toPlot([2 3], :);

figure('position',[0 0 600 250]);
xlabel = categorical({'left rewarded', 'left unrewarded', 'right rewarded', 'right unrewarded'});
b = bar(xlabel, toPlot);
ylim([0, 1.2]); ylabel('switch fraction');
legend({'stable', 'volatile'}, 'Location', 'northwest');
b(2).FaceColor = [0.6350, 0.0780, 0.1840];
title('Average Switch Fraction for Main Stimulus');

