function [williamOutput] = runWilliamTIAnalysis(DATA, williamInput)
nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
nFrames = size(DATA, 3);

nIterations = williamInput.nIterations;
threshold = williamInput.threshold;

%Preallocations
Ispk = nan(nCells,1); %Q1
Isec = nan(nCells,1); %Q2
MI = nan(nCells,1); %Q3
Ispk_rand = nan(nCells, nIterations);
Isec_rand = nan(nCells, nIterations);
MI_rand = nan(nCells, nIterations);

timeCells1 = nan(nCells, 1);
timeCells2 = nan(nCells, 1);
timeCells3 = nan(nCells, 1);
%timeCells4 = nan(nCells, 1); %Unnecessary preallocation
%timeCells5 = nan(nCells, 1); %Unnecessary preallocation
%timeCells6 = nan(nCells, 1); %Unnecessary preallocation
%time = nan(nCells, 1);

if williamInput.limit2StimWindow == 1
    myDATA = DATA(:, :, williamInput.startFrame:williamInput.endFrame); %cells, trials, frames
else
    myDATA = DATA;
end

Itime = nan(nCells,size(myDATA,3),1);
%Quality (Q) or Temporal Information
for cell = 1:nCells
    [MI(cell), Isec(cell), Ispk(cell), Itime(cell, :)] = tempInfoOneNeuron(squeeze(myDATA(cell, :, :)));
end

%Crucial - sometimes the scores could be complex numbers.
Q1 = abs(Ispk);
Q2 = abs(Isec);
Q3 = abs(MI);

%Generate circularly shifted randomized data
controls.startFrame = williamInput.startFrame;
controls.endFrame = williamInput.endFrame;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
    randDATA = generateRandData(DATA, controls); %original, without sectioning stimulus window
    
    if williamInput.limit2StimWindow == 1
        myRandDATA = randDATA(:, :, williamInput.startFrame:williamInput.endFrame); %cells, trials, frames
    else
        myRandDATA = DATA;
    end

    %Calculate Temporal Information
    for cell = 1:nCells
        [MI_rand(cell, i), Isec_rand(cell, i), Ispk_rand(cell, i), ~] = tempInfoOneNeuron(squeeze(myRandDATA(cell, :, :)));
    end
end

%Crucial - sometimes the scores could be complex numbers.
Q1_rand = abs(Ispk_rand);
Q2_rand = abs(Isec_rand);
Q3_rand = abs(MI_rand);

%Classify Time Cells - with complex values
for cell = 1:nCells
    score1 = (sum(Q1_rand(cell, (Q1(cell)>Q1_rand(cell, :))))/williamInput.nIterations)*100;
    if score1 > threshold
        timeCells1(cell) = 1;
    else
        timeCells1(cell) = 0;
    end

    score2 = (sum(Q2_rand(cell, (Q2(cell)>Q2_rand(cell, :))))/williamInput.nIterations)*100;
    if score2 > threshold
        timeCells2(cell) = 1;
    else
        timeCells2(cell) = 0;
    end

    score3 = (sum(Q3_rand(cell, (Q3(cell)>Q3_rand(cell, :))))/williamInput.nIterations)*100;
    if score3 > threshold
        timeCells3(cell) = 1;
    else
        timeCells3(cell) = 0;
    end
end

%Using Otsu's method of finding threshold
thresholdOtsu1 = graythresh(Q1); %Otsu's method
timeCells4 = Q1 > thresholdOtsu1;

thresholdOtsu2 = graythresh(Q2); %Otsu's method
timeCells5 = Q2 > thresholdOtsu2;

thresholdOtsu3 = graythresh(Q3); %Otsu's method
timeCells6 = Q3 > thresholdOtsu3;

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
    %Meaningless numbers - saving on disk space
    Yfit = 1;
    trainingTrials = 1;
    testingTrials = 1;
    Yfit_actual = 1;
    YfitDiff = 1;
    
    Yfit_2D = 1;
    Yfit_actual_2D = 1;
    YfitDiff_2D = 1;
end
williamOutput.Yfit = Yfit;
williamOutput.Q1 = Q1;
williamOutput.Q2 = Q2;
williamOutput.Q3 = Q3;
williamOutput.trainingTrials = trainingTrials;
williamOutput.testingTrials = testingTrials;
williamOutput.Yfit_actual = Yfit_actual;
williamOutput.YfitDiff = YfitDiff;
williamOutput.Yfit_2D = Yfit_2D;
williamOutput.Yfit_actual_2D = Yfit_actual_2D;
williamOutput.YfitDiff_2D = YfitDiff_2D;
williamOutput.timeCells1 = timeCells1;
williamOutput.timeCells2 = timeCells2;
williamOutput.timeCells3 = timeCells3;
williamOutput.timeCells4 = timeCells4;
williamOutput.timeCells5 = timeCells5;
williamOutput.timeCells6 = timeCells6;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method B scores';
nanTest_input.dimensions = '1D';
nanList1 = lookout4NaNs(williamOutput.Q1, nanTest_input);
nanList2 = lookout4NaNs(williamOutput.Q2, nanTest_input);
nanList3 = lookout4NaNs(williamOutput.Q3, nanTest_input);
williamOutput.nanList1 = nanList1;
williamOutput.nanList2 = nanList2;
williamOutput.nanList3 = nanList3;

end