function [X, X0, Y, Yfit_actual, trainingTrials, testingTrials] = createDataMatrix4Classification(DATA, input)

nCells = size(DATA, 1);
nTrials = size(DATA, 2);
%nFrames = size(DATA, 3); %per trial
%nTotalFrames = nTrials*nFrames; %total frames in dataset.

if strcmpi(input.whichTrials, 'first')
    trainingTrials = 1:floor(nTrials/2);
    testingTrials = floor(nTrials/2)+1:nTrials;
    
elseif strcmpi(input.whichTrials, 'alternate')
    trainingTrials = 1:2:nTrials;
    testingTrials = 2:2:nTrials;
    
elseif strcmpi(input.whichTrials, 'random')
    allTrials = 1:nTrials;
    trainingTrials = sort(randperm(nTrials, floor(nTrials/2)));
    testingTrials = allTrials;
    testingTrials(trainingTrials) = [];
    clear allTrials
    
elseif strcmpi(input.whichTrials, 'all')
    trainingTrials = 1:nTrials;
    testingTrials = 1:nTrials;
    
else
    error('Unable to select test trials')
end

X = [];
X0 = [];

%fprintf('Label Shuffle Control: %s\n', input.labelShuffle)
if strcmpi(input.labelShuffle, 'on')
    randomCells = randperm(nCells);
end

for cell = 1:nCells
    %disp(frame)
    
    %Training Trials
    trainingData_ = squeeze(DATA(cell, trainingTrials, :));
    X = [X; trainingData_];
    %Training Trial Labels
    if strcmpi(input.labelShuffle, 'on')
        if ismember(randomCells(cell), input.ptcList)
            Y(((length(trainingTrials)*(cell-1)) + 1): ((length(trainingTrials)*(cell-1)) + length(trainingTrials)), 1) = 1;
        elseif ismember(randomCells(cell), input.ocList)
            Y(((length(trainingTrials)*(cell-1)) + 1): ((length(trainingTrials)*(cell-1)) + length(trainingTrials)), 1) = 0;
        end
    elseif strcmpi(input.labelShuffle, 'off')
        if ismember(cell, input.ptcList)
            Y(((length(trainingTrials)*(cell-1)) + 1): ((length(trainingTrials)*(cell-1)) + length(trainingTrials)), 1) = 1;
        elseif ismember(cell, input.ocList)
            Y(((length(trainingTrials)*(cell-1)) + 1): ((length(trainingTrials)*(cell-1)) + length(trainingTrials)), 1) = 0;
        end
    else
        error('Unable to determine if label shuffle is On/Off')
    end
    
    %Testing Trials
    testingData_ = squeeze(DATA(cell, testingTrials, :));
    X0 = [X0; testingData_];
    %Testing Trial Labels
    if ismember(cell, input.ptcList)
        Yfit_actual(((length(testingTrials)*(cell-1)) + 1): ((length(testingTrials)*(cell-1)) + length(testingTrials)), 1) = 1;
    elseif ismember(cell, input.ocList)
        Yfit_actual(((length(testingTrials)*(cell-1)) + 1): ((length(testingTrials)*(cell-1)) + length(testingTrials)), 1) = 0;
    end
end
end
