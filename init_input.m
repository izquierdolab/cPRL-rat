function myinput = init_input(expr)

myinput = struct('stim',[],'gaborTilt',[],'prob',[],'reward',[]);

for blockIndex = 1:expr.nBlocks
    % All stimuli present in this block
    allStim = expr.stimCombination{expr.seq(blockIndex)};
    
    % Generate random ordering of all stimuli in this block
    tempIndex = randi([1,length(allStim)],expr.nTrialsBlock,1);
    stimSeq = allStim(tempIndex);
    gaborTilt = expr.gaborTilt(stimSeq);
    
    % Initialize all probabilities to NaN (why?)
    [probIndex, prob1, prob2] = deal(NaN(length(expr.switchLength), expr.nTrialsBlock));
    [probLU, probRD] = deal(NaN(1, expr.nTrialsBlock));
    
    for stimIndex = 1:length(expr.switchLength)
        probIndex(stimIndex,:) = mod(ceil([1:expr.nTrialsBlock]./expr.switchLength(stimIndex)),2);
        for i = 1:expr.nTrialsBlock
            %fprintf('stim_index = %d, i = %d\n',stimIndex, i);
            prob1(stimIndex,i) = [expr.prob{stimIndex,1}(probIndex(stimIndex,i)+1)];
            prob2(stimIndex,i) = [expr.prob{stimIndex,1}(~probIndex(stimIndex,i)+1)];
            probLU(1,i) = prob1(stimSeq(i),i); % probability of Left/Up rewarded
            probRD(1,i) = prob2(stimSeq(i),i); % probability of Right/Down rewarded   
        end
    end
    myinput(blockIndex).stim = stimSeq';
    myinput(blockIndex).gaborTilt = gaborTilt;
    myinput(blockIndex).prob = [probLU;probRD];
    
    % Generate the real reward from probability
    rng('shuffle')
    temp = cell(1,100);
    correlation = NaN(1,100);
    for i = 1:100
        temp{i} = binornd(1,[probLU;probRD]);
        % this is a workaround to not having the Stat/ML toolbox
        %{
        temp_i = [];
        x = rand(2, expr.nTrialsBlock);
        for j = 1:expr.nTrialsBlock
            % first row - Prob_LU
            if x(1, j) < Prob_LU(1, j)
                temp_i(1, j) = 1;
            else
                temp_i(1, j) = 0;
            end
            % second row - Prob_RD
            if x(2, j) < Prob_RD(1, j)
                temp_i(2, j) = 1;
            else
                temp_i(2, j) = 0;
            end
        end
        temp{i} = temp_i;
        %}
        correlation(i) = corr(temp{i}(1,:)',temp{i}(2,:)');
    end
    
    % Pick the lowest correlated one so fewer trials have both side rewarded/unrewarded
    [~,minIndex] = min((correlation));
    reward = temp{minIndex};
    
    myinput(blockIndex).reward = reward;
    [~,myinput(blockIndex).betterChoice] = max(myinput(blockIndex).reward);
    
end

%save('input.mat', 'myinput');

end