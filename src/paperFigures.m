% Paper Figures
% AUTHOR: Kambadur Ananthamurthy
% DETAILS: 333 uniquely tagged synthetic datasets were analysed on the basis
% of a variety of numerical procedures. Cells in each dataset were given
% analog scores on the same basis.
% Load the Consolidated Analysis Details and look for patterns in the plots.

close all
clear

tic

input.nCells = 135;
input.nAlgos = 8;
input.nMethods = 6;

workingOnServer = 1;

if workingOnServer == 1 %Bebinca
    % Synthetic Dataset Details
    input.gDate = 20210824; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 333;
    
    % Consolidated Analysis Details
    input.cDate = 20210918; %consolidation date
    input.cRun = 1; %consolidation run number
    
elseif workingOnServer == 2 %Adama
    % Synthetic Dataset Details
    input.gDate = 20210903; %generation date
    input.gRun = 1; %generation run number
    input.nDatasets = 333;
    
    % Consolidated Analysis Details
    input.cDate = 20210911; %consolidation date
    input.cRun = 1; %consolidation run number
end

workingOnServer = 0;
diaryOn         = 0;


% Directory config

if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
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

% Synthetic Dataset Details
input.gDate = 20210824; %generation date
input.gRun = 1; %generation run number
input.nDatasets = 333;

% Consolidated Analysis Details
input.cDate = 20210918; %consolidation date
input.cRun = 1; %consolidation run number

workingOnServer = 0;
diaryOn         = 0;

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

input.plotOptimalPoint = 0;
figureDetails = compileFigureDetails(16, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
C = distinguishable_colors(input.nMethods);

%disp('Generating subplot 1 ...')
input.removeNaNs = 0;

%Prepare the Look Up Table (LUT)
[response, predictor] = getTheTable(sdo_batch, cData, input);

%Normalize
maxima = max(predictor);
normPredictor = predictor./maxima;

%Z-Score
zPredictor = zscore(predictor);

% Normalize Z-Score
maxima = max(zPredictor);
nzPredictor = zPredictor./maxima;

% Ruggero G. Bettinardi (2021). getCosineSimilarity(x,y)
% (https://www.mathworks.com/matlabcentral/fileexchange/62978-getcosinesimilarity-x-y),
% MATLAB Central File Exchange. Retrieved October 5, 2021.

% When data points are sparse in the sense that some scores are undefined/missing,
% it is often better to use cosine similiarity between the pairwise scores across all method pairs.

cosineSimilarityMatrix1 = nan(input.nMethods, input.nMethods);
cosineSimilarityMatrix2 = nan(input.nMethods, input.nMethods);
Z = normPredictor;
for method1 = 1:input.nMethods
    x = Z(:, method1);
    for method2 = 1:input.nMethods
        if method1 ~= method2
            y = Z(:, method2);
            cosineSimilarityMatrix1(method1, method2) = getCosineSimilarity(x, y);
        end
    end
end

%correlationMatrix = corrcoef(normPredictor);
correlationMatrix = corrcoef(predictor);

%Labels
algoLabels = {'A-Boot', 'B-Boot', 'C-Boot', 'C-Otsu', 'D-Otsu', 'E-Otsu', 'F-Boot', 'F-Otsu'};
metricLabels = {'Recall', 'Precision', 'F1 Score'};
methodLabels = {'R2B', 'TI', 'Peak AUC/Std', 'PCA', 'SVM', 'Param. Eqs.'};
methodLabels2 = {'A', 'B', 'C', 'D', 'E', 'F'};
legends1 = {'TPR', 'FPR', 'TNR', 'FNR'};

%% Plots - I

disp('Plotting ...')

fig1 = figure(1);
clf
set(fig1, 'Position', [300, 300, 800, 1200])
subplot(9, 2, [1:2, 3:4])
b = bar(results1);
xlim([0, 2])
axis tight
% title(sprintf('Performance Evaluation (N=%i)', input.nDatasets), ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
title('All Algorithms Perform Well ', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%xticklabels(algoLabels)
%xtickangle(45)
set(gca,'xtick',[])
lgd = legend(legends1, ...
    'Location', 'best');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

subplot(9, 2, [5:6, 7:8])
d = bar(results3);
xlim([0 5])
axis tight
% xlabel('Algorithm', ...
% 'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
ylabel('Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xticklabels(algoLabels)
xtickangle(45)
lgd = legend({'Recall', 'Precision', 'F1 Score'}, ...
    'Location', 'best');
lgd.FontSize = figureDetails.fontSize-3;
set(gca, 'FontSize', figureDetails.fontSize)

subplot(9, 2, [11, 13, 15, 17])
for method1 = 1:input.nMethods
    %disp(method)
    %Linear Regression
    clear Mdl
    Mdl = fitglm(predictor(:, method1), response, ...
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
    plot(Xlog, Ylog, '-', ...
        'Color', C(method1, :), ...
        'LineWidth', figureDetails.lineWidth)
    hold on
    
    if input.plotOptimalPoint
        try
            plot(optOP(1), optOP(2), 'Color', C(method1, :)', 'o')
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
lgd1 = legend(methodLabels2, ...
    'Location', 'best');
lgd1.FontSize = figureDetails.fontSize;

set(gca, 'FontSize', figureDetails.fontSize)

subplot(9, 2, [12, 14])
boxplot(zPredictor(response==1, :))
% title(sprintf('Normalized Scores for Time Cells (N=%i)', input.nDatasets), ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
title('Z Scores - Time Cells', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
%xticklabels = methodLabels;
%xtickangle(45);
xticklabels({'', '', '', '', '', ''})
set(gca,'xtick',[])
set(gca, 'FontSize', figureDetails.fontSize)

subplot(9, 2, [16, 18])
boxplot(zPredictor(response==0, :))
title('Z Scores - Other Cells', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
% xlabel('Method', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
xticklabels(methodLabels2)
%xtickangle(45)
ylim([-1, 1])
set(gca, 'FontSize', figureDetails.fontSize)

print(sprintf('%s/PerformanceEvaluation-%i-%i-%i_%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    workingOnServer), ...
    '-djpeg')


%% Plots - II
fig2 = figure(2);
clf
set(fig2, 'Position', [300, 300, 800, 400])
title(sprintf('Comparative Analysis (N=%i)', input.nDatasets), ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')

%plotmatrixcorr(normPredictor, methodLabels)
%subplot(3, 9, 1:18)
%plotmatrix(normPredictor, methodLabels2)
%h = plotmatrix(normPredictor, methodLabels2);
%title(sprintf('Non-causality across methods (N=%i)', input.nDatasets))
%title('Non-Causality Across Methods')

%subplot(3, 9, 20:22)
subplot(1, 2, 1)
h = heatmap(cosineSimilarityMatrix1, ...
    'Colormap', cool, ...
    'Title', 'Cosine Similarity');
h.XDisplayLabels = methodLabels;
h.YDisplayLabels = methodLabels;
set(gca, 'FontSize', figureDetails.fontSize)

%subplot(3, 9, 24:26)
subplot(1, 2, 2)
h = heatmap(correlationMatrix, ...
    'Colormap', cool, ...
    'Title', 'Correlation Matrix');
h.XDisplayLabels = methodLabels;
%h.YDisplayLabels = methodLabels2;
h.YDisplayLabels = {'', '', '', '', '', ''};
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

%% Plots III
fig3 = figure(3);
clf
set(fig3, 'Position', [300, 300, 800, 800])
% title('All Scores', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
%methodLabelsStrings = ['R2B', 'TI', 'Peak AUC/Std', 'PCA', 'SVM', 'Param. Eqs.'];
for method = 1:input.nMethods
    subplot(3, 2, method)
    ptcScores = predictor(response == 1, method);
    ocScores = predictor(response == 0, method);
    %title(sprintf('Scores - Method %s', char(methodLabels(method))))
%     histogram(ptcScores, ...
%         'EdgeColor', 'g', ...
%         'EdgeAlpha', 0.5)
%     hold on
%     histogram(ocScores, ...
%         'EdgeColor', 'r', ...
%         'EdgeAlpha', 0.5)
%     hold off
    histogram(ptcScores, ...
        'EdgeAlpha', 0.5)
    hold on
    histogram(ocScores, ...
        'EdgeAlpha', 0.5)
    hold off
    title(sprintf('Method - %s', char(methodLabels(method))), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Binned Scores', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Frequency', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    lgd = legend({'Time Cells', 'Other Cells'}, ...
        'Location', 'best');
    lgd.FontSize = figureDetails.fontSize-3;
    
    minPTCScores = min(ptcScores);
    minOCScores = min(ocScores);
    maxPTCScores = max(ptcScores);
    maxOCScores = max(ocScores);
    
    minimum = min(minPTCScores, minOCScores);
    maximum = max(maxPTCScores, maxOCScores);
    
    xlim([minimum maximum])
    %ylim([0 25000])
    ylim([0 5000])
    set(gca, 'FontSize', figureDetails.fontSize)
end
hold off
print(sprintf('%s/HistogramsAllScores-%i-%i-%i-%i-%i_%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    input.cDate, ...
    input.cRun, ...
    workingOnServer), ...
    '-dpng')

disp('... done!')