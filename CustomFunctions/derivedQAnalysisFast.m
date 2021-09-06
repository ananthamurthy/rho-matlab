function [peakTimeBin, Q2] = derivedQAnalysisFast(DATA, derivedQInput)

%NOTE: 'DATA' is organized as (cells, trials, frames)
nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3);
DATA_2D = nan(nCells, nTrials * nFrames);

%Nullify CS artifact
skipFrames = derivedQInput.skipFrames;
DATA(:, :, skipFrames) = 0;

%2D DATA (cells, all frames)
for cell = 1:nCells
    DATA_2D(cell, :) = reshape(squeeze(DATA(cell, :, :))', 1, []);
end

%Use real 2D data to curate a library
eventLibrary_2D = curateLibrary(DATA_2D);

%Develop Event Time Histogram (ETH) Curves
delta = derivedQInput.delta;
[ETH, ~] = getETHFast(DATA, delta);

%Time Vector
[~, peakTimeBin] = max(ETH, [], 2);

a = derivedQInput.alpha;
b = derivedQInput.beta;
g = derivedQInput.gamma;

%Preallocation
hitTrials = zeros(nTrials, 1);
HTR = zeros(nCells, 1);
NbyS2 = zeros(nCells, 1);
SDbyMEW = zeros(nCells, 1);
p = nan(nTrials, 1);
SDPbySW = zeros(nCells, 1);
Q2 = zeros(nCells, 1);

for cell = 1:nCells
    m = mean(squeeze(DATA_2D(cell, :))); %mean along frames
    s = std(squeeze(DATA_2D(cell, :))); %std dev along frames
    detectionThreshold = m + 2*s; %for each cell
    
    for trial = 1:nTrials    
        %Find Hit Trials
        limit = (peakTimeBin(cell) * delta) + delta;
        if limit < nFrames
            hitTrials(trial) = ~isempty(find(DATA(cell, trial, (limit-delta):limit) > detectionThreshold, 1));
        end
            
        %Get Imprecision or pad
        if hitTrials(trial)
            [~, I] = max(squeeze(DATA(cell, trial, (peakTimeBin(cell) * delta): ((peakTimeBin(cell) * delta) + delta))), [], 'omitnan');
            p(trial) = (peakTimeBin(cell) * delta) - I;
        end
    end
    
    if ~numel(find(hitTrials)) == 0
        %Get Hit Trial Ratio
        HTR(cell) = numel(find(hitTrials))/nTrials;
        
        %Get Noise/Signal
        noiseVar2 = estimatenoise(DATA_2D(cell, :));
        if ~isnan(noiseVar2)
            noise = sqrt(noiseVar2);
            if ~isnan(noise)
                NbyS2(cell) = noise/max(DATA_2D(cell, :));
            end
        end
        
        %Get Std. Dev./Mean Event Widths
        SDbyMEW(cell) = std(eventLibrary_2D(cell).eventWidths, 'omitnan')/mean(eventLibrary_2D(cell).eventWidths, 'omitnan');
        
        %Get Std. Dev. pad by Stimulus Window
        SDPbySW(cell) = std(p, 'omitnan')/(derivedQInput.endFrame - derivedQInput.startFrame);
        
        %Get Score
        Q2(cell) = HTR(cell) * exp(-1 * ((a * NbyS2(cell)) + (b * SDbyMEW(cell)) + (g * SDPbySW(cell))));
    end
end

end