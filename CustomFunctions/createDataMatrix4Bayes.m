function [X, X0, Y, Yfit_actual, trainingTrials, testingTrials] = createDataMatrix4Bayes(DATA, input)

%nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3); %per trial
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

Xprime = [];
X0prime = [];
%Y = zeros(nTotalFrames, 1);
count = 0;

fprintf('Label Shuffle Control: %s\n', input.labelShuffle)
if strcmpi(input.labelShuffle, 'on')
    randomFrames = randperm(nFrames);
end

for frame = 1:nFrames
    %disp(frame)
    
    %Training Trials
    trainingData_ = squeeze(DATA(:, trainingTrials, frame));
    Xprime = [Xprime trainingData_]; %reshaped data
    %Training Trial Labels
    if strcmpi(input.labelShuffle, 'on')
        Y(((length(trainingTrials)*(count)) + 1): ((length(trainingTrials)*(count)) + length(trainingTrials)), 1) = randomFrames(frame);
    elseif strcmpi(input.labelShuffle, 'off')
        Y(((length(trainingTrials)*(count)) + 1): ((length(trainingTrials)*(count)) + length(trainingTrials)), 1) = frame;
    else
        error('Unable to determine if label shuffle is On/Off')
    end
    
    %Testing Trials
    testingData_ = squeeze(DATA(:, testingTrials, frame));
    X0prime = [X0prime testingData_];
    %Testing Trial Labels
    Yfit_actual(((length(testingTrials)*(count)) + 1): ((length(testingTrials)*(count)) + length(testingTrials)), 1) = frame;
    count = count + 1;
end
%Rows are now the calcium activity and columns are cells
X = Xprime'; %Training
X0 = X0prime'; %Testing

%mustBeNonnegative(X)

end
