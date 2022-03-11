function predictions = getPredictions4RealData(cData, input, dnum)

disp('Finding predictions ...')

nCells = input.nCells;
nAlgos = input.nAlgos;

predictions = zeros(nCells, nAlgos);

for column = 1:nAlgos
        if column == 1
            predictions(:, column) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells1);
        elseif column == 2
            predictions(:, column) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells2);
        elseif column == 3
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells1);
        elseif column == 4
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells2);
        elseif column == 5
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells3);
        elseif column == 6
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells4);
        elseif column == 7
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells5);
        elseif column == 8
            predictions(:, column) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells6);
        elseif column == 9
            predictions(:, column) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells1);
        elseif column == 10
            predictions(:, column) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells2);
        elseif column == 11
            predictions(:, column) = squeeze(cData.methodD.mDOutput_batch(dnum).timeCells1);
        elseif column == 12
            predictions(:, column) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells1);
        elseif column == 13
            predictions(:, column) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells2);
        end
end

disp('... done!')

end
