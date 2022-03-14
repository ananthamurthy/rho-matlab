%This function finds and consolidates all the Quality scores by the various
%methods on a single dataset's worth of cells.

function predictors = getPredictors4RealData(cData, input, dnum)

disp('Finding predictors ...')

nCells = input.nCells;
nMethods = input.nMethods;

predictors = zeros(nCells, nMethods);

for column = 1:nMethods
    try
    if column == 1
        predictors(:, column) = squeeze(cData.methodA.mAOutput_batch(dnum).Q1); %scores
    elseif column == 2
        predictors(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q1); %scores
    elseif column == 3
        predictors(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q2); %scores
    elseif column == 4
        predictors(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q3); %scores
    elseif column == 5
        predictors(:, column) = squeeze(cData.methodC.mCOutput_batch(dnum).Q1); %scores
    elseif column == 6
        predictors(:, column) = squeeze(cData.methodD.mDOutput_batch(dnum).Q1); %scores
    elseif column == 7
        predictors(:, column) = squeeze(cData.methodF.mFOutput_batch(dnum).Q1); %scores
    end
    catch
        size(cData.methodA.mAOutput_batch(dnum).Q1)
    end
end

disp('... done!')

end