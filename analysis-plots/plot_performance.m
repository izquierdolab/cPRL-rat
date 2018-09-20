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

numCompleteTrials = length(results.reward);


%% Subplot 1: Cumulative reward and performance

% Calculate cumulative reward and performance rates
[rewardRate, performance] = deal(NaN(numCompleteTrials,1));
for i = 1:numCompleteTrials
    rewardRate(i,1) = nanmean(results.reward(1:i));
    performance(i,1) = nanmean(results.betterChoice(1:i));
end

figure('position',[0 0 700 1200]);
titleName = [fileName(1:end-4),'_block',num2str(blockIndex)];

subplot(3,1,1)
hold on
plot(1:numCompleteTrials, performance(:,1));
plot(1:numCompleteTrials, rewardRate(:,1));
hold off
hline = refline(0,.5); hline.LineStyle = '--';
title(titleName, 'Interpreter', 'none')
ylabel('Rate'); xlabel('Trials');
xlim([1,numCompleteTrials]); ylim([0, 1]);
legend({'Performance (better choice)','Reward rate'},'FontSize',10,'Location','NW');


%% Subplot 2: Main Stimulus

% Filter out trials with main stimulus
choice = results.choice(myinput.stimulus == 1);
[~,myinput.betterChoice] = max(myinput.prob);
betterChoice = myinput.betterChoice(myinput.stimulus == 1);


subplot(3,1,2);
hold on
plot(find(myinput.stimulus == 1),betterChoice, '-', 'Color', [0.6350, 0.0780, 0.1840], 'LineWidth', 5);
plot(find(myinput.stimulus == 1),choice,'o-', 'Color', [0, 0.4470, 0.7410]);
hold off
yticks([1,2]);  yticklabels({'L','R'});
Lfrac = sum(choice == 1)/length(choice);
Rfrac = (1-Lfrac);
ylabel('choice side');
title(['main stimulus (L = 20)']);
legend({'better choice', 'subject''s choice'}, 'FontSize',10,'Location','NW');
xlim([1,numCompleteTrials]);  xlabel('trial number');


%% Subplot 3: Modulating Stimiulus

% Filter out trials with modulating stimulus
choice = results.choice(myinput.stimulus == 2);
betterChoice = myinput.betterChoice(myinput.stimulus == 2);

subplot(3,1,3);
hold on
plot(find(myinput.stimulus == 2),betterChoice,'-', 'Color', [0.6350, 0.0780, 0.1840], 'LineWidth', 5);
plot(find(myinput.stimulus == 2),choice,'o-', 'Color', [0, 0.4470, 0.7410]);
hold off
yticks([1,2]); yticklabels({'L','R'});
Lfrac = sum(choice == 1)/length(choice);
Rfrac = (1-Lfrac);
ylabel('choice side');
title(['Modulating stimulus: left ',num2str(Lfrac),', right ',num2str(Rfrac)])
xlim([1,numCompleteTrials]);  xlabel('trial number');

