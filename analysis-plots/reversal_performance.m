%% Set up

% Clear and close screens
clear;
set(0,'defaultAxesFontSize', 12);

% Load file
DataDir = '../SubjectData/';
subName = 'CA';
mydate = '20180815';
sessionNum = 1;
fileName = [subName, '_', mydate, '_', num2str(sessionNum, '%02.f'), '.mat'];
load(fullfile(DataDir,fileName));

L = expr.switchLength(1); L_m = expr.switchLength(2); L_min = min([L, L_m]);

% Concatenate blocks
tempResults = struct('choice', [], 'betterChoice', [], 'reward', []);
tempInput = struct('betterChoice', [], 'stimulus', [], 'prob', []);
for blockIndex = 3:5
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


%% Construct arrays based on trial number after reversal

rev = 1;
main_correct = zeros(1, L); main_total = zeros(1, L);
mod_correct = zeros(1, L_m); mod_total = zeros(1, L_m);
for t = L_min : length(results.choice)
    tt = t-1;
    while myinput.stimulus(tt) ~= myinput.stimulus(t)
        tt = tt-1;
    end
    if myinput.betterChoice(tt) ~= myinput.betterChoice(t)
        rev = 0;
    end
    rev = rev + 1;
    if myinput.stimulus(t) == 1
        main_total(rev) = main_total(rev)+1;
        if results.choice(t) == results.betterChoice(t)
            main_correct(rev) = main_correct(rev)+1;
        end
    elseif myinput.stimulus(t) == 2
        disp(rev)
        mod_total(rev) = mod_total(rev)+1;
        if results.choice(t) == results.betterChoice(t)
            mod_correct(rev) = mod_correct(rev)+1;
        end
    end
end

main_total;
mod_total;
[main_total_cum, mod_total_cum, main_correct_cum, mod_correct_cum] = deal(zeros(1, L_min))
for i=1:L_min
    sprintf('%d: main %d / %d, mod %d / %d\n', i, sum(main_correct(1:i)), sum(main_total(1:i)), sum(mod_correct(1:i)), sum(mod_total(1:i)))
    main_total_cum(1,i) = nanmean(main_total(1:i));
    mod_total_cum(1,i) = nanmean(mod_total(1:i));
    main_correct_cum(1, i) = nanmean(main_correct(1:i));
    mod_correct_cum(1,i) = nanmean(mod_correct(1:i));
end

main_perf = main_correct_cum ./ main_total_cum;
mod_perf = mod_correct_cum ./ mod_total_cum;

%main_perf = main_correct(1:L_min) ./ main_total(1:L_min);
%mod_perf = mod_correct(1:L_min) ./ mod_total(1:L_min);

figure;
title([subName, '_', mydate], 'Interpreter', 'none');
hold on;
plot(1:L_min,main_perf,'o-', 'Color', [0, 0.4470, 0.7410]);
plot(1:L_min,mod_perf, 'o-', 'Color', [0.6350, 0.0780, 0.1840]);
xlim([1,L_min]); ylim([0, 1]);
legend('Main', 'Mod');
hold off;

save([subName,'_reversal', '.mat'], 'main_perf', 'mod_perf');

%% Load and Aggregate Preprocessed Data


figure('position',[0 0 400 250]);
title('Average Performance Within Blocks');
hold on
plot(1:length(main_perf),main_perf, 'Color', [0, 0.4470, 0.7410], 'LineWidth', 1.25);
plot(1:length(mod_perf),mod_perf, 'Color', [0.6350, 0.0780, 0.1840], 'LineWidth', 1.25);
hold off
xlim([1,15]); xlabel('trial number after reversal');
ylim([0, 1]); ylabel('accuracy');
legend({'modulating', 'main'}, 'Location', 'southeast');


%% Mixed Repeated Measures ANOVA

%Mixed Repeated Measures ANOVA between-subject = volatility/stability, within subject = trial #. Learning over time for everybody = within subject significance. Also expect significant group effect of stable vs. volatile for main and/or modulating. maybe main effect of trial and condition for main stimulus, interaction effect of trial and condition for modulating.
