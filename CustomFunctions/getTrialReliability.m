%This function will go over 3D-Data (cell, trials, frames) to identify how
%many trials did a (time) cell fire during the inter-stimulus window.

function [trialReliability, finalTimeCellList] = getTrialReliability(Data, window)

if numel(size(Data))>=3 
    %Preallocation
    finalTimeCellList = ones(size(Data,1),1);
    trialReliability = zeros(size(Data,1), size(Data,2));
    significantData = zeros(size(Data,1), size(Data,2), length(window));
    
    for cell = 1:size(Data,1)
        for trial = 1:size(Data,2)
            trialMean = mean(Data(cell, trial, :)); %changes for every trial
            trialStddev = std(Data(cell, trial, :)); %changes for every trial
            %disp('Checking for significant events ...')
            for frame = 1:length(window)
                if Data(cell, trial, window(frame)) > (trialMean + (2*trialStddev))
                    significantData(cell, trial, frame) = 1;
                else
                    significantData(cell, trial, frame) = 0;
                end
                
                if sum(significantData(cell,trial,:)) == 0
                    trialReliability(cell,trial) = 0;
                else
                    trialReliability(cell,trial) = 1;
                end
            end
            
%             if numel(find(trialReliability(cell,trial)) <= 1)
%                 finalTimeCellList(cell) = 0;
%             end
        end
    end
else
    warning('Please check dimensions of Data matrix')
end

