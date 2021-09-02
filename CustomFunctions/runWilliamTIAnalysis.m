function [williamOutput] = runWilliamTIAnalysis(DATA, williamInput)
nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
nFrames = size(DATA, 3);

nIterations = williamInput.nIterations;
threshold = williamInput.threshold;

%Preallocations
MI = nan(nCells,1);
Isec = nan(nCells,1);
Ispk = nan(nCells,1);
Ispk_rand = nan(nCells, nIterations);
Itime = nan(nCells,size(DATA,3),1);
timeCells = nan(nCells, 1);
%time = nan(nCells, 1);

%Quality (Q) or Temporal Information
for cell = 1:nCells
    [MI(cell), Isec(cell), Ispk(cell), Itime(cell, :)] = tempInfoOneNeuron(squeeze(DATA(cell,:,:)));
end

%Generate circularly shifted randomized data
controls.startFrame = williamInput.startFrame;
controls.endFrame = williamInput.endFrame;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
    randDATA = generateRandData(DATA, controls);
    %Calculate Temporal Information
    for cell = 1:nCells
        [~, ~, Ispk_rand(cell, i), ~] = tempInfoOneNeuron(squeeze(randDATA(cell, :, :)));
    end
end

%Classify Time Cells
for cell = 1:nCells
    score = (sum(Ispk_rand(cell, (Ispk(cell)>Ispk_rand(cell, :))))/williamInput.nIterations)*100;
    if score > threshold
        timeCells(cell) = 1;
    else
        timeCells(cell) = 0;
    end
end

if williamInput.getT
    %Get Time from Network Activity using Bayesian Learning
    [X, X0, Y, Yfit_actual, trainingTrials, testingTrials] = createDataMatrix4Bayes(DATA, williamInput);
    
    %mustBeNonnegative(X)
    %mustBeNonnegative(X0)
    %mustBeNonnegative(Y)
    
    %Generate the model
    %Mdl = fitcnb(X, Y, 'distributionnames','mn', 'ClassNames', Y);
    if williamInput.saveModel
        williamOutput.Mdl = fitcnb(X, Y, ...
            'distributionnames', williamInput.distribution4Bayes, ...
            'ClassNames', Y);
    else
        Mdl = fitcnb(X, Y, ...
            'distributionnames', williamInput.distribution4Bayes, ...
            'ClassNames', Y);
    end
    
    %Test model
    if williamInput.saveModel
        Yfit = predict(williamOutput.Mdl, X0);
    else
        Yfit = predict(Mdl, X0);
    end
    YfitDiff = Yfit - Yfit_actual;
    
    %Reshape Yfit and Yfit_actual to a 2D matrix - trials vs frames
    Yfit_2D = reshape(williamOutput.Yfit, [length(testingTrials), nFrames]);
    Yfit_actual_2D = reshape(williamOutput.Yfit_actual, [length(testingTrials), nFrames]);
    YfitDiff_2D = reshape(williamOutput.YfitDiff, [length(testingTrials), nFrames]);
else
    %Maintain the same variables for the output structure with pointless
    %values
    Yfit = 1;
    trainingTrials = 1;
    testingTrials = 1;
    Yfit_actual = 1;
    YfitDiff = 1;
    
    %Reshape Yfit and Yfit_actual to a 2D matrix - trials vs frames
    Yfit_2D = 1;
    Yfit_actual_2D = 1;
    YfitDiff_2D = 1;
end
williamOutput.Yfit = Yfit;
%williamOutput.Q = Ispk;
williamOutput.Q = real(Ispk);
williamOutput.trainingTrials = trainingTrials;
williamOutput.testingTrials = testingTrials;
williamOutput.Yfit_actual = Yfit_actual;
williamOutput.YfitDiff = YfitDiff;
williamOutput.Yfit_2D = Yfit_2D;
williamOutput.Yfit_actual_2D = Yfit_actual_2D;
williamOutput.YfitDiff_2D = YfitDiff_2D;
williamOutput.timeCells = timeCells;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method B scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(williamOutput.Q, nanTest_input);
williamOutput.nanList = nanList;

end