% AUTHOR - Kambadur Ananthmurthy
function [ETH, nBins] = getETHFast(DATA, delta)
%fprintf('Now, developing ETH for %i cells ...\n', size(DATA,1))

%Ensure nFrames/delta is an integer
r = rem(size(DATA,3), delta);
if r == 0
    nFrames = size(DATA, 3);
else
    DATA(:,:,1:(end-(r-1)):end) = []; %get rid of last r frames
    nFrames = size(DATA, 3);
end

%NOTE: 'Data' is organized as cells, trials, frames
nBins = nFrames/delta;
ETH = zeros(size(DATA,1), nBins);

trialSummedDATA = squeeze(sum(DATA, 2));
for cell = 1:size(DATA,1)

    bin = 1;
    for frame = 1:delta:nFrames
        ETH(cell, bin) = trapz(trialSummedDATA(cell, frame:(frame+delta-1)));
        bin = bin + 1;
    end
    
    %     if (mod(cell, 50) == 0) && cell ~= size(DATA,1)
    %         fprintf('... %i cells analysed ...\n', cell)
    %     end
    %disp('... done!')
end
