% close all
% clear

% tic
function [Y, X] = consolidatePredictions4Real(input, cData)

%nCells = input.nCells;
nAlgos = input.nAlgos;

% Prepare Look Up Table (lut)
disp('Creating Confusion Matrix ...')
%preLUT = zeros(nCells*input.nDatasets, nAlgos+1);

%reality = zeros(input.nDatasets, nCells);

count = 0;

for dnum = 1:input.nDatasets
    count = count + 1;
    nCells = length(cData.methodA.mAOutput_batch(dnum).nanList1);
    start = ((count-1)*nCells + 1);
    finish = count*nCells;
    %fprintf('Start = %i, Finish = %i\n', start, finish)

    reality = nan(nCells, 1);
    for algo = 1:nAlgos+1
        if algo == 1
            preLUT(start:finish, algo) = reality;
        elseif algo == 2
            try
                preLUT(start:finish, algo) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells1);
            catch
                fprintf('Dataset: %i has a problem.\n', dnum)
                continue
            end
            elseif algo == 3
            preLUT(start:finish, algo) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells2);
        elseif algo == 4
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells1);
        elseif algo == 5
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells2);
        elseif algo == 6
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells3);
        elseif algo == 7
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells4);
        elseif algo == 8
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells5);
        elseif algo == 9
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells6);
        elseif algo == 10
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells1);
        elseif algo == 11
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells2);
        elseif algo == 12
            preLUT(start:finish, algo) = squeeze(cData.methodD.mDOutput_batch(dnum).timeCells1);
        elseif algo == 13
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells1);
        elseif algo == 14
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells2);
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

Y = LUT(:, 1); %Truth
X = LUT(:, 2:input.nAlgos+1);

disp('... done!')

end
% toc
