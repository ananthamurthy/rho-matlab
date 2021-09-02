%% ROC Curves for all methods
close all
clear

tic
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))

make_db

workingOnServer = 0;

if workingOnServer
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    ANALYSIS_DIR = strcat(HOME_DIR, 'Work/Analysis');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    ANALYSIS_DIR = strcat(HOME_DIR2, 'Work/Analysis');
end

%Automate for reading HOME_DIR and HOME_DIR2
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))

input.plotOptimalPoint = 0;

input.nCells = 135;
input.nMethods = 7;

%% Load Synthetic Data
disp('Loading synthetic datasets ...')
input.gDate = 20210629; %generation date
input.gRun = 1; %generation run number
input.nDatasets = 333;
synthDataFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/synthDATA_%i_gRun%i_batch_%i.mat', ...
    input.gDate, input.gRun, input.nDatasets);
load(synthDataFilePath)
disp('... done!')

%% Load Analysis Results
disp('Loading analysis results ...')
input.cDate = 20210701; %consolidation date
input.cRun = 1; %consolidation run number
analysisFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/M26_20180514_synthDataAnalysis_%i_cRun%i_cData.mat', ...
    input.cDate, input.cRun);
load(analysisFilePath)
disp('... done!')

%% ROC
figureDetails = compileFigureDetails(16, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
C = distinguishable_colors(input.nMethods);

fig1 = figure(1);
clf
set(set(fig1,'Position',[0, 200, 800, 400]))

subplot(1, 2, 1)
%disp('Generating subplot 1 ...')
input.removeNaNs = 0;

%Prepare the Look Up Table (LUT)
[response, predictor] = getTheTable(sdo_batch, cData, input);

for method = 2:input.nMethods-1 %Skips Ref Q and F
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
    lgd1 = legend({'A (R2B)', 'B (TI)', 'C (Mean/Std)', 'D (PCA)', 'E (SVM)'}, ...
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

subplot(1, 2, 2)
%disp('Generating subplot 2 ...')
input.removeNaNs = 1;

%Prepare the Look Up Table (LUT)
[response, predictor] = getTheTable(sdo_batch, cData, input);

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
    %Add Marker Indices
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
lgd2 = legend({'RefQ', 'A (R2B)', 'B (TI)', 'C (Mean/Std)', 'D (PCA)', 'E (SVM)', 'F (Derived)'}, ...
        'Location', 'best');
lgd2.FontSize = figureDetails.fontSize;
set(gca, 'FontSize', figureDetails.fontSize)
hold off
print(sprintf('/Users/ananth/Desktop/ROC-%i-%i-%i-%i-%i', ...
    input.gDate, ...
    input.gRun, ...
    input.nDatasets, ...
    input.cDate, ...
    input.cRun), ...
    '-dpng')