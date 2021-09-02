function [derivedQOutput] = runDerivedQAnalysis(DATA, derivedQInput)

nIterations = derivedQInput.nIterations;
threshold = derivedQInput.threshold;

nCells = size(DATA, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

timeCells1 = nan(nCells, 1);
timeCells2 = nan(nCells, 1);

[peakTimeBin, Q1, Q2] = derivedQAnalysis(DATA, derivedQInput);

randQ1 = nan(nCells, nIterations);
randQ2 = nan(nCells, nIterations);

%Generate circularly shifted randomized data
controls.startFrame = derivedQInput.startFrame;
controls.endFrame = derivedQInput.endFrame;
%controls.dbase = derivedQInput.dbase;

for i = 1:nIterations
    %fprintf('>>> Randomized dataset: %i of %i ...\n', i, nIterations)
    randDATA = generateRandData(DATA, controls);
    [randQ1(:, i), randQ2(:, i)] = derivedQAnalysis(randDATA, derivedQInput);
end

%Classify Time Cells
for cell = 1:nCells
    score1 = (sum(Q1(cell)>randQ1(cell, :))/nIterations)*100;
    score2 = (sum(Q2(cell)>randQ2(cell, :))/nIterations)*100;
    
    if score1 > threshold
        timeCells1(cell) = 1;
    else
        timeCells1(cell) = 0;
    end
    
    if score2 > threshold
        timeCells2(cell) = 1;
    else
        timeCells2(cell) = 0;
    end
    
    threshold1 = graythresh(Q1); %Otsu's method
    threshold2 = graythresh(Q2); %Otsu's method
    timeCells3 = Q1 > threshold1;
    timeCells4 = Q1 > threshold2;
end

derivedQOutput.Q1 = Q1;
derivedQOutput.Q2 = Q2;
derivedQOutput.T = peakTimeBin;
derivedQOutput.timeCells1 = timeCells1;
derivedQOutput.timeCells2 = timeCells2;
derivedQOutput.timeCells3 = timeCells3;
derivedQOutput.timeCells4 = timeCells4;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method F scores';
nanTest_input.dimensions = '1D';
nanList = lookout4NaNs(derivedQOutput.Q2, nanTest_input);
derivedQOutput.nanList = nanList;

end