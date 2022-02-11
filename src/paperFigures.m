% Paper Figures
% AUTHOR: Kambadur Ananthamurthy
% DETAILS: 417 uniquely tagged synthetic datasets were analysed on the basis
% of a variety of numerical procedures. Cells in each dataset were given
% analog scores on the same basis.
% Load the Consolidated Analysis Details and look for patterns in the plots.

close all
clear

tic
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))
%% Plots - I
%%
generateSyntheticDataExample
%% Subsequent plots
%%
input.nCells = 135;
input.nAlgos = 8;
input.nMethods = 6;

workingOnServer = 2; %Only to select the batch for datasets

if workingOnServer == 1 %Bebinca
    % Synthetic Dataset Details
    input.gDate = 20211103; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 417;
    
    % Consolidated Analysis Details
    input.cDate = 20210918; %consolidation date @!!!!!
    input.cRun = 1; %consolidation run number
    
elseif workingOnServer == 2 %Adama
    % Synthetic Dataset Details
    input.gDate = 20211120; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 417;
    
    % Consolidated Analysis Details
    input.cDate = 20211124; %consolidation date
    input.cRun = 1; %consolidation run number
end

%workingOnServer = 0; %Current
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
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
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
disp('Loading synthetic datasets ...')
synthDataFilePath = sprintf('%s/synthDATA_%i_gRun%i_batch_%i.mat', ...
    saveFolder, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets);
load(synthDataFilePath)
disp('... done!')


% Load Analysis Results
disp('Loading analysis results ...')
analysisFilePath = sprintf('%s/synthDATA_Analysis_%i_cRun%i_cData.mat', ...
    saveFolder, ...
    input.cDate, ...
    input.cRun);
load(analysisFilePath)
disp('... done!')

input.removeNaNs = 0;
input.saveFolder = saveFolder;
[Y, X] = developConfusionMatrix(input, sdo_batch, cData);

% TP, FN, FP, TN
nCases = length(Y);

%Preallocation
allTP = zeros(nCases, input.nAlgos);
allTN = zeros(nCases, input.nAlgos);
allFP = zeros(nCases, input.nAlgos);
allFN = zeros(nCases, input.nAlgos);
TPR = zeros(input.nAlgos, 1); %Sensitivity
FPR = zeros(input.nAlgos, 1); %Fall-out or False Positive Rate
TNR = zeros(input.nAlgos, 1); %Specificity
FNR = zeros(input.nAlgos, 1); %Miss Rate
PPV = zeros(input.nAlgos, 1); %Positive Predictive Value
NPV = zeros(input.nAlgos, 1); %Negative Predictive Value
FDR = zeros(input.nAlgos, 1); %False Discovery Rate
FOR = zeros(input.nAlgos, 1); %Flase Omission Rate
PT = zeros(input.nAlgos, 1); %Prevalence Threshold
TS = zeros(input.nAlgos, 1); %Threat Score or Critical Success Index (CSI)
ACC = zeros(input.nAlgos, 1); %Accuracy
BA = zeros(input.nAlgos, 1); %Balanced Accuracy

results1 = zeros(input.nAlgos, 4);
results2 = zeros(input.nAlgos, 4);
results3 = zeros(input.nAlgos, 3);

confusionMatrix = zeros(input.nAlgos, 2, 2);

for algo = 1:input.nAlgos
    for myCase = 1:nCases
        if Y(myCase) %Positive Cases
            if X(myCase, algo)
                allTP(myCase, algo) = 1;
            else
                allFN(myCase, algo) = 1;
            end
        else %Negative Cases
            if X(myCase, algo)
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
    
    confusionMatrix(algo, 1, 1) = FN;
    confusionMatrix(algo, 1, 2) = TP;
    confusionMatrix(algo, 2, 1) = TN;
    confusionMatrix(algo, 2, 2) = FP;
    
    TPR(algo) = TP/(TP + FN);
    FPR(algo) = FP/(FP + TN);
    TNR(algo) = TN/(TN + FP);
    FNR(algo) = FN/(FN + TP);
    
    PPV(algo) = TP/(TP + FP);
    NPV(algo) = TN/(TN + FN);
    FDR(algo) = FP/(FP + TP);
    FOR(algo) = FN/(FN + TN);
    
    PT(algo) = (sqrt(TPR(algo)*(-TNR(algo) +1)) + TNR(algo) - 1)/(TPR(algo) + TNR(algo) -1);
    TS(algo) = TP/(TP + FN + FP);
    
    ACC(algo) = (TP + TN)/(TP + TN + FP + FN);
    BA(algo) = (TPR(algo) + TNR(algo))/2;
    
    results1(algo, 1) = TPR(algo);
    results1(algo, 2) = FPR(algo);
    results1(algo, 3) = TNR(algo);
    results1(algo, 4) = FNR(algo);
    
    results2(algo, 1) = TPR(algo);
    results2(algo, 2) = TNR(algo);
    results2(algo, 3) = FDR(algo);
    results2(algo, 4) = FOR(algo);
    
    results3(algo, 1) = TPR(algo);
    results3(algo, 2) = PPV(algo);
    results3(algo, 3) = 2 * results3(algo, 1) * results3(algo, 2)/(results3(algo, 1) + results3(algo, 2));
end

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
figureDetails = compileFigureDetails(12, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
%C = distinguishable_colors(input.nMethods);
C = linspecer(input.nMethods);

%disp('Generating subplot 1 ...')
input.removeNaNs = 1;

%Prepare the Look Up Table (LUT)
[response, predictor] = getTheTable(sdo_batch, cData, input);

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
algoLabels = {'rR2B-Bo', 'TI-Bo', 'pAUC-Bo', 'pAUC-Ot', 'offPCA-Ot', 'SVM-Ot', 'Param-Bo', 'Param-Ot'};
concordanceAlgoLabels = {'>=1', '>=2', '>=3', '>= 4', '>= 5', '>= 6', '>=7', '=8'};
metricLabels = {'Recall', 'Precision', 'F1 Score'};
methodLabels = {'rR2B', 'TI', 'pAUC', 'offPCA', 'SVM', 'Param.'};
methodLabels2 = {'A', 'B', 'C', 'D', 'E', 'F'};
legends1 = {'TPR', 'FPR', 'TNR', 'FNR'};
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
    end
    
    subplot(16, 2, subplotNum)
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
    
    if method == 1
        %xlim([-0.005, 0.005])
        xlim([-0.005, 0.005])
    elseif method == 2
        xlim([-0.005, 0.005])
    elseif method == 3
        xlim([0, 1])
    elseif method == 4
        xlim([-0.6, 0.6])
    elseif method == 5
        xlim([-0.5, 0.5])
    elseif method == 6
        xlim([0, 1])
    end
%     lgd = legend({'Time Cells'}, ...
%             'Location', 'northwest');
%         lgd.FontSize = figureDetails.fontSize-3;
    if method == 1 || method == 2
        lgd = legend({'Time Cells'}, ...
            'Location', 'northwest');
        lgd.FontSize = figureDetails.fontSize-3;
    end
    set(gca, 'FontSize', figureDetails.fontSize)
    
    subplot(16, 2, subplotNum+4)
    histogram(ocScores, ...
        'BinWidth', binWidth, ...
        'EdgeColor', C(1, :), ...
        'FaceColor', C(1, :))
    ylabel('Counts', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    hold off
    if method == 5 || method == 6
        xlabel('Binned Norm. Scores', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
    end
%     title(sprintf('Method: %s', char(methodLabels(method))), ...
%         'FontSize', figureDetails.fontSize, ...
%         'FontWeight', 'bold')

    if method == 1
        %xlim([-0.005, 0.005])
        xlim([-0.005, 0.005])
    elseif method == 2
        xlim([-0.005, 0.005])
    elseif method == 3
        xlim([0, 1])
    elseif method == 4
        xlim([-0.6, 0.6])
    elseif method == 5
        xlim([-0.5, 0.5])
    elseif method == 6
        xlim([0, 1])
    end
%     lgd = legend({'Other Cells'}, ...
%             'Location', 'northwest');
%         lgd.FontSize = figureDetails.fontSize-3;
    if method == 1 || method == 2
        lgd = legend({'Other Cells'}, ...
            'Location', 'northwest');
        lgd.FontSize = figureDetails.fontSize-3;
    end
    set(gca, 'FontSize', figureDetails.fontSize)
    
end
hold off

subplot(16, 2, [27, 29, 31])

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
subplot(16, 2, [28, 30, 32])
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
title('Confusion Matrices and Performance Evalutation', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%subplot(7, 5, [1:5, 6:10])
for algo = 1:input.nAlgos
    
    if algo == 1
        subplot(12, 8, 1:2)
    elseif algo == 2
        subplot(12, 8, 3:4)
	elseif algo == 3
        subplot(12, 8, 5:6)
	elseif algo == 4
        subplot(12, 8, 7:8)
    elseif algo == 5
        subplot(12, 8, 17:18)
    elseif algo == 6
        subplot(12, 8, 19:20)
    elseif algo == 7
        subplot(12, 8, 21:22)
    elseif algo == 8
        subplot(12, 8, 23:24)
    end
    
    imagesc(squeeze(confusionMatrix(algo, :, :)));
    title(sprintf('%s', char(algoLabels(algo))), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold');
    
    xticks([1, 2])
    xticklabels({'0', '1'})
    yticks([1, 2])
    yticklabels({'1', '0'})
    colorbar
    colormap(linspecer)
    
    if algo == 4 || algo == 8
        set(colorbar,'visible','on')
    else
        set(colorbar, 'visible', 'off')
    end
    
    if algo == 5
        %h.XLabel = 'Prediction';
        xlabel('Prediction', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    end
    if algo == 5
        %h.YLabel = 'Ground Truth';
        ylabel('Ground Truth', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    end
    
    set(gca, 'FontSize', figureDetails.fontSize)
end

subplot(12, 8, (40:48))
d = bar(results3);
xlim([0 5])
axis tight
title('Predictive Performance Metrics', ...
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
lgd = legend({'Recall', 'Precision', 'F1 Score'}, ...
    'Location', 'southwest');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)


allUnique = zeros(input.nAlgos, 3);
allUnique(:, 1) = sum(unique1, 1);
allUnique(:, 2) = sum(unique2, 1);
allUnique(:, 3) = sum(unique3, 1);
subplot(12, 8, (57:72))
bar(allUnique)
xlim([1, 8])
axis tight
title('Uniquely Identified Time Cells', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('All Algorithms', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Counts', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels)
xtickangle(45)
%set(gca,'xtick',[])
lgd = legend({'1/8 Algorithms', '2/8 Algorithms', '3/8 Algorithms'});
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
% usage = [10.07, 1.6, 5.2; ...
%     23.5, 14.2, 45.3; ...
%     23.5, 14.2, 45.4; ...
%     23.5, 14.2, 45.4; ...
%     23.9, 14.2, 45.9; ...
%     23.7, 14.3, 45.6; ...
%     23.6, 14.2, 45.3; ...
%     ];

subplot(12, 8, [81:84, 89:92] )
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
lgd = legend({'135 cells', '540 cells', '1350 cells'}, ...
    'Location', 'southeastoutside');
lgd.FontSize = figureDetails.fontSize-4;
xticklabels(procedureLabels)
xtickangle(45)
set(gca, 'FontSize', figureDetails.fontSize)

subplot(12, 8, [86:88, 94:96])
%boxplot(runTime, procedureLabels)
%errorbar(meanRunTime', stdRunTime', 'r*', 'CapSize', 10)
b2 = bar(meanRunTime);
axis tight
set(gca,'YScale','log')
% hold on
% er = errorbar(meanRunTime', stdRunTime', 'CapSize', 12);
% er.Color = [0 0 0];                            
% er.LineStyle = 'none';
% hold off
%xlim([1, 7])
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
% lgd = legend({'1x = 135 cells', '4x = 540 cells', '10x = 1350 cells'}, ...
%     'Location', 'best');
% lgd.FontSize = figureDetails.fontSize-4;
xticklabels(procedureLabels)
xtickangle(45)
%set(gca,'xtick',[]) legend({'1/8 Algorithms', '2/8 Algorithms', '3/8
%Algorithms'})
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
nSets = 3;

iNoise1 = (298:307); %low
iNoise2 = (308:317); %medium
iNoise3 = (318:327); %high

iEW1 = (328:337); %small
iEW2 = (338:347); %medium
iEW3 = (348:357); %large

iImp1 = (358:367); %low
iImp2 = (368:377); %medium
iImp3 = (378:387); %high

iHTR1 = (388:397); %low
iHTR2 = (398:407); %medium
iHTR3 = (408:417); %high

fig6 = figure(6);
clf
set(fig6, 'Position', [1500, 300, 900, 1200])

[Y1, X1] = developConfusionMatrix4Effects(input, sdo_batch, cData, iNoise1);
[Y2, X2] = developConfusionMatrix4Effects(input, sdo_batch, cData, iNoise2);
[Y3, X3] = developConfusionMatrix4Effects(input, sdo_batch, cData, iNoise3);

nShuffles = 10; %same throughout
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
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
    end
end
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 1))];
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

%set(b1,'FaceAlpha', 0.5)
dependence = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(70-10);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(70-10);
end
dependence_stderr_pos = dependence_stderr_neg;
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
b2 = bar(dependence);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta Noise', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence, dependence_stderr_neg, dependence_stderr_pos, 'CapSize', 12);
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


[Y1, X1] = developConfusionMatrix4Effects(input, sdo_batch, cData, iEW1);
[Y2, X2] = developConfusionMatrix4Effects(input, sdo_batch, cData, iEW2);
[Y3, X3] = developConfusionMatrix4Effects(input, sdo_batch, cData, iEW3);


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
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
    end
end
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 2))];
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(90-30);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(90-30);
end
dependence_stderr_pos = dependence_stderr_neg;
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
b2 = bar(dependence);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta EW', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence, dependence_stderr_neg, dependence_stderr_pos, 'CapSize', 12);
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

[Y1, X1] = developConfusionMatrix4Effects(input, sdo_batch, cData, iImp1);
[Y2, X2] = developConfusionMatrix4Effects(input, sdo_batch, cData, iImp2);
[Y3, X3] = developConfusionMatrix4Effects(input, sdo_batch, cData, iImp3);

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
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
    end
end
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 1))];
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(66-0);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(66-0);
end
dependence_stderr_pos = dependence_stderr_neg;
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
b2 = bar(dependence);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta Imp.', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence, dependence_stderr_neg, dependence_stderr_pos, 'CapSize', 12);
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

[Y1, X1] = developConfusionMatrix4Effects(input, sdo_batch, cData, iHTR1);
[Y2, X2] = developConfusionMatrix4Effects(input, sdo_batch, cData, iHTR2);
[Y3, X3] = developConfusionMatrix4Effects(input, sdo_batch, cData, iHTR3);

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
        [results1, results2, results3] = compareAgainstTruth(Xeffect(myCells, :), Yeffect(myCells), input);
        bundledResults3(shuffle, :, iSet) = results3(:, 3);
    end
end
joinBundledResults3 = [joinBundledResults3; squeeze(bundledResults3(:, :, 2))];
meanBundledResults3 = squeeze(mean(bundledResults3, 1, 'omitnan'));
stdBundledResults3 = squeeze(std(bundledResults3, 1, 'omitnan'));

dependence = (meanBundledResults3(:, 3) - meanBundledResults3(:, 1))/(99-33);
var1 = var(bundledResults3(:, :, 3), 1, 'omitnan');
var2 = var(bundledResults3(:, :, 1), 1, 'omitnan');
sumVar = var1 + var2;
for algo = 1:input.nAlgos
    dependence_stderr_neg(algo, 1) = sqrt(sumVar(1, algo))/sqrt(size(bundledResults3, 1))/(99-33);
end
dependence_stderr_pos = dependence_stderr_neg;
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
b2 = bar(dependence);
b2.FaceColor = C(1, :);
ylabel('\Delta F1 Score/\Delta HTR', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%set(b2,'FaceAlpha', 0.5)
hold on
er = errorbar(x, dependence, dependence_stderr_neg, dependence_stderr_pos, 'CapSize', 12);
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

meanJoinBundledResults3 = squeeze(mean(joinBundledResults3, 1, 'omitnan'));
stderrJoinBundledResults3 = squeeze(std(joinBundledResults3, 1, 'omitnan')/sqrt(size(joinBundledResults3, 1)));

subplot(11, 2, (1:4))
%yyaxis left
b1 = bar(meanJoinBundledResults3);
b1.FaceColor = C(2, :);
hold on
er = errorbar(meanJoinBundledResults3, stderrJoinBundledResults3, 'CapSize', 12);
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
hold off
axis tight
title('Baseline - Physiological Regime', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('F1 Score', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels);
xtickangle(45)
set(gca, 'FontSize', figureDetails.fontSize)

% Concordance
[Y, X] = developConfusionMatrix(input, sdo_batch, cData);
sumX = sum(X, 2);
nCases = length(Y);

% Now, for any cell, if sumX >= some threshold, we suggest calling it a Time Cell
nConcordanceAlgos = 8; % since input.nAlgos = 8

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

results = zeros(nConcordanceAlgos, 3); %3 because we'll look at Recall, Precision, and F1 Score

for algo = 1:nConcordanceAlgos
    
    predictions(:, algo) = sumX >= algo;
    
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
    
    TPR(algo) = TP/(TP + FN);
    FPR(algo) = FP/(FP + TN);
    TNR(algo) = TN/(TN + FP);
    FNR(algo) = FN/(FN + TP);
    PPV(algo) = TP/(TP + FP);
    
    results(algo, 1) = TPR(algo); %Recall
    results(algo, 2) = PPV(algo); %Precision
    results(algo, 3) = 2 * results(algo, 1) * results(algo, 2)/(results(algo, 1) + results(algo, 2)); %F1 Score
end

legendLabels = {'Recall', 'Precision', 'F1 Score'};

subplot(11, 2, [19:22])
d = bar(results);
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
lgd = legend(legendLabels, ...
    'Location', 'southwest');
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

elapsedTime2 = toc;
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime2)
disp('... All Done!')