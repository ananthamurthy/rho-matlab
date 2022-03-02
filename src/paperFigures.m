% Paper Figures
% AUTHOR: Kambadur Ananthamurthy
% DETAILS: 537 uniquely tagged synthetic datasets were analysed on the basis
% of a variety of numerical procedures. Cells in each dataset were given
% analog scores on the same basis.
% Load the Consolidated Analysis Details and look for patterns in the plots.

close all
%clear

tic
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))
%% Plots - I
%%
%generateSyntheticDataExample
%% Subsequent plots
%%
input.nCells = 135;
input.nAlgos = 14; %detection algorithms
input.nMethods = 8; %scoring methods

datasetCatalog = 1; %Only to select the batch for datasets

if datasetCatalog == 0
    %Synthetic Dataset Details
    input.gDate = 20220301; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 60;

    % Consolidated Analysis Details
    input.cDate = 20220301; %consolidation date - vs 20220226
    input.cRun = 1; %consoildation run number

elseif datasetCatalog == 1
    % Synthetic Dataset Details
    input.gDate = 20220217; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 537;

    % Consolidated Analysis Details
    input.cDate = 20220217; %consolidation date
    input.cRun = 1; %consolidation run number
end

workingOnServer = 0; %Current
diaryOn         = 0;

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
%Additinal search paths
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions')))
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies')))
make_db

saveFolder = strcat(saveDirec, db.mouseName, '/', db.date, '/');

if diaryOn
    if workingOnServer == 1
        diary (strcat(HOME_DIR, '/logs/benchmarksDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/benchmarksDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

% Operations
plotRefQ = 1;
plotAnalysedQs = 1;
plotDatasetCheck = 0;

% Load Synthetic Data
if ~exist("sdo_batch", "var")
    disp('Loading synthetic datasets ...')
    synthDataFilePath = sprintf('%s/synthDATA_%i_gRun%i_batch_%i.mat', ...
        saveFolder, ...
        input.gDate, ...
        input.gRun, ...
        input.nDatasets);
    load(synthDataFilePath)
    disp('... done!')
end

% Load Analysis Results
if ~exist("cData", "var")
    disp('Loading analysis results ...')
    analysisFilePath = sprintf('%s/synthDATA_Analysis_%i_cRun%i_cData.mat', ...
        saveFolder, ...
        input.cDate, ...
        input.cRun);
    load(analysisFilePath)
    disp('... done!')
end

%%
input.removeNaNs = 0;
input.saveFolder = saveFolder;
[Y, X] = consolidatePredictions(input, sdo_batch, cData);

% TP, FN, FP, TN
%nCases = length(Y);
%confusionMatrix = zeros(input.nAlgos, 2, 2);

clear results1
clear results2
clear results3
[results1, ~, results3] = compareAgainstTruth(X, Y, input);

% Search for uniquely identified Time Cells with some threshold
unique1 = zeros(length(Y), input.nAlgos);
unique2 = zeros(length(Y), input.nAlgos);
unique3 = zeros(length(Y), input.nAlgos);
for obs = 1:length(Y)
    if sum(squeeze(X(obs, :))) == 1
        unique1(obs, :) = X(obs, :);
    elseif sum(squeeze(X(obs, :))) == 2
        unique2(obs, :) = X(obs, :);
    elseif sum(squeeze(X(obs, :))) == 3
        unique3(obs, :) = X(obs, :);
    end
end

input.plotOptimalPoint = 0;
figureDetails = compileFigureDetails(11, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
%C = distinguishable_colors(input.nMethods);
C = linspecer(input.nMethods);

%disp('Generating subplot 1 ...')
input.removeNaNs = 1;

%Prepare the Look Up Table (LUT)
[response, predictor] = consolidatePredictors(sdo_batch, cData, input); %NOTE: "response" is identical to "Y".

%Normalize
maximaN = zeros(input.nMethods, 1);
minimaN = zeros(input.nMethods, 1);
normPredictor = zeros(size(predictor));
for method = 1:input.nMethods
    maximaN(method) = max(predictor(:, method));
    minimaN(method) = min(predictor(:, method));

    posi = find(predictor(:, method) > 0);
    negi = find(predictor(:, method) < 0);
    normPredictor(posi, method) = predictor(posi, method)/maximaN(method);
    normPredictor(negi, method) = -1 * predictor(negi, method)/minimaN(method);
end

%Z-Score
zPredictor = zscore(predictor);

% Normalize Z-Score
maximaZ = zeros(input.nMethods, 1);
minimaZ = zeros(input.nMethods, 1);
nzPredictor = zeros(size(predictor));
for method = 1:input.nMethods
    maximaZ(method) = max(zPredictor(:, method));
    minimaZ(method) = min(zPredictor(:, method));

    posi = find(zPredictor(:, method) > 0);
    negi = find(zPredictor(:, method) < 0);
    nzPredictor(posi, method) = zPredictor(posi, method)/maximaN(method);
    nzPredictor(negi, method) = -1 * zPredictor(negi, method)/minimaN(method);
end

correlationMatrix = corrcoef(normPredictor, 'Rows', 'pairwise');
%correlationMatrix = corrcoef(predictor);

%Labels
algoLabels = {'rR2B-Bo', 'rR2B-Ot', 'Ispk-Bo', 'Isec-Bo', 'MI-Bo', 'Ispk-Ot', 'Isec-Ot', 'MI-Ot', 'pAUC-Bo', 'pAUC-Ot', 'offPCA-Ot', 'SVM-Ot', 'Param-Bo', 'Param-Ot'};
concordanceAlgoLabels = {'>=1', '>=2', '>=3', '>= 4', '>= 5', '>= 6', '>=7', '>=8', '>=9', '>=10', '>=11', '>=12', '>=13', '=14'};
metricLabels = {' All TPs', ' All FPs', ' All TNs', ' All FNs'};
metricLabels_pos = {'TP', 'FP'};
metricLabels_neg = {'TN', 'FN'};
metricLabels2 = {'Recall', 'Precision', 'F1 Score'};
methodLabels = {'rR2B', 'Ispk', 'Isec', 'MI', 'pAUC', 'offPCA', 'SVM', 'Param.'}; %8 scoring methods
procedureLabels = {'Synth.', 'rR2B', 'TI', 'pAUC', 'offPCA', 'SVM', 'Param.'};

%% Plots - IV
%%
disp('Plotting Scores and Comparisions ...')
fig4 = figure(4);
clf
set(fig4, 'Position', [1000, 300, 900, 1200])
title(sprintf('Comparative Analysis (N=%i)', input.nDatasets), ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')

for method = 1:input.nMethods
    ptcScores = normPredictor(response == 1, method);
    ocScores = normPredictor(response == 0, method);

    if method == 1
        subplotNum = 1;
    elseif method == 2
        subplotNum = 2;
    elseif method == 3
        subplotNum = 9;
    elseif method == 4
        subplotNum = 10;
    elseif method == 5
        subplotNum = 17;
    elseif method == 6
        subplotNum = 18;
    elseif method == 7
        subplotNum = 25;
    elseif method == 8
        subplotNum = 26;
    end

    subplot(20, 2, subplotNum)
    h = histogram(ptcScores, ...
        'EdgeColor', C(2, :), ...
        'FaceColor', C(2, :));
    if method == 1
        %morebins(h);
        h.NumBins = 10000;
    end
    binWidth = h.BinWidth;
    %     ylabel('Counts', ...
    %         'FontSize', figureDetails.fontSize, ...
    %         'FontWeight', 'bold')
    hold off
    title(sprintf('Method: %s', char(methodLabels(method))), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')

    %     if method == 1
    %         %xlim([-0.005, 0.005])
    %         xlim([-0.005, 0.005])
    %     elseif method == 2
    %         xlim([-0.005, 0.005])
    %     elseif method == 3
    %         xlim([0, 1])
    %     elseif method == 4
    %         xlim([-0.6, 0.6])
    %     elseif method == 5
    %         xlim([-0.5, 0.5])
    %     elseif method == 6
    %         xlim([0, 1])
    %     end
    %     lgd = legend({'Time Cells'}, ...
    %             'Location', 'northwest');
    %         lgd.FontSize = figureDetails.fontSize-3;
    if method == 1 || method == 2
        lgd = legend({'Time Cells'}, ...
            'Location', 'northeast');
        lgd.FontSize = figureDetails.fontSize-3;
    end
    set(gca, 'FontSize', figureDetails.fontSize)

    subplot(20, 2, subplotNum+4)
    histogram(ocScores, ...
        'BinWidth', binWidth, ...
        'EdgeColor', C(1, :), ...
        'FaceColor', C(1, :))
    ylabel('Counts', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    hold off
    if method == 7 || method == 8
        xlabel('Binned Norm. Scores', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
    end
    %     title(sprintf('Method: %s', char(methodLabels(method))), ...
    %         'FontSize', figureDetails.fontSize, ...
    %         'FontWeight', 'bold')

    %     if method == 1
    %         %xlim([-0.005, 0.005])
    %         xlim([-0.005, 0.005])
    %     elseif method == 2
    %         xlim([-0.005, 0.005])
    %     elseif method == 3
    %         xlim([0, 1])
    %     elseif method == 4
    %         xlim([-0.6, 0.6])
    %     elseif method == 5
    %         xlim([-0.5, 0.5])
    %     elseif method == 6
    %         xlim([0, 1])
    %     end
    %     lgd = legend({'Other Cells'}, ...
    %             'Location', 'northwest');
    %         lgd.FontSize = figureDetails.fontSize-3;
    if method == 1 || method == 2
        lgd = legend({'Other Cells'}, ...
            'Location', 'northeast');
        lgd.FontSize = figureDetails.fontSize-3;
    end
    set(gca, 'FontSize', figureDetails.fontSize)

end
hold off

subplot(20, 2, [35, 37, 39])

%for method = input.nMethods:-1:1
for method = 1:input.nMethods
    %disp(method)
    %Linear Regression
    clear Mdl
    Mdl = fitglm(predictor(:, method), response, ...
        'Distribution', 'binomial', ...
        'Link', 'logit');

    %Get the scores
    score_log = Mdl.Fitted.Probability;

    %ROC Curve coordinates
    [Xlog, Ylog, Tlog, AUClog, optOP] = perfcurve(response, score_log, 1);
    %disp(Xlog)
    %disp(Ylog)
    %disp(optOP)

    %     if isnan(Xlog) || isnan(Ylog)
    %         warning('Probably skipping ...')
    %     end

    %Plots
    plot(Xlog, Ylog, '-.', ...
        'Color', C(method, :), ...
        'LineWidth', figureDetails.lineWidth)
    hold on

    if input.plotOptimalPoint
        try
            plot(optOP(1), optOP(2), 'Color', C(method, :), 'o')
        catch
            warning('Unable to plot optimal oprational point')
        end
        hold on
    end
end
hold off
% title(sprintf('ROC Curves (N=%i)', input.nDatasets), ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
title('ROC Curves', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xlabel('False Positive Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('True Positive Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
lgd1 = legend(methodLabels, ...
    'Location', 'southeastoutside');
lgd1.FontSize = figureDetails.fontSize-3;

set(gca, 'FontSize', figureDetails.fontSize)

%subplot(3, 9, 24:26)
subplot(20, 2, [36, 38, 40])
h = heatmap(correlationMatrix, ...
    'Colormap', linspecer, ...
    'Title', 'Correlation Coefficients', ...
    'CellLabelColor','none');
h.XDisplayLabels = methodLabels;
h.YDisplayLabels = methodLabels;
%h.YDisplayLabels = {'', '', '', '', '', ''};
set(gca, 'FontSize', figureDetails.fontSize)

print(sprintf('%s/ComparingScores-%i-%i-%i-%i-%i_%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    input.cDate, ...
    input.cRun, ...
    workingOnServer), ...
    '-dpng')

disp('... Scores and Comparisons Plotted')
%% Plots - V
%%
disp('Plotting Performance Metrics ...')

fig5 = figure(5);
clf
set(fig5, 'Position', [600, 300, 900, 1200])
subplot(11, 8, [1:4, 9:12])
d1 = bar(results1(:, 1:2));
d1(1).FaceColor = C(3,:);
d1(2).FaceColor = C(1,:);
xlim([0 5])
axis tight
title('Positive Class Predictions', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('All Algorithms', ...
% 'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels({'', '', '', '', '', '', '', '', })
xticklabels(algoLabels)
xtickangle(45)
lgd = legend(metricLabels_pos, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

subplot(11, 8, [5:8, 13:16])
d2 = bar(results1(:, 3:4));
d2(1).FaceColor = C(2,:);
d2(2).FaceColor = C(1,:);
xlim([0 5])
axis tight
title('Negative Class Predictions', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('All Algorithms', ...
% 'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels({'', '', '', '', '', '', '', '', })
xticklabels(algoLabels)
xtickangle(45)  
lgd = legend(metricLabels_neg, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

subplot(11, 8, (25:40))
d = bar(results3);
xlim([0 5])
axis tight
title('Predictive Performance Metrics - II', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('All Algorithms', ...
% 'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels({'', '', '', '', '', '', '', '', })
xticklabels(algoLabels)
xtickangle(45)
lgd = legend(metricLabels2, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

totalCells = length(sdo_batch)*input.nCells;
allUnique = zeros(input.nAlgos, 3);
allUnique(:, 1) = (sum(unique1, 1)*100)/totalCells;
allUnique(:, 2) = (sum(unique2, 1)*100)/totalCells;
allUnique(:, 3) = (sum(unique3, 1)*100)/totalCells;
subplot(11, 8, (49:64))
bar(allUnique)
xlim([1, 8])
axis tight
title('Unique Time Cell Predictions', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('All Algorithms', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Counts/Total (%)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels)
xtickangle(45)
%set(gca,'xtick',[])
lgd = legend({'1/14 Algo', '2/14 Algo', '3/14 Algo'}, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

disp('Loading runtimes ...')
meanInUse = zeros(7, 3); %3 cases; 7 steps or numerical procedures
stdInUse = zeros(7, 3);
meanRunTime = zeros(7, 3);
stdRunTime = zeros(7, 3);

for iCase = 1:3
    if iCase == 1
        nShuffles = 1;
    elseif iCase == 2
        nShuffles = 4;
    elseif iCase == 3
        nShuffles = 10;
    end
    runtimeFilePath = [HOME_DIR 'rho-matlab/profile_nShuffles' num2str(nShuffles) '.mat'];
    load(runtimeFilePath)

    meanInUse(:, iCase) = mean(inUse, 1);
    stdInUse(:, iCase) = std(inUse, 1);

    meanRunTime(:, iCase) = mean(runTime*60, 1);
    stdRunTime(:, iCase) = std(runTime*60, 1);
end
disp('... done!')

%Usage
subplot(11, 8, [73:75, 81:83] )
b1 = bar(meanInUse);
% hold on
% er = errorbar(meanInUse', stdInUse', 'CapSize', 12);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
title('Memory Usage', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xlabel('Steps', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('Workspace (MB)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticks([1, 2, 3, 4, 5, 6, 7])
ylim([0, 700])
%yticks([0, 200, 400, 600])
% lgd = legend({'135 cells', '540 cells', '1350 cells'}, ...
%     'Location', 'southeastoutside');
% lgd.FontSize = figureDetails.fontSize-4;
xticklabels(procedureLabels)
xtickangle(45)
set(gca, 'FontSize', figureDetails.fontSize)

subplot(11, 8, [77:80, 85:88])
%boxplot(runTime, procedureLabels)
%errorbar(meanRunTime', stdRunTime', 'r*', 'CapSize', 10)
b2 = bar(meanRunTime);
axis tight
set(gca,'YScale','log')
xticks([1, 2, 3, 4, 5, 6, 7])
set(gca,'YLim',[1e0 1e4],'YTick',10.^(0:4))
%yticks([1, 10, 100, 100])
axis tight
title('Runtimes', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xlabel('Steps', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('Time (sec)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
lgd = legend({'135 cells', '540 cells', '1350 cells'}, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
xticklabels(procedureLabels)
xtickangle(45)
set(gca, 'FontSize', figureDetails.fontSize)
print(sprintf('%s/PerformanceEvaluation-%i-%i-%i_%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    workingOnServer), ...
    '-djpeg')

disp('... Performance Metrics Plotted')
%% Plots VI
%%
disp('Plotting Sensitivity and Resource ...')
x = 1:input.nAlgos;
joinBundledResults3 = [];
joinAllResults3 = [];
nSets = 3;

if datasetCatalog == 0
    iNoise1 = (1:5); %low
    iNoise2 = (6:10); %medium
    iNoise3 = (11:15); %high

    iEW1 = (16:20); %small
    iEW2 = (21:25); %medium
    iEW3 = (26:30); %large

    iImp1 = (31:35); %low
    iImp2 = (36:40); %medium
    iImp3 = (41:45); %high

    iHTR1 = (46:50); %low
    iHTR2 = (51:55); %medium
    iHTR3 = (56:60); %high
    
elseif datasetCatalog == 1
    iNoise1 = (418:427); %low
    iNoise2 = (428:437); %medium
    iNoise3 = (438:447); %high

    iEW1 = (448:457); %small
    iEW2 = (458:467); %medium
    iEW3 = (468:477); %large

    iImp1 = (478:487); %low
    iImp2 = (488:497); %medium
    iImp3 = (498:507); %high

    iHTR1 = (508:517); %low
    iHTR2 = (518:527); %medium
    iHTR3 = (528:537); %high
end

fig6 = figure(6);
clf
set(fig6, 'Position', [1500, 300, 900, 1200])

[Y1, X1] = consolidatePredictions4Effects(input, sdo_batch, cData, iNoise1);
[Y2, X2] = consolidatePredictions4Effects(input, sdo_batch, cData, iNoise2);
[Y3, X3] = consolidatePredictions4Effects(input, sdo_batch, cData, iNoise3);

if datasetCatalog == 0
    nShuffles = 5; %same throughout
else
    nShuffles = 10; %same throughout
end

for iSet = 1:nSets
    if iSet == 1
        Xeffect = X1;
        Yeffect = Y1;
    elseif iSet == 2
        Xeffect = X2;
        Yeffect = Y2;
    elseif iSet == 3
        Xeffect = X3;
        Yeffect = Y3;
    end

    for shuffle = 1:nShuffles
        myCells = ((input.nCells*(shuffle-1))+1):(input.nCells*shuffle);
        clear results1
        clear results2
        clear results3
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
        allResults3(shuffle, :, iSet, :) = results3;
    end
end
joinAllResults3 = [joinAllResults3; squeeze(allResults3(:, :, 1, :))]; %For baseline - Noise expts.
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 1))]; %For baseline - Noise expts.
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

%set(b1,'FaceAlpha', 0.5)

dependence1 = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(70-10);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence1_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(70-10);
end
dependence1_stderr_pos = dependence1_stderr_neg;
subplot(11, 2, [7, 9])
% errorbar(meanBundledResults3', stdBundledResults3', ...
%     'LineWidth', figureDetails.lineWidth, ...
%     'CapSize', 10)
% h = heatmap(meanBundledResults3, ...
%     'Colormap', flipud(linspecer), ...
%     'Title', 'The Effect of Noise', ...
%     'CellLabelColor','none');
% h.ColorbarVisible = 'off';
% h.XDisplayLabels = {'10', '40', '70'};
% h.YDisplayLabels = algoLabels;


%yyaxis right
b2 = bar(dependence1);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta Noise', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence1, dependence1_stderr_neg, dependence1_stderr_pos, 'CapSize', 12);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
axis tight
title('Noise (%)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels);
% xticks([1, 2, 3])
% xticklabels({'10', '40', '70'})
xtickangle(45)
%h.XLabel = 'Noise (as %)';
% xlabel('Noise (as %)', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')

%lgd = legend(algoLabels);
%lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

[Y1, X1] = consolidatePredictions4Effects(input, sdo_batch, cData, iEW1);
[Y2, X2] = consolidatePredictions4Effects(input, sdo_batch, cData, iEW2);
[Y3, X3] = consolidatePredictions4Effects(input, sdo_batch, cData, iEW3);


for iSet = 1:nSets
    if iSet == 1
        Xeffect = X1;
        Yeffect = Y1;
    elseif iSet == 2
        Xeffect = X2;
        Yeffect = Y2;
    elseif iSet == 3
        Xeffect = X3;
        Yeffect = Y3;
    end

    for shuffle = 1:nShuffles
        myCells = ((input.nCells*(shuffle-1))+1):(input.nCells*shuffle);
        clear results1
        clear results2
        clear results3
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
        allResults3(shuffle, :, iSet, :) = results3;
    end
end
joinAllResults3 = [joinAllResults3; squeeze(allResults3(:, :, 2, :))]; %For baseline - EW expts.
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 2))]; %For baseline - EW expts.
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence2 = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(90-30);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence2_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(90-30);
end
dependence2_stderr_pos = dependence2_stderr_neg;
subplot(11, 2, [8, 10])
% errorbar(meanBundledResults3', stdBundledResults3', ...
%     'LineWidth', figureDetails.lineWidth, ...
%     'CapSize', 10)
% h = heatmap(meanBundledResults3, ...
%     'Colormap', flipud(linspecer), ...
%     'Title', 'The Effect of Noise', ...
%     'CellLabelColor','none');
% h.ColorbarVisible = 'off';
% h.XDisplayLabels = {'10', '40', '70'};
% h.YDisplayLabels = algoLabels;
% yyaxis left
% b1 = bar(meanBundledResults3(:, 2));
% ylabel('F1 Score', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
% set(b1,'FaceAlpha', 0.5)

%yyaxis right
b2 = bar(dependence2);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta EW', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence2, dependence2_stderr_neg, dependence2_stderr_pos, 'CapSize', 12);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
axis tight
title('EW (%ile)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels);
% xticks([1, 2, 3])
% xticklabels({'10', '40', '70'})
xtickangle(45)
%h.XLabel = 'Noise (as %)';
% xlabel('Noise (as %)', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')

%lgd = legend(algoLabels);
%lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

[Y1, X1] = consolidatePredictions4Effects(input, sdo_batch, cData, iImp1);
[Y2, X2] = consolidatePredictions4Effects(input, sdo_batch, cData, iImp2);
[Y3, X3] = consolidatePredictions4Effects(input, sdo_batch, cData, iImp3);

for iSet = 1:nSets
    if iSet == 1
        Xeffect = X1;
        Yeffect = Y1;
    elseif iSet == 2
        Xeffect = X2;
        Yeffect = Y2;
    elseif iSet == 3
        Xeffect = X3;
        Yeffect = Y3;
    end

    for shuffle = 1:nShuffles
        myCells = ((input.nCells*(shuffle-1))+1):(input.nCells*shuffle);
        clear results1
        clear results2
        clear results3
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
        allResults3(shuffle, :, iSet, :) = results3;
    end
end
joinAllResults3 = [joinAllResults3; squeeze(allResults3(:, :, 1, :))]; %For baseline - Imprecision expts.
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 1))]; %For baseline - Imprecision expts.
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence3 = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(66-0);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence3_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(66-0);
end
dependence3_stderr_pos = dependence3_stderr_neg;
subplot(11, 2, [13, 15])
% errorbar(meanBundledResults3', stdBundledResults3', ...
%     'LineWidth', figureDetails.lineWidth, ...
%     'CapSize', 10)
% h = heatmap(meanBundledResults3, ...
%     'Colormap', flipud(linspecer), ...
%     'Title', 'The Effect of Noise', ...
%     'CellLabelColor','none');
% h.ColorbarVisible = 'off';
% h.XDisplayLabels = {'10', '40', '70'};
% h.YDisplayLabels = algoLabels;
% yyaxis left
% b1 = bar(meanBundledResults3(:, 1));
% ylabel('F1 Score', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
% set(b1,'FaceAlpha', 0.5)

%yyaxis right
b2 = bar(dependence3);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta Imp.', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence3, dependence3_stderr_neg, dependence3_stderr_pos, 'CapSize', 12);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
axis tight
title('Imp. (frames)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels);
% xticks([1, 2, 3])
% xticklabels({'10', '40', '70'})
xtickangle(45)
%h.XLabel = 'Noise (as %)';
% xlabel('Noise (as %)', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')

%lgd = legend(algoLabels);
%lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

[Y1, X1] = consolidatePredictions4Effects(input, sdo_batch, cData, iHTR1);
[Y2, X2] = consolidatePredictions4Effects(input, sdo_batch, cData, iHTR2);
[Y3, X3] = consolidatePredictions4Effects(input, sdo_batch, cData, iHTR3);

for iSet = 1:nSets
    if iSet == 1
        Xeffect = X1;
        Yeffect = Y1;
    elseif iSet == 2
        Xeffect = X2;
        Yeffect = Y2;
    elseif iSet == 3
        Xeffect = X3;
        Yeffect = Y3;
    end

    for shuffle = 1:nShuffles
        myCells = ((input.nCells*(shuffle-1))+1):(input.nCells*shuffle);
        clear results1
        clear results2
        clear results3
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
        allResults3(shuffle, :, iSet, :) = results3;
    end
end
joinAllResults3 = [joinAllResults3; squeeze(allResults3(:, :, 2, :))]; %For baseline - HTR expts.
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 2))]; %For baseline - HTR expts.
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence4 = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(99-33);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence4_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(99-33);
end
dependence4_stderr_pos = dependence4_stderr_neg;
subplot(11, 2, [14, 16])
% errorbar(meanBundledResults3', stdBundledResults3', ...
%     'LineWidth', figureDetails.lineWidth, ...
%     'CapSize', 10)
% h = heatmap(meanBundledResults3, ...
%     'Colormap', flipud(linspecer), ...
%     'Title', 'The Effect of Noise', ...
%     'CellLabelColor','none');
% h.ColorbarVisible = 'off';
% h.XDisplayLabels = {'10', '40', '70'};
% h.YDisplayLabels = algoLabels;
% yyaxis left
% b1 = bar(meanBundledResults3(:, 2));
% ylabel('F1 Score', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
% set(b1,'FaceAlpha', 0.5)

%yyaxis right
b2 = bar(dependence4);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta HTR', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence4, dependence4_stderr_neg, dependence4_stderr_pos, 'CapSize', 12);
er.Color = [0 0 0];
er.LineStyle = 'none';
hold off
axis tight
title('HTR (%)', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels);
% xticks([1, 2, 3])
% xticklabels({'10', '40', '70'})
xtickangle(45)
%h.XLabel = 'Noise (as %)';
% xlabel('Noise (as %)', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')

%lgd = legend(algoLabels);
%lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

meanJoinAllResults3 = squeeze(mean(joinAllResults3, 1, 'omitnan'));
stderrJoinAllResults3 = squeeze(std(joinAllResults3, 1, 'omitnan')/sqrt(size(joinAllResults3, 1)));
meanJoinBundledResults3 = squeeze(mean(joinBundledResults3, 1, 'omitnan'));
stderrJoinBundledResults3 = squeeze(std(joinBundledResults3, 1, 'omitnan')/sqrt(size(joinBundledResults3, 1)));
subplot(11, 2, (1:4))
%yyaxis left
b1 = bar(meanJoinAllResults3);
% b1 = bar(meanJoinBundledResults3);
% b1.FaceColor = C(2, :);
% hold on
% er = errorbar(meanJoinBundledResults3, stderrJoinBundledResults3, 'CapSize', 12);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% hold off
axis tight
title('Baseline - Physiological Regime', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% ylabel('F1 Score', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
xticklabels(algoLabels);
xtickangle(45)
lgd = legend(metricLabels2, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

% Concordance - slightly different algorithm from just using compareAgainstTruth()
[Y, X] = consolidatePredictions(input, sdo_batch, cData);
sumX = sum(X, 2);
nCases = length(Y);

% Now, for any cell, if sumX >= some threshold, we suggest calling it a Time Cell
nConcordanceAlgos = 14; % since input.nAlgos = 8

predictions = zeros(nCases, nConcordanceAlgos);

%Preallocation
allTP = zeros(nCases, nConcordanceAlgos);
allTN = zeros(nCases, nConcordanceAlgos);
allFP = zeros(nCases, nConcordanceAlgos);
allFN = zeros(nCases, nConcordanceAlgos);
TPR = zeros(nConcordanceAlgos, 1); %Sensitivity, Recall, or True Positive Rate
FPR = zeros(nConcordanceAlgos, 1); %Fall-out or False Positive Rate
TNR = zeros(nConcordanceAlgos, 1); %Specificity or True Negative Rate
FNR = zeros(nConcordanceAlgos, 1); %Miss Rate or False Negative Rate
PPV = zeros(input.nAlgos, 1); %Precision or Positive Predictive Value

results4 = zeros(nConcordanceAlgos, 3); %3 because we'll look at Recall, Precision, and F1 Score

for algo = 1:nConcordanceAlgos

    predictions(:, algo) = (sumX >= algo);

    for myCase = 1:nCases
        if Y(myCase) %Positive Cases
            if predictions(myCase, algo)
                allTP(myCase, algo) = 1;
            else
                allFN(myCase, algo) = 1;
            end
        else %Negative Cases
            if predictions(myCase, algo)
                allFP(myCase, algo) = 1;
            else
                allTN(myCase, algo) = 1;
            end
        end
    end

    TP = sum(allTP(:, algo));
    FN = sum(allFN(:, algo));
    FP = sum(allFP(:, algo));
    TN = sum(allTN(:, algo));

    if TP ~= 0
        TPR(algo) = TP/(TP + FN); %Recall
        PPV(algo) = TP/(TP + FP); %Precision
    else
        TPR(algo) = 0; %Recall
        PPV(algo) = 0; %Precision
    end

    if FP ~= 0
        FPR(algo) = FP/(FP + TN);
    else
        FPR(algo) = 0;
    end

    if TN ~= 0
        TNR(algo) = TN/(TN + FP);
    else
        TNR(algo) = 0;
    end

    if FN ~= 0
        FNR(algo) = FN/(FN + TP);
    else
        FNR(algo) = 0;
    end

    results4(algo, 1) = TPR(algo); %Recall
    results4(algo, 2) = PPV(algo); %Precision

    if TP == 0
        results4(algo, 3) = 0;
    else
        results4(algo, 3) = 2 * results4(algo, 1) * results4(algo, 2)/(results4(algo, 1) + results4(algo, 2)); %F1 Score
    end
end

subplot(11, 2, (19:22))
d = bar(results4);
xlim([0 5])
axis tight

xlabel('Classification Concordance Threshold', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(concordanceAlgoLabels)
xtickangle(45)
lgd = legend(metricLabels2, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

print(sprintf('%s/Resource-%i-%i-%i-%i-%i_%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    input.cDate, ...
    input.cRun, ...
    workingOnServer), ...
    '-dpng')

disp('... Sensitivity and Resource Plotted.')

%%
elapsedTime2 = toc;
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime2)
disp('... All Done!')