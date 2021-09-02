function [X_all, Y_all] = createDataMatrix4Classification(DATA, input)

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
nFrames = size(DATA, 3); %per trial
%nTotalFrames = nTrials*nFrames; %total frames in dataset

fprintf('Label Shuffle Control: %s\n', input.labelShuffle)
if strcmpi(input.labelShuffle, 'on')
    randomCells = randperm(nCells);
end

X_all = [];

for cellIndex = 1:nCells
    %disp(cellIndex)
    
    trainingData_ = squeeze(DATA(cellIndex, :, :))'; % nFrames x nTrials
    %size(trainingData_)
    
    X_all = [X_all; trainingData_]; %reshaped data
    %size(X_all)
    
    %Training Labels
    if strcmpi(input.labelShuffle, 'on')
        if ismember(randomCells(cellIndex), input.ptcList)
            Y_all(((cellIndex-1) * nFrames + 1): (cellIndex-1) * nFrames + nFrames, 1) = 1;
        elseif ismember(randomCells(cellIndex), input.ocList)
            Y_all(((cellIndex-1) * nFrames + 1): (cellIndex-1) * nFrames + nFrames, 1) = 0;
        end
    elseif strcmpi(input.labelShuffle, 'off')
        if ismember(cellIndex, input.ptcList)
            Y_all(((cellIndex-1) * nFrames + 1): (cellIndex-1) * nFrames + nFrames, 1) = 1;
        elseif ismember(cellIndex, input.ocList)
            Y_all(((cellIndex-1) * nFrames + 1): (cellIndex-1) * nFrames + nFrames, 1) = 0;
        end
    else
        error('Unable to determine if label shuffle control is on/off')
    end
end

end
