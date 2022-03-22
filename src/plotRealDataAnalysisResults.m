% Load the Consolidated Analysis Details and look for patterns in the plots

close all
%clear

tic

datasetCatalog = 1;

if datasetCatalog == 1
    input.cDate = 20220322;
    input.cRun = 1;
    input.nDatasets = 3;
    input.nMethods = 7; %Real datasets are not analyzed by SVM, currently.
    input.nAlgos = 13;

else
	input.cDate = 20220311;
	input.cRun = 2;
	input.nDatasets = 5;
	input.nMethods = 7;
	input.nAlgos = 13;
end

figureDetails = compileFigureDetails(12, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
methodLabels = {'rR2B', 'Ispk', 'Isec', 'MI', 'pAUC', 'offPCA', 'Param.'};
algoLabels = {'rR2B-Bo', 'rR2B-Ot', 'Ispk-Bo', 'Isec-Bo', 'MI-Bo', 'Ispk-Ot', 'Isec-Ot', 'MI-Ot', 'pAUC-Bo', 'pAUC-Ot', 'offPCA-Ot', 'Param-Bo', 'Param-Ot'};

workingOnServer = 0;
% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end

addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))

make_db_realBatch %in localCopies

%Load analysis output
fullFilePath = sprintf('%srealDATA_Analysis_%i_cRun%i_cData.mat', saveDirec, input.cDate, input.cRun);
load(fullFilePath)

allPredictors = [];
allPredictions = [];
nCellsAnalyzed = 0;
for dnum = 1:input.nDatasets
    fprintf('Dataset: Mouse %s, Recording Date %s\n', db0(dnum).mouseName, db0(dnum).date)

    %Load processed real data
    realProcessedData = load(strcat(saveDirec, db0(dnum).mouseName, '_', db0(dnum).date, '.mat'));
    DATA = realProcessedData.dfbf;
    DATA_2D = realProcessedData.dfbf_2D;
    input.nCells = size(DATA, 1);
    input.nTrials = size(DATA, 2);
    input.nFrames = size(DATA, 3);
    fprintf('nCells: %i\n', input.nCells)

    %Consolidate scores
    predictors = getPredictors4RealData(cData, input, dnum);
    allPredictors = [allPredictors; predictors];

    %Consolidate predictions
    predictions = getPredictions4RealData(cData, input, dnum);
    allPredictions = [allPredictions; predictions];

    nCellsAnalyzed = nCellsAnalyzed + input.nCells;

    fig1 = figure(1);
    set(fig1, 'Position', [100, 100, 1200, 600])
    imagesc(zscore(predictors, 0))
    title([db0(dnum).mouseName ' ' db0(dnum).date ' Session ' num2str(db0(dnum).session)], ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight','bold')
    xlabel('Methods', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight','bold')
    xticks(1:input.nMethods)
    xticklabels(methodLabels)
    ylabel('Cells', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight','bold')
    z = colorbar;
    ylabel(z, 'Z-Score', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight','bold')
    colormap(linspecer)
    set(gca, 'FontSize', figureDetails.fontSize)
    print(sprintf('%s%s_%s_scores', HOME_DIR2, db0(dnum).mouseName, db0(dnum).date), ...
        '-djpeg')

    fig2 = figure(2);
    set(fig2, 'Position', [100, 100, 1200, 600])
    imagesc(predictions)
            title([db0(dnum).mouseName ' ' db0(dnum).date ' Session ' num2str(db0(dnum).session)], ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight','bold')
            xlabel('Algorithms', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight','bold')
            xticks(1:input.nAlgos)
            xticklabels(algoLabels)
            ylabel('Cells', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight','bold')
    z = colorbar;
    ylabel(z, 'Is Time Cell?', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight','bold')
    colormap(gray)
    set(gca, 'FontSize', figureDetails.fontSize)
    print(sprintf('%s%s_%s_predictions', HOME_DIR2, db0(dnum).mouseName, db0(dnum).date), ...
        '-djpeg')

end
fprintf('Total Cells Analyzed: %i\n', nCellsAnalyzed)

percentTCpredictions = (sum(allPredictions, 1)/nCellsAnalyzed)*100;
fig3 = figure(3);
set(fig3, 'Position', [100, 100, 1200, 600])
bar(percentTCpredictions)
title('How many Time Cells?', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xlabel('Algorithms', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
xticks(1:input.nAlgos)
xticklabels(algoLabels)
ylabel('Predictions (%)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight','bold')
print(sprintf('%sallPredictions', HOME_DIR2), ...
        '-djpeg')
elapsedTime3 = toc;
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime3)
disp('... All Done!')
