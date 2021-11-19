function [response, predictor] = getTheTable4Effects(sdo_batch, cData, input, indices)

% Prepare Look Up Table (LUT)
disp('Creating Look Up Table ...')

nCells = input.nCells;
nMethods = input.nMethods;
nDatasets = length(indices);

preLUT = zeros(nCells*nDatasets, nMethods+1);

count = 0;
for dnum = indices(1):indices(nDatasets)
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
            preLUT(start:finish, column) = squeeze(sdo_batch(dnum).Q);
        elseif column == 3
            preLUT(start:finish, column) = squeeze(cData.methodA.mAOutput_batch(dnum).Q); %scores
        elseif column == 4
            preLUT(start:finish, column) = squeeze(cData.methodB.mBOutput_batch(dnum).Q); %scores
        elseif column == 5
            preLUT(start:finish, column) = squeeze(cData.methodC.mCOutput_batch(dnum).Q2); %scores
        elseif column == 6
            preLUT(start:finish, column) = squeeze(cData.methodD.mDOutput_batch(dnum).Q); %scores
        elseif column == 7
            preLUT(start:finish, column) = squeeze(cData.methodE.mEOutput_batch(dnum).Q); %scores
        elseif column == 8
            preLUT(start:finish, column) = squeeze(cData.methodF.mFOutput_batch(dnum).Q2); %scores
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