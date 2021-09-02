close all

gDate = 20201107; %generation date
gRun = 1; %generation run number
nDatasets = 208;

addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions'))

analysedDataFilePath = strcat('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/', ...
    'M26_20180514_synthDataAnalysis_20201106_gRun1_methodF_batch_1-208.mat');
load(analysedDataFilePath)

dIndices = 95:1:104;
normalize = 1;
nParams = 10;
nMethods = 2;
ptcList = 1:67;
ocList = 68:135;

labels.xtickscell = {'10', '20', '30', '40', '50', '60', '70', '80', '90', '100'};
labels.titleMain = 'Sequential Activity';
labels.titlePTC = 'Putative Time Cells';
labels.titleOC = 'Other Time Cells';
labels.xtitle = 'Gaussian Noise (%)';
labels.ytitle = 'Normalized Quality';
figureDetails = compileFigureDetails(16, 2, 10, 0.5, 'jet'); %(fontSize, lineWidth, markerSize, transparency, colorMap)

for param = 1:nParams
    for method = 1:nMethods
        if method == 1
            yPTC(param, method, :) = mFOutput_batch(dIndices(param)).Q1(ptcList);
            yOC(param, method, :) = mFOutput_batch(dIndices(param)).Q1(ocList);
        elseif method == 2
            yPTC(param, method, :) = mFOutput_batch(dIndices(param)).Q2(ptcList);
            yOC(param, method, :) = mFOutput_batch(dIndices(param)).Q2(ocList);
        end
        %Medians
        yPTC_median(param, method) = nanmedian(yPTC(param, method, :));
        yOC_median(param, method) = nanmedian(yOC(param, method, :));
        
        %Std Devs
        yPTC_stddev(param, method) = nanstd(squeeze(yPTC(param, method, :)));
        yOC_stddev(param, method) = nanstd(squeeze(yOC(param, method, :)));
    end
end

if normalize
    for method = 1:nMethods
        normValPTC = nanmax(nanmax(squeeze(yPTC(:, method, :))));
        yPTC_norm(:, method, :) = yPTC(:, method, :)/normValPTC;
        
        normValOC = nanmax(nanmax(squeeze(yOC(:, method, :))));
        yOC_norm(:, method, :) = yOC(:, method, :)/normValOC;
    end
    
    for param = 1:nParams
        for method = 1:nMethods
            yPTC_norm_median(param, method) = nanmedian(squeeze(yPTC_norm(param, method, :)));
            yOC_norm_median(param, method) = nanmedian(squeeze(yOC_norm(param, method, :)));
            
            yPTC_norm_stddev(param, method) = nanstd(squeeze(yPTC_norm(param, method, :)));
            yOC_norm_stddev(param, method) = nanstd(squeeze(yOC_norm(param, method, :)));
        end
    end
    
    %For Putative Time Cells
    fig1 = figure(1);
    set(fig1,'Position',[300, 300, 500, 500])
    %subplot(1, 2, 1)
    for method = 1:nMethods
        if method == 1
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'blue', 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'green', 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
    end
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    title(completeTitle)
    xlabel(labels.xtitle)
    ylabel(labels.ytitle)
    legend('DerQ1', 'DerQ2')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/norm_linePlots_DerQvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
end

%mainDatasetCheck3(dIndices, sdo_batch, figureDetails)
