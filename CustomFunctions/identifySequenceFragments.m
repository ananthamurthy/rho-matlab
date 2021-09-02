% AUTHOR - Kambadur Ananthmurthy
% Identify trials with time cell sequence fragments, if any
% Best to use the significant-only traces of identified time locked cells
% Data = dfbf_sigOnly(find(timeLockedCells),:,:)

function [importantFrames] = identifySequenceFragments(Data, skipFrames)
%Preallocation
importantFrames = zeros(size(Data));
importantFrames(:,:,skipFrames) = [];
for cell = 1:size(importantFrames,1)
    for trial = 1:size(importantFrames,2)
        for frame = 1:size(importantFrames,3)
            importantFrames(cell, trial, frame) = 1;
        end
    end
end
end