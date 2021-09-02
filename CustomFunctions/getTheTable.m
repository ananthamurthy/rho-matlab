function [response, predictor] = getTheTable(sdo_batch, cData, input)

% Prepare Look Up Table (LUT)
disp('Creating Look Up Table ...')

nCells = input.nCells;
nMethods = input.nMethods;
nDatasets = input.nDatasets;

preLUT = zeros(nCells*nDatasets, nMethods+1);

count = 0;
for dnum = 1:nDatasets
    count = count + 1;
    start = ((count-1)*nCells + 1);
    finish = count*nCells;
    %fprintf('Start = %i, Finish = %i\n', start, finish)
    
    reality = zeros(nCells, 1); %Preallocate
    reality(sdo_batch(dnum).ptcList) = 1; %Ground Truth
    
    for method = 1:nMethods+1
        if method == 1
            preLUT(start:finish, method) = reality; %Ground Truth - True Class Labels
        elseif method == 2
            preLUT(start:finish, method) = squeeze(sdo_batch(dnum).Q);
        elseif method == 3
            preLUT(start:finish, method) = squeeze(cData.methodA.mAOutput_batch(dnum).Q); %scores
        elseif method == 4
            preLUT(start:finish, method) = squeeze(cData.methodB.mBOutput_batch(dnum).Q); %scores
        elseif method == 5
            preLUT(start:finish, method) = squeeze(cData.methodC.mCOutput_batch(dnum).Q2); %scores
        elseif method == 6
            preLUT(start:finish, method) = squeeze(cData.methodD.mDOutput_batch(dnum).Q); %scores
        elseif method == 7
            preLUT(start:finish, method) = squeeze(cData.methodE.mEOutput_batch(dnum).Q); %scores
        elseif method == 8
            preLUT(start:finish, method) = squeeze(cData.methodF.mFOutput_batch(dnum).Q2); %scores
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
predictor = LUT(:, 2:input.nMethods+1);
end
% toc
