function [derivedQOutput] = runDerivedQAnalysis(DATA, derivedQInput)

nIterations = derivedQInput.nIterations;
threshold = derivedQInput.threshold;

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);
timeCells1 = nan(nCells, 1);

[peakTimeBin, Q1] = derivedQAnalysisFast(DATA, derivedQInput);

%Generate circularly shifted randomized data and score
randQ1 = nan(nCells, nIterations);
controls.startFrame = derivedQInput.startFrame;
controls.endFrame = derivedQInput.endFrame;
for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
%     if mod(i, 100) == 0
%         fprintf('>>> Random: %i of %i\n', i, nIterations)
%     end
    randDATA = generateRandData(DATA, controls);
    [~, randQ1(:, i)] = derivedQAnalysisFast(randDATA, derivedQInput);
end

%Classify Time Cells
for cell = 1:nCells
    score2 = (sum(Q1(cell)>randQ1(cell, :))/nIterations)*100;
    
    if score2 > threshold
        timeCells1(cell) = 1;
    else
        timeCells1(cell) = 0;
    end
    
    thresholdOtsu = graythresh(Q1); %Otsu's method
    timeCells2 = Q1 > thresholdOtsu;
end

derivedQOutput.Q1 = Q1;
derivedQOutput.T1 = peakTimeBin;
derivedQOutput.timeCells1 = timeCells1;
derivedQOutput.timeCells2 = timeCells2;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method F scores';
nanTest_input.dimensions = '1D';
nanList1 = lookout4NaNs(derivedQOutput.Q1, nanTest_input);
derivedQOutput.nanList1 = nanList1;

end