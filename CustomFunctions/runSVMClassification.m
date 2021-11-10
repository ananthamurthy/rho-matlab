function [svmOutput] = runSVMClassification(DATA, svmInput)

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

%Gaussian Smoothing
if svmInput.gaussianSmoothing
    [DATA, ~] = doGaussianSmoothing(DATA, svmInput.nSamples);
    %[smoothedDATA, gaussianKernel] = doGaussianSmoothing2D(DATA_2D, nSamples);
end

[X, X0, Y, Yfit_actual, ~, testingTrials] = createDataMatrix4Classification(DATA, svmInput);

% mustBeNonnegative(X)
% mustBeNonnegative(X0)
% mustBeNonnegative(Y)

%Train Model
if svmInput.saveModel
    svmOutput.SVMModel = fitcsvm(X, Y, ...
        'KernelFunction', 'linear', ...
        'KernelScale', 'auto');
else
    SVMModel = fitcsvm(X, Y, ...
        'KernelFunction', 'linear', ...
        'KernelScale', 'auto');
end

%Test model
if svmInput.saveModel
    [svmOutput.Yfit, score] = predict(svmOutput.SVMModel, X0);
else
    [svmOutput.Yfit, score] = predict(SVMModel, X0);
end

svmOutput.YfitDiff = svmOutput.Yfit - Yfit_actual;
try
    allQ = score(:, 2); %Only looking at the "positive class" scores (to classify as "time cell")
catch
    %Usually only if all cells are classified the same (often - no time
    %cells). Here, negative scores are considered.
    %disp('**** Caught a dataset with only 1 column ****')
    allQ = score(:, 1);
end

%Reshape Yfit and Yfit_actual to a 2D matrix - trials vs frames
svmOutput.Yfit_2D = reshape(svmOutput.Yfit, [length(testingTrials), nCells]);
svmOutput.Yfit_actual_2D = reshape(Yfit_actual, [length(testingTrials), nCells]);
svmOutput.YfitDiff_2D = reshape(svmOutput.YfitDiff, [length(testingTrials), nCells]);

Q_2D = reshape(allQ, [length(testingTrials), nCells]);
svmOutput.Q = median(Q_2D); % Try either mean or median

% Time Vector (T)
peakTimeBin = zeros(nCells, 1);
if svmInput.getT
    [ETH, ~, ~] = getETH(DATA, svmInput.delta, svmInput.skipFrames);
    for cell = 1:nCells
        %disp(cell)
        [~, peakTimeBin(cell)] = max(squeeze(ETH(cell, :)));
    end
end
svmOutput.T = peakTimeBin;

thresholdOtsu = graythresh(svmOutput.Q); %Otsu's method
timeCells = svmOutput.Q > thresholdOtsu;

svmOutput.timeCells = timeCells;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method E scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(svmOutput.Q, nanTest_input);
svmOutput.nanList = nanList;

end