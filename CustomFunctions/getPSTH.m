% AUTHOR - Kambadur Ananthmurthy
function [PSTH, PSTH_3D, nbins] = getPSTH(Data, delta, skipFrames)
%Develop PSTH

fprintf('Now, developing PSTH for %i cells ...\n', size(Data,1))
%disp('Now, developing PSTH ...')

%nFrames = size(Data,3);
r = rem(size(Data,3),delta);
if r == 0
    nFrames = size(Data,3);
else
    Data(:,:,1:(end-(r-1)):end) = []; %get rid of last r frames
    nFrames = size(Data,3);
end
%NOTE: 'Data' is organized as cells, trials, frames
nbins = nFrames/delta;
PSTH_3D = zeros(size(Data,1), size(Data,2), nbins);
PSTH = zeros(size(Data,1), nbins);

for cell = 1:size(Data,1)
    for trial = 1:size(Data,2)
        %fprintf('Trial: %i\n', trial)
        %Get rid of CS artifact
        Data(cell, trial, skipFrames) = 0;
        %Get rid of 1st and last frames
        %Data(cell,trial,1) = [];
        %Data(cell,trial,end) = [];
        %Now the total number of frames/delta should be an integer (assuming delta = 3)
        
        bin = 1;
        trialAUCs = zeros(nbins,1);
        for frame = 1:delta:nFrames
            %fprintf('Frame: %i\n', frame)
            windowAUC = trapz(Data(cell, trial, frame:(frame+delta-1)));
            trialAUCs(bin) = windowAUC;
            bin = bin + 1;
        end
        clear bin
        %check if trialSums has the same length as nbins
        %fprintf('Length of trialSums is %i \n', length(trialSums))
        if length(trialAUCs) ~= nbins
            error('Length of trialSums ~= nbins for trial %i', trial)
        end
        PSTH_3D(cell, trial, :) = trialAUCs;
    end
    PSTH = squeeze(sum(PSTH_3D,2));
    
    if (mod(cell, 10) == 0) && cell ~= size(Data,1)
        fprintf('... %i cells analysed ...\n', cell)
    end
    
end
disp('... done!')