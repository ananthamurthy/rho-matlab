% AUTHOR - Kambadur Ananthmurthy
function [smoothedDATA, gaussianKernel] = doGaussianSmoothing(DATA, nSamples)
nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3);

w = gausswin(nSamples);
gaussianKernel = w/sum(w) ; %normalized
%wvtool(gaussianKernel)
% Data is organized as cells, trials, frames.
smoothedDATA = zeros(nCells, nTrials, nFrames);
for cell = 1:nCells
    for trial = 1:nTrials
        originalSignal = squeeze(DATA(cell, trial, :));
        smoothedTrial = conv(originalSignal, gaussianKernel);
        smoothedDATA(cell, trial, :) = smoothedTrial(1:nFrames, 1);
    end
end
end