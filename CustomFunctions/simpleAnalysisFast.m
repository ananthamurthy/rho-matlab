function [peakTimeBin, Q] = simpleAnalysisFast(DATA, simpleInput)

%nFrames = size(DATA, 3);
%nTrials = size(DATA, 2);
nCells = size(DATA, 1);

%Nullify CS artifact
skipFrames = simpleInput.skipFrames;
DATA(:, :, skipFrames) = 0;

%Get Event Time Histogram (ETH) Curves
delta = simpleInput.delta;
[ETH, ~] = getETHFast(DATA, delta);

%Time Vector
[~, peakTimeBin] = max(ETH, [], 2);

Q = nan(nCells, 1);
for cell = 1:nCells
    
    AUC4PeakBin = ETH(cell, peakTimeBin(cell));
    
    if AUC4PeakBin == 0
        Q(cell) = 0;
    else
        stdAcrossBins = std(squeeze(ETH(cell, :)));
        Q(cell) = AUC4PeakBin/stdAcrossBins;
    end
end
end