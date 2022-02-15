% close all
% clear

% tic
function [Y, X] = developConfusionMatrix(input, sdo_batch, cData)

nCells = input.nCells;
nAlgos = input.nAlgos;
nDatasets = input.nDatasets;
%figureDetails = compileFigureDetails(16, 2, 5, 0.5, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magm
%C = distinguishable_colors(nAlgos);

% Prepare Look Up Table (lut)
disp('Creating Confusion Matrix ...')
preLUT = zeros(nCells*nDatasets, nAlgos+1);

%reality = zeros(nDatasets, nCells);

count = 0;
for dnum = 1:nDatasets
    count = count + 1;
    start = ((count-1)*nCells + 1);
    finish = count*nCells;
    %fprintf('Start = %i, Finish = %i\n', start, finish)
    
    reality = zeros(nCells, 1); %Preallocate
    reality(sdo_batch(dnum).ptcList) = 1; %Ground Truth
    
    for algo = 1:nAlgos+1
        if algo == 1
            preLUT(start:finish, algo) = reality;
        elseif algo == 2
            preLUT(start:finish, algo) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells);
        elseif algo == 3
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells);
        elseif algo == 4
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells2);
        elseif algo == 5
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells4);
        elseif algo == 6
            preLUT(start:finish, algo) = squeeze(cData.methodD.mDOutput_batch(dnum).timeCells);
        elseif algo == 7
            preLUT(start:finish, algo) = squeeze(cData.methodE.mEOutput_batch(dnum).timeCells);
        elseif algo == 8
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells2);
        elseif algo == 9
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells4);
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
