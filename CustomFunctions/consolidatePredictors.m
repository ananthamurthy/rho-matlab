function [response, predictor] = consolidatePredictors(sdo_batch, cData, input)

% Prepare Look Up Table (LUT)
disp('Creating Look Up Table ...')

nCells = input.nCells;
nMethods = input.nMethods;
nDatasets = input.nDatasets;

preLUT = zeros(nCells*nDatasets, nMethods+2);

count = 0;
for dnum = 1:nDatasets
    count = count + 1;
    start = ((count-1)*nCells + 1);
    finish = count*nCells;
    %fprintf('Start = %i, Finish = %i\n', start, finish)
    
    reality = zeros(nCells, 1); %Preallocate
    reality(sdo_batch(dnum).ptcList) = 1; %Ground Truth
    
    for column = 1:nMethods+2
        if column == 1
            preLUT(start:finish, column) = reality; %Ground Truth - True Class Labels
        elseif column == 2
            preLUT(start:finish, column) = squeeze(sdo_batch(dnum).Q); %Ref Q
        elseif column == 3
            preLUT(start:finish, column) = squeeze(cData.methodA.mAOutput_batch(dnum).Q1); %scores
        elseif column == 4
            preLUT(start:finish, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q1); %scores
        elseif column == 5
            preLUT(start:finish, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q2); %scores
        elseif column == 6
            preLUT(start:finish, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q3); %scores
        elseif column == 7
            preLUT(start:finish, column) = squeeze(cData.methodC.mCOutput_batch(dnum).Q1); %scores
        elseif column == 8
            preLUT(start:finish, column) = squeeze(cData.methodD.mDOutput_batch(dnum).Q1); %scores
        elseif column == 9
            preLUT(start:finish, column) = squeeze(cData.methodE.mEOutput_batch(dnum).Q1); %scores
        elseif column == 10
            preLUT(start:finish, column) = squeeze(cData.methodF.mFOutput_batch(dnum).Q1); %scores
        end
    end
end

if input.removeNaNs
    %Edit out NaNs as O
    reshapedLUT = reshape(preLUT, [], 1);
    reshapedLUT(isnan(reshapedLUT)) = 0;
    LUT = reshape(reshapedLUT, size(preLUT));
else
    LUT = preLUT;
end
disp('... done!')

response = LUT(:, 1); % Ground Truth - True Class Labels
predictor = LUT(:, 3:input.nMethods+2);
end
% toc
