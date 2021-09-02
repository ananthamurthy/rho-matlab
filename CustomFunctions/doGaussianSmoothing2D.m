% AUTHOR - Kambadur Ananthmurthy
function [smoothedDATA, gaussianKernel] = doGaussianSmoothing2D(DATA_2D, nSamples)
w = gausswin(nSamples);
gaussianKernel = w/sum(w) ; %normalized
%wvtool(gaussianKernel)
% Data is organized as cells, trials, frames.
smoothedDATA = zeros(size(DATA_2D,1), size(DATA_2D,2), (size(DATA_2D,3)+nSamples-1));
for cell = 1:size(DATA_2D,1)
        originalSignal = squeeze(DATA_2D(cell, :));
        smoothedDATA(cell, :) = conv(originalSignal, gaussianKernel);
end
end