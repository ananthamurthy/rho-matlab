function [stcaOutput] = runSimpleTCAnalysis(DATA, simpleInput)

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

nIterations = simpleInput.nIterations;
threshold = simpleInput.threshold; %in 100
%threshold2 = simpleInput.threshold;

%Preallocation
timeCells1 = nan(nCells, 1);
timeCells2 = nan(nCells, 1);
timeCells3 = nan(nCells, 1);
%timeCells4 = nan(nCells, 2); %Unnecessary preallocation
randQ1 = nan(nCells, nIterations);
randQ2 = nan(nCells, nIterations);

[peakTimeBin, Q1, Q2] = simpleAnalysis(DATA, simpleInput);

%Generate circularly shifted randomized data
controls.startFrame = simpleInput.startFrame;
controls.endFrame = simpleInput.endFrame;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
    fprintf('>> Random: %i\n', i)
    randDATA = generateRandData(DATA, controls);
    [~, randQ1(:, i), randQ2(:, i)] = simpleAnalysis(randDATA, simpleInput);
end

%Classify Time Cells
%Using comparisons to randomized data
for cell = 1:nCells
    %score1 = (sum(Q1(cell)>randQ1(cell, :))/nIterations)*100;
    score2 = (sum(Q2(cell)>randQ2(cell, :))/nIterations)*100;
    
%     if score1 > threshold
%         timeCells1(cell) = 1;
%     else
%         timeCells1(cell) = 0;
%     end
    
    if score2 > threshold
        timeCells2(cell) = 1;
    else
        timeCells2(cell) = 0;
    end
end

%Using Otsu's method of finding threshold
%thresholdOtsu1 = graythresh(Q1); %Otsu's method
thresholdOtsu2 = graythresh(Q2); %Otsu's method
%timeCells3 = Q1 < thresholdOtsu1; %NOTE: "<"
timeCells4 = Q2 > thresholdOtsu2;

%stcaOutput.ETH = ETH;
stcaOutput.Q1 = Q1;
stcaOutput.Q2 = Q2;
stcaOutput.T = peakTimeBin;
stcaOutput.timeCells1 = timeCells1;
stcaOutput.timeCells2 = timeCells2;
stcaOutput.timeCells3 = timeCells3;
stcaOutput.timeCells4 = timeCells4;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method C scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(stcaOutput.Q2, nanTest_input);
stcaOutput.nanList = nanList;

end