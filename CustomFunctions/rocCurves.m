%% ROC Curves for all methods
close all
clear

tic

input.plotOptimalPoint = 0;

input.nCells = 135;
input.nMethods = 7;

% Synthetic Dataset Details
input.gDate = 20210824; %generation date
input.gRun = 1; %generation run number
input.nDatasets = 333;

% Consolidated Analysis Details
input.cDate = 20210918; %consolidation date
input.cRun = 1; %consolidation run number

workingOnServer = 0;
diaryOn         = 0;

%% Directory config
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
        diary (strcat(HOME_DIR, '/logs/dataGenDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/dataGenDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

%% Load Synthetic Data
disp('Loading synthetic datasets ...')
% gDate = 20210628; %generation date
% gRun = 1; %generation run number
% nDatasets = 80;
synthDataFilePath = sprintf('%s/synthDATA_%i_gRun%i_batch_%i.mat', ...
    saveFolder, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets);
load(synthDataFilePath)
disp('... done!')

%% Load Analysis Results
disp('Loading analysis results ...')
analysisFilePath = sprintf('%s/synthDATA_Analysis_%i_cRun%i_cData.mat', ...
    saveFolder, ...
    input.cDate, ...
    input.cRun);
load(analysisFilePath)
disp('... done!')

%% ROC
figureDetails = compileFigureDetails(16, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
C = distinguishable_colors(input.nMethods);

fig1 = figure(1);
clf
set(set(fig1,'Position',[0, 200, 500, 500]))

%disp('Generating subplot 1 ...')
input.removeNaNs = 0;

%Prepare the Look Up Table (LUT)
[response, predictor] = getTheTable(sdo_batch, cData, input);

for method = 1:1 %input.nMethods %Skips Ref Q and F
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
    
    if isnan(Xlog)
    elseif isnan(Ylog)
        warning('Probably skipping ...')
    end
    
    if input.plotOptimalPoint
        try
            plot(optOP(1), optOP(2), 'Color', C(method, :)', 'o')
        catch
            warning('Unable to plot optimal oprational point')
        end
    end
    
    %Plots
    plot(Xlog, Ylog, '-', ...
        'Color', C(method, :), ...
        'LineWidth', figureDetails.lineWidth)
    %Add Marker Indices- to do
    title(sprintf('ROC Curves Without NaNs (N=%i)', input.nDatasets), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold') 
    lgd1 = legend({'A (R2B)', 'B (TI)', 'C (Mean/Std)', 'D (PCA)', 'E (SVM)', 'F (Der)'}, ...
        'Location', 'best');
    lgd1.FontSize = figureDetails.fontSize;
    hold on
end
title(sprintf('ROC Curves (N=%i)', input.nDatasets), ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xlabel('False Positive Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel('True Positive Rate', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
set(gca, 'FontSize', figureDetails.fontSize)

print(sprintf('%s/figs/ROC-%i-%i-%i-%i-%i', ...
    HOME_DIR2, ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    input.cDate, ...
    input.cRun), ...
    '-dpng')