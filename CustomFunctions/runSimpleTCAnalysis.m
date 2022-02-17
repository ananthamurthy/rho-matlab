function [stcaOutput] = runSimpleTCAnalysis(DATA, simpleInput)

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

nIterations = simpleInput.nIterations;
threshold = simpleInput.threshold; %in 100

%Preallocation
timeCells1 = nan(nCells, 1);
%timeCells2 = nan(nCells, 2); %Unnecessary preallocation
randQ1 = nan(nCells, nIterations);

[peakTimeBin, Q1] = simpleAnalysisFast(DATA, simpleInput);

%Generate circularly shifted randomized data
controls.startFrame = simpleInput.startFrame;
controls.endFrame = simpleInput.endFrame;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
%     if mod(i, 100) == 0
%         fprintf('>>> Random: %i of %i\n', i, nIterations)
%     end
    randDATA = generateRandData(DATA, controls);
    [~, randQ1(:, i)] = simpleAnalysisFast(randDATA, simpleInput);
end

%Classify Time Cells
%Using comparisons to randomized data
for cell = 1:nCells
    score2 = (sum(Q1(cell)>randQ1(cell, :))/nIterations)*100;
    
    if score2 > threshold
        timeCells1(cell) = 1;
    else
        timeCells1(cell) = 0;
    end
end

%Using Otsu's method of finding threshold
thresholdOtsu2 = graythresh(Q1); %Otsu's method
timeCells2 = Q1 > thresholdOtsu2;

stcaOutput.Q1 = Q1;
stcaOutput.T1 = peakTimeBin;
stcaOutput.timeCells1 = timeCells1;
stcaOutput.timeCells2 = timeCells2;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method C scores';
nanTest_input.dimensions = '1D';
nanList1 = lookout4NaNs(stcaOutput.Q1, nanTest_input);
stcaOutput.nanList1 = nanList1;

end