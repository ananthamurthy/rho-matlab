% Comparative analysis on Synthetic Data
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

plotRefQ = 1;
plotAnalysedQs = 1;
plotDatasetCheck = 0;

input.nCells = 135;
input.nAlgos = 8;
input.nExperiments = 12;
input.nShuffles = 8;

%%1
% Load Synthetic Data
% gDate = 20210628; %generation date
% gRun = 1; %generation run number
% nDatasets = 80;
input.gDate = 20210714; %generation date
input.gRun = 1; %generation run number
input.nDatasets = 96;
%synthDataFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/synthDATA_%i_gRun%i_batch_%i.mat', input.gDate, input.gRun, input.nDatasets);
%load(synthDataFilePath)

% Load Analysis Results
% cDate = 20210629; %consolidation date
% cRun = 1; %consolidation run number
input.cDate = 20210714; %consolidation date
input.cRun = 1; %consolidation run number
%analysisFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/M26_20180514_synthDataAnalysis_%i_cRun%i_cData.mat', input.cDate, input.cRun);
%load(analysisFilePath)

input.removeNaNs = 1;
[Y, X] = developConfusionMatrix(input);

%% TP, FN, FP, TN
for experiment = 1:input.nExperiments
%for experiment = 10:10
    if experiment <= 3
        parameter = 'Noise';
        if experiment == 1
            situation = '0%';
        elseif experiment == 2
            situation = '15%';
        elseif experiment == 3
            situation = '30%';
        end
    elseif experiment > 3 && experiment <=6
        parameter = 'Event Width';
        if experiment == 4
            situation = '30th percentile';
        elseif experiment == 5
            situation = '50th percentile';
        elseif experiment == 6
            situation = '70th percentile';
        end
    elseif experiment > 6 && experiment <=9
        parameter = 'Imprecision';
        if experiment == 7
            situation = '2 frame';
        elseif experiment == 8
            situation = '5 frame';
        elseif experiment == 9
            situation = '7 frame';
        end
    elseif experiment > 9 && experiment <=12
        parameter = 'Hit Trial Ratio';
        if experiment == 10
            situation = '16.5-33%';
        elseif experiment == 11
            situation = '33-66%';
        elseif experiment == 12
            situation = '50-100%';
        end
    end

    fprintf('Experiment %i\n', experiment)
    starti = ((experiment-1)*input.nShuffles*input.nCells) + 1;
    endi = (experiment*input.nShuffles*input.nCells);
    fprintf('---> %i to %i\n', starti, endi)
    Y_split = Y(starti:endi, 1);
    nCases = length(Y_split);
    fprintf('------>> nCases = %i\n', nCases)
    X_split = X(starti:endi, :);
    
    %Preallocation
    splitTP = zeros(nCases, input.nAlgos);
    splitTN = zeros(nCases, input.nAlgos);
    splitFP = zeros(nCases, input.nAlgos);
    splitFN = zeros(nCases, input.nAlgos);
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
    
    for algo = 1:input.nAlgos
        for myCase = 1:nCases
            if Y_split(myCase) %Positive Cases
                if X_split(myCase, algo)
                    splitTP(myCase, algo) = 1;
                else
                    splitFN(myCase, algo) = 1;
                end
            else %Negative Casees
                if X_split(myCase, algo)
                    splitFP(myCase, algo) = 1;
                else
                    splitTN(myCase, algo) = 1;
                end
            end
        end
        
        TP = sum(splitTP(:, algo));
        FN = sum(splitFN(:, algo));
        FP = sum(splitFP(:, algo));
        TN = sum(splitTN(:, algo));
        
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
    end
    
    %% Plot
    figureDetails = compileFigureDetails(16, 2, 5, 0.5, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
    %Extra colormap options: inferno/plasma/viridis/magma
    C = distinguishable_colors(input.nAlgos);
    
    fig1 = figure(1);
    clf
    set(fig1, 'Position', [300, 300, 800, 800])
    %subplot(2, 1, 1)
    b = bar(results1);
    xlim([0, 2])
    %xticks(0:0.3:2)
    axis tight
    % title(sprintf('Results (N=%i)', input.nDatasets), ...
    %     'FontSize', figureDetails.fontSize, ...
    %     'FontWeight', 'bold')
    title(sprintf('Effect of %s %s (N=%i)', situation, parameter, input.nShuffles), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    % xlabel('Algorithm', ...
    %     'FontSize', figureDetails.fontSize, ...
    %     'FontWeight', 'bold')
    ylabel('Rate', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xticklabels({'A-Boot', 'B-Boot', 'C-Boot', 'C-Otsu', 'D-Otsu', 'E-Otsu', 'F-Boot', 'F-Otsu'})
    xtickangle(45)
    lgd = legend({'TPR', 'FPR', 'TNR', 'FNR'}, ...
        'Location', 'best');
    lgd.FontSize = figureDetails.fontSize-3;
    set(gca, 'FontSize', figureDetails.fontSize)
    
    %special case; replace "." with "p" to avoid file format issue
    if experiment == 10
        situation = replace(situation, '.', 'p');
    end
    print(sprintf('/Users/ananth/Desktop/Effect-%s%s_exp%i', ...
        strip(situation, ' '), strip(parameter, ' '), ...
        experiment), ...
        '-djpeg')
end