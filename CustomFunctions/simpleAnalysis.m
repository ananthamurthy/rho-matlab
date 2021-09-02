function [peakTimeBin, Q1, Q2] = simpleAnalysis(DATA, simpleInput)
%Preallocation
nCells = size(DATA, 1);
nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);
delta = simpleInput.delta;
skipFrames = simpleInput.skipFrames;
hitTrial = zeros(nCells, nTrials);
Q1 = nan(nCells, 1);
Q2 = nan(nCells, 1);
peakTimeBin = nan(nCells, 1);
%ksstat = nan(nCells, 1);
peakTrialTimeBin = nan(nCells, nTrials);

[ETH, trialAUCs, ~] = getETH(DATA, delta, skipFrames);

%Develop CDF for a uniform distribution
%test_cdf = [1:nBins; cdf('Uniform', 1:nBins, 1, nBins)];

for cell = 1:nCells
    % Time Vector
    [~, peakTimeBin(cell)] = max(squeeze(ETH(cell, :)));
    
    for trial = 1:nTrials
        m = mean(squeeze(trialAUCs(cell, trial, :)));
        s = std(squeeze(trialAUCs(cell, trial, :)));
        
        % Check for Hit Trials
        if trialAUCs(cell, trial, peakTimeBin(cell)) >= m + 2*s
            hitTrial(cell, trial) = 1;
        end
        [~, peakTrialTimeBin(cell, trial)] = max(trialAUCs(cell, trial, :));
        
        clear m
        clear s
        clear threshold
    end
    
    %[~, ~ , ksstat(cell), ~] = kstest(peakTrialTimeBin(cell, :), 'CDF', test_cdf'); %Probably a crazy idea
    
    %Develop Q1
    %Q1(cell) = (sum(squeeze(hitTrial(cell, :)))/nTrials) * ksstat(cell); %Q1 = hit trial ratio * ksstat
    
    % Develop Q2
    meanTimedPeak = mean(trialAUCs(cell, :, peakTimeBin(cell)));
    stdTimedPeak = std(trialAUCs(cell, :, peakTimeBin(cell)));
    
    if meanTimedPeak == 0
        Q2(cell) = 0; %bypass
    else
        Q2(cell) = meanTimedPeak/stdTimedPeak;
    end
end

end