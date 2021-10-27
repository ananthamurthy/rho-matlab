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
    
    limit = (peakTimeBin(cell) * delta) + delta;
    for trial = 1:nTrials    
        %Find Hit Trials        
        if limit < nFrames
            hitTrials(trial) = ~isempty(find(DATA(cell, trial, :) > detectionThreshold, 1));
            
            %Get Imprecision or pad
            if hitTrials(trial)
                [~, I] = max(squeeze(DATA(cell, trial, (limit-delta):limit)), [], 'omitnan');
                p(trial) = (peakTimeBin(cell) * delta) - I;
            end
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
        exponentSection = exp(-1 * ((a * NbyS2(cell)) + (b * SDbyMEW(cell)) + (g * SDPbySW(cell))));
        if isnan(exponentSection)
            Q2(cell) = 0;
        elseif isinf(exponentSection)
            Q2(cell) = 0;
        else
            Q2(cell) = HTR(cell) * exponentSection;
        end
    end
end

end