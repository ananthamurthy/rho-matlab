function [stcaOutput] = runSimpleTCAnalysis(DATA, simpleInput)

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

nIterations = simpleInput.nIterations;
threshold = simpleInput.threshold; %in 100

%Preallocation
timeCells2 = nan(nCells, 1);
%timeCells4 = nan(nCells, 2); %Unnecessary preallocation
randQ2 = nan(nCells, nIterations);

[peakTimeBin, Q2] = simpleAnalysisFast(DATA, simpleInput);

%Generate circularly shifted randomized data
controls.startFrame = simpleInput.startFrame;
controls.endFrame = simpleInput.endFrame;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
%     if mod(i, 100) == 0
%         fprintf('>>> Random: %i of %i\n', i, nIterations)
%     end
    randDATA = generateRandData(DATA, controls);
    [~, randQ2(:, i)] = simpleAnalysisFast(randDATA, simpleInput);
end

%Classify Time Cells
%Using comparisons to randomized data
for cell = 1:nCells
    score2 = (sum(Q2(cell)>randQ2(cell, :))/nIterations)*100;
    
    if score2 > threshold
        timeCells2(cell) = 1;
    else
        timeCells2(cell) = 0;
    end
end

%Using Otsu's method of finding threshold
thresholdOtsu2 = graythresh(Q2); %Otsu's method
timeCells4 = Q2 > thresholdOtsu2;

stcaOutput.Q2 = Q2;
stcaOutput.T = peakTimeBin;
stcaOutput.timeCells2 = timeCells2;
stcaOutput.timeCells4 = timeCells4;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method C scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(stcaOutput.Q2, nanTest_input);
stcaOutput.nanList = nanList;

end