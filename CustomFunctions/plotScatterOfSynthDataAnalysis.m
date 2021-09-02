mouseName = 'M26';
recordingDate = 20180514; %imaging session
cDate = 20210324; %consolidation date
cRun = 1; %consolidation run number
workingOnServer = 0;

if workingOnServer
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    ANALYSIS_DIR = strcat(HOME_DIR, 'Work/Analysis');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    ANALYSIS_DIR = strcat(HOME_DIR2, 'Work/Analysis');
end

plotRefQ = 1;
plotAnalysedQs = 1;
plotDatasetCheck = 0;

addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions'))

%Load Analysis Results
if plotRefQ
    gDate = 20210324; %generation date
    gRun = 1; %generation run number
    nDatasets = 208;
    synthDataFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/synthDATA_%i_gRun%i_batch_%i.mat', gDate, gRun, nDatasets);
    load(synthDataFilePath)
end

%% Load Analysed Data
if plotAnalysedQs
    cDate = 20210514; %consolidation date
    cRun = 1; %consolidation run number
    analysisFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/M26_20180514_synthDataAnalysis_%i_cRun%i_cData.mat', cDate, cRun);
    load(analysisFilePath)
else
    cData = [];
end

%For single session
dnum = 96;
dfbf_2D = sdo_batch(dnum).syntheticDATA_2D;

normalizeScatterPlots = 0;  %for scatter plots
normalizeDataVisual = 1; % 0: global normalization; 1: cell-wise normalization

if normalizeDataVisual
    norm_dfbf_2D = zeros(size(dfbf_2D));
    for cell = 1:size(dfbf_2D)
        cellMax = max(dfbf_2D(cell, :));
        norm_dfbf_2D(cell, :) = dfbf_2D(cell, :)/cellMax;
    end
end

figureDetails = compileFigureDetails(20, 2, 10, 0.5, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magma
nFrames = 246;
nTrials = 5;
fig1 = figure(1);
set(fig1,'Position',[0,200,1000,500])
if normalizeDataVisual
    imagesc(norm_dfbf_2D(:, 1:nTrials*nFrames)*100);
else
    imagesc(dfbf_2D(:, 1:nTrials*nFrames)*100);
end
colormap(figureDetails.colorMap)
title(sprintf('%i - First 5 Trials', recordingDate), ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
xlabel('Frame Numbers', ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
ylabel('All Cells', ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
z = colorbar;
if normalizeDataVisual
    ylabel(z,'Cell-wise Normalized dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
else
    ylabel(z,'Normalized dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
end
set(gca,'FontSize', figureDetails.fontSize-3)
print(['/Users/ananth/Desktop/' ...
    'realData_' ...
    mouseName '_' num2str(recordingDate)], ...
    '-djpeg')

fig2 = figure(2);
set(fig2,'Position',[1000,200,1000,500])

C = distinguishable_colors(6);
if normalizeScatterPlots == 1
    %day1
    for count = 1:6
        subplot(2, 3, count)
        x = cData.methodF.mFOutput_batch(1).normQ1;
        if count == 1
            y = cData.methodA.mAOutput_batch(1).normQ;
            %scatter(x, y, 'b');
            %scatter(x, y, 'color', C(count, :));
            ylabel('Method A - DayA', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 2
            y = cData.methodB.mBOutput_batch(1).normQ;
            %scatter(x, y, 'g');
            scatter(x, y, 'color', C(count, :));
            ylabel('Method B - DayA', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 3
            y = cData.methodC.mCOutput_batch(1).normQ1;
            %scatter(x, y, 'r');
            scatter(x, y, 'color', C(count, :));
            ylabel('Method C1 - DayA', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 4
            y = cData.methodC.mCOutput_batch(1).normQ2;
            %scatter(x, y, 'm');
            scatter(x, y, 'color', C(count, :));
            ylabel('Method C2 - DayA', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 5
            y = cData.methodD.mDOutput_batch(1).normQ;
            %scatter(x, y, 'y');
            scatter(x, y, 'color', C(count, :));
            ylabel('Method D - DayA', ...
                'FontSize', figureDetails.fontSize, ...`
                'FontWeight', 'bold')
        elseif count == 6
            y = cData.methodF.mFOutput_batch(1).normQ2;
            %scatter(x, y, 'k');
            scatter(x, y, 'color', C(count, :));
            ylabel('Method F1-DayA', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        else
        end
        xlabel('Method F2 - DayA', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
        set(gca,'FontSize', figureDetails.fontSize-3)
    end
    clear x
    clear y
    
    %day2
    for count = 1:6
        subplot(3, 6, 6+count)
        x = cData(2).methodF.mFOutput_batch(2).normQ1;
        if count == 1
            y = cData(2).methodA.mAOutput_batch(2).normQ;
            scatter(x, y, 'b');
            ylabel('Method A - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 2
            y = cData(2).methodB.mBOutput_batch(2).normQ;
            scatter(x, y, 'g');
            ylabel('Method B - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 3
            y = cData(2).methodC.mCOutput_batch(2).normQ1;
            scatter(x, y, 'r');
            ylabel('Method C1 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 4
            y = cData(2).methodC.mCOutput_batch(2).normQ2;
            scatter(x, y, 'm');
            ylabel('Method C2 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 5
            y = cData(2).methodD.mDOutput_batch(2).normQ;
            scatter(x, y, 'y');
            ylabel('Method D - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 6
            y = cData(2).methodF.mFOutput_batch(2).normQ2;
            scatter(x, y, 'k');
            ylabel('Method F2 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        else
        end
        xlabel('Method F1 - DayB', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
        set(gca,'FontSize', figureDetails.fontSize-3)
    end
    clear x
    clear y
    
    %day1 vs day2
    for count = 1:6
        subplot(3, 6, 12+count)
        x = cData.methodF.mFOutput_batch(1).normQ1;
        if count == 1
            y = cData(2).methodA.mAOutput_batch(2).normQ;
            scatter(x, y, 'b');
            ylabel('Method A - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 2
            y = cData(2).methodB.mBOutput_batch(2).normQ;
            scatter(x, y, 'g');
            ylabel('Method B - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 3
            y = cData(2).methodC.mCOutput_batch(2).normQ1;
            scatter(x, y, 'r');
            ylabel('Method C1 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 4
            y = cData(2).methodC.mCOutput_batch(2).normQ2;
            scatter(x, y, 'm');
            ylabel('Method C2 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 5
            y = cData(2).methodD.mDOutput_batch(2).normQ;
            scatter(x, y, 'y');
            ylabel('Method D - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 6
            y = cData(2).methodF.mFOutput_batch(2).normQ2;
            scatter(x, y, 'k');
            ylabel('Method F2 - DayB', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        else
        end
        xlabel('Method F1 - DayA', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
        set(gca,'FontSize', figureDetails.fontSize-3)
    end
    clear x
    clear y
else
    %day1
    for count = 1:6
        subplot(2, 3, count)
        x = cData.methodF.mFOutput_batch(dnum).Q2;
        if count == 1
            y = cData.methodA.mAOutput_batch(dnum).Q;
            scatter(x, y, 'b');
            ylabel('Method A', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 2
            y = cData.methodB.mBOutput_batch(dnum).Q;
            scatter(x, y, 'g');
            ylabel('Method B', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 3
            y = cData.methodC.mCOutput_batch(dnum).Q1;
            scatter(x, y, 'r');
            ylabel('Method C1', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 4
            y = cData.methodC.mCOutput_batch(dnum).Q2;
            scatter(x, y, 'm');
            ylabel('Method C2', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 5
            y = cData.methodD.mDOutput_batch(dnum).Q;
            %scatter(x, y, 'y*');
            scatter(x, y, 'c');
            ylabel('Method D', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        elseif count == 6
            y = cData.methodF.mFOutput_batch(dnum).Q2;
            scatter(x, y, 'k');
            ylabel('Method F1', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        else
        end
        xlabel('Method F2', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
        set(gca,'FontSize', figureDetails.fontSize-3)
    end
    clear x
    clear y
    
 
end
print(['/Users/ananth/Desktop/' ...
    'scatter_scores_synthData_' ...
    mouseName '_' num2str(recordingDate)], ...
    '-djpeg')
