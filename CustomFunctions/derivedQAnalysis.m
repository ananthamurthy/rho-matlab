function [peakTimeBin, Q1, Q2] = derivedQAnalysis(DATA, derivedQInput)

nCells = size(DATA, 1);
nTrials = size(DATA, 2);
delta = derivedQInput.delta;
skipFrames = derivedQInput.skipFrames;

%Preallocation
hitTrials = zeros(nCells, nTrials);
Q1 = nan(nCells, 1);
Q2 = nan(nCells, 1);
peakTimeBin = nan(nCells, 1);
peakTrialTimeBin = nan(nCells, nTrials);
maxSignal = nan(nCells, 1);
HTR = nan(nCells, 1);
NbyS1 = nan(nCells, 1);
NbyS2 = nan(nCells, 1);
%aew = nan(nCells, 100); %Just chose a random realitively high number (100)
sdAEW = nan(nCells, 1);
mAEW = nan(nCells, 1);
SDbyMEW = nan(nCells, 1);
SDPbySW = nan(nCells, 1);
p = zeros(nCells, nTrials);

%NOTE: 'DATA' is organized as (cells, trials, frames)
nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3);
DATA_2D = nan(nCells, nTrials * nFrames);

%2D DATA (cells, all frames)
for cell = 1:nCells
    DATA_2D(cell, :) = reshape(squeeze(DATA(cell, :, :))', 1, []);
end

%Use real 2D data to curate a library
%dbase = derivedQInput.dbase;
%saveFolder = derivedQInput.saveFolder;
eventLibrary_2D = curateLibrary(DATA_2D);

%Develop Event Time Histogram (ETH) Curves
[ETH, trialAUCs, ~] = getETH(DATA, delta, skipFrames);

for cell = 1:nCells
    %Find ETH Peak
    [~, peakTimeBin(cell)] = max(ETH(cell, :));
    
    for trial = 1:nTrials
        %Find Trial-wise peak time bins
        [~, peakTrialTimeBin(cell, trial)] = max(trialAUCs(cell, trial, :));
        
        %Find Hit Trials
        if peakTrialTimeBin(cell, trial) == peakTimeBin(cell)
            hitTrials(cell, trial) = 1;
        else
            hitTrials(cell, trial) = 0;
        end
    end
    %Find Hit Trial Ratio (HTR)
    HTR(cell) = sum(hitTrials(cell, :))/nTrials;
    
    if HTR(cell) < 0
        error('HTR for cell: %i is negative by Method F', cell)
    elseif isnan(HTR(cell))
        error('HTR for cell: %i is NaN', cell)
    end
    
    a = derivedQInput.alpha;
    %Establish Noise by Signal - 2 measures
    maxSignal(cell) = max(DATA_2D(cell, :)); %Should I consider a percentile value?
    
    if maxSignal(cell) == 0
        Q2(cell) = 0; %bypass
    else
        noiseVar1 = evar(DATA_2D(cell, :));
        NbyS1(cell) = sqrt(noiseVar1)/maxSignal(cell);
        %fprintf('1>Cell: %i - Noise1 = %d, NbyS1 = %d\n', cell, noiseVar1, NbyS1(cell))
        %!!!Add check for nan
        
        noiseVar2 = estimatenoise(DATA_2D(cell, :));
        NbyS2(cell) = sqrt(noiseVar2)/maxSignal(cell);
        %fprintf('2>Cell: %i - Noise2 = %d, NbyS2 = %d\n', cell, noiseVar2, NbyS2(cell))
        
        if NbyS2(cell) < 0
            error('N/S for cell: %i is negative by Method F2', cell)
        elseif isnan(NbyS2(cell))
            if isnan(sqrt(noiseVar2))
                error('Square Root for noiseVar2 for cell: %i is Nan by Method F2', cell)
            elseif maxSignal(cell) == 0
                error('Max signal for cell: %i is 0 by Method F2', cell)
            end
            error('N/S for cell: %i is NaN by Method F2', cell)
        end
        b = derivedQInput.beta;
        %Find all event widths
        aew = eventLibrary_2D(cell).eventWidths;
        %     sdAEW(cell) = nanstd(aew(ht)); %Only Hit Trials
        %     mAEW(cell) = nanmean(aew(ht)); %Only Hit Trials
        sdAEW(cell) = nanstd(aew); %All events
        mAEW(cell) = nanmean(aew); %All events
        SDbyMEW(cell) = sdAEW(cell)/mAEW(cell);
        
        if SDbyMEW < 0
            error('SD/Mean Event Width for cell: %i is negative by Method F', cell)
        elseif isnan(SDbyMEW(cell))
            %warning('SD/Mean Event Width for cell: %i is NaN', cell)
            if mAEW(cell) == 0
                error('Mean Event Width is 0 for cell: %i by Method F', cell)
            elseif isnan(sdAEW(cell))
                if isempty(aew)
                    Q2(cell) = 0; %bypass
                else
                    error('SD Event Width is NaN for cell: %i by Method F', cell)
                end
            elseif ~isempty(aew(isnan(aew)))
                Q2(cell) = 0; %bypass
            end
            %error('SD/Mean Event Width for cell: %i is NaN', cell)
        else %chug along
            g = derivedQInput.gamma;
            %Find Imprecision or Pad (p)
            for trial = 1:nTrials
                p(cell, trial) = peakTimeBin(cell) - peakTrialTimeBin(cell, trial);
            end
            sdp = std(p(cell, :));
            %sw = derivedQInput.stimulusWindow;
            sw = nFrames;
            SDPbySW(cell) = sdp/sw;
            
            if SDPbySW(cell) < 0
                error('Pad SD/Mean Stimulus Window for cell: %i is negative by Method F', cell)
            elseif isnan(SDPbySW(cell))
                error('Stimulus Window for cell: %i is 0', cell)
            end
            
            Q1(cell) = HTR(cell) * exp(-1 * ((a * NbyS1(cell)) + (b * SDbyMEW(cell)) + (g * SDPbySW(cell))));
            Q2(cell) = HTR(cell) * exp(-1 * ((a * NbyS2(cell)) + (b * SDbyMEW(cell)) + (g * SDPbySW(cell))));
        end
    end
    if isnan(Q2(cell))
        error('Q2 for cell: %i scored NaN by Method F', cell)
    end
end

end