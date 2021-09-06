function [derivedQOutput] = runDerivedQAnalysis(DATA, derivedQInput)

nIterations = derivedQInput.nIterations;
threshold = derivedQInput.threshold;

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);
timeCells2 = nan(nCells, 1);

[peakTimeBin, Q2] = derivedQAnalysisFast(DATA, derivedQInput);

%Generate circularly shifted randomized data and score
randQ2 = nan(nCells, nIterations);
controls.startFrame = derivedQInput.startFrame;
controls.endFrame = derivedQInput.endFrame;
for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
%     if mod(i, 100) == 0
%         fprintf('>>> Random: %i of %i\n', i, nIterations)
%     end
    randDATA = generateRandData(DATA, controls);
    [~, randQ2(:, i)] = derivedQAnalysisFast(randDATA, derivedQInput);
end

%Classify Time Cells
for cell = 1:nCells
    score2 = (sum(Q2(cell)>randQ2(cell, :))/nIterations)*100;
    
    if score2 > threshold
        timeCells2(cell) = 1;
    else
        timeCells2(cell) = 0;
    end
    
    thresholdOtsu2 = graythresh(Q2); %Otsu's method
    timeCells4 = Q2 > thresholdOtsu2;
end

derivedQOutput.Q2 = Q2;
derivedQOutput.T = peakTimeBin;
derivedQOutput.timeCells2 = timeCells2;
derivedQOutput.timeCells4 = timeCells4;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method F scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(derivedQOutput.Q2, nanTest_input);
derivedQOutput.nanList = nanList;

end