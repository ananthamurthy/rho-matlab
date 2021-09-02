% AUTHOR - Kambadur Ananthmurthy
% Analyze identified cells across multiple days
%clear all
clear
close all

addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth')) % Suite2P related functions
addpath(genpath('/Users/ananth/Desktop/Work/Analysis/Imaging')) % analysis output

figureDetails = compileFigureDetails(20, 2, 10, 0.5, 'hot'); %(fontSize, lineWidth, markerSize, transparency, colorMap)

ops0.fig                = 1;
ops0.method             = 'C';
ops0.acrossSessionTypes = 0;
% mouseName = 'M11';
% nFrames = 203;
% trialDuration = 17; %in sec
% dateA = '20170711';
% sessionA = 4;
% sessionTypeA = 9;
% 
% dateB = '20170712';
% sessionB = 1;
% sessionTypeB = 11;

mouseName = 'M26';
nFrames = 246;
trialDuration = 17; %in sec
dateA = '20180508';
sessionA = 1;
sessionTypeA = 5;

dateB = '20180509';
sessionB = 2;
sessionTypeB = 5;

% dateB = '20180514';
% sessionB = 4;
% sessionTypeB = 5;

[datasetA, datasetB] = compileChronicData(mouseName, dateA, dateB, ...
    sessionA, sessionB, sessionTypeA, sessionTypeB, nFrames, trialDuration);
[datasetA, datasetB] = loadChronicData(datasetA, datasetB); %NOTE: requires _reg.mat file

%% Check for tuning - independent analysis of datasetA and datasetB
skipFrames = 116;
delta = 3;
x = (datasetA.trialDetails.preDuration * datasetA.trialDetails.frameRate); %throw away
datasetA.csBin = ceil(x/delta);
clear x
x = ((datasetA.trialDetails.preDuration + datasetA.trialDetails.csDuration + datasetA.trialDetails.traceDuration) * datasetA.trialDetails.frameRate);
datasetA.usBin = ceil(x/delta);
clear x
x = (datasetB.trialDetails.preDuration * datasetB.trialDetails.frameRate); %throw away
datasetB.csBin = ceil(x/delta);
clear x
x = ((datasetB.trialDetails.preDuration + datasetB.trialDetails.csDuration + datasetB.trialDetails.traceDuration) * datasetB.trialDetails.frameRate);
datasetB.usBin = ceil(x/delta);
clear x

%1
disp('Checking for tuning on datasetA ...')
disp('First filtering for percentage of trials with activity, then PSTH ...')
threshold = 0.25 * (size(datasetA.data,2)); %threshold is 25% of the session trials
[datasetA.cellRastor, datasetA.cellFrequency, datasetA.timeLockedCells_temp, datasetA.importantTrials] = ...
    getFreqBasedTimeCellList(datasetA.data_sigOnly, threshold, skipFrames);
%Develop PSTH only for cells passing >25% activity
[datasetA.PSTH, datasetA.PSTH_3D] = getPSTH(datasetA.data_sigOnly(find(datasetA.timeLockedCells_temp),:,:), delta, skipFrames);
%Finally, identifying true time-locked cells, using the TI metric
[datasetA.timeLockedCells, datasetA.TI] = getTimeLockedCells(datasetA.PSTH_3D, 1000, 99);

datasetA.data_timeLockedCells = datasetA.data(find(datasetA.timeLockedCells),:,:);
disp('... done!')

% Sorting
if isempty(find(datasetA.timeLockedCells,1))
    %disp('No time cells found')
else
    %Sort PSTHs only for the final list of time-locked cells
    [datasetA.sortedPSTHindices, datasetA.peakIndicies] = sortPSTH(datasetA.PSTH(find(datasetA.timeLockedCells),:));
    datasetA.PSTH_timeLockedCells = datasetA.PSTH(find(datasetA.timeLockedCells),:);
    datasetA.PSTH_sorted = datasetA.PSTH_timeLockedCells(datasetA.sortedPSTHindices,:);
    datasetA.data_sorted_timeCells = datasetA.data_timeLockedCells(datasetA.sortedPSTHindices,:,:);
end

%2
disp('Checking for tuning on datasetB ...')
disp('First filtering for percentage of trials with activity, then PSTH ...')
threshold = 0.25 * (size(datasetB.data,2)); %threshold is 25% of the session trials
[datasetB.cellRastor, datasetB.cellFrequency, datasetB.timeLockedCells_temp, datasetB.importantTrials] = ...
    getFreqBasedTimeCellList(datasetB.data_sigOnly, threshold, skipFrames);
%Develop PSTH only for cells passing >25% activity
[datasetB.PSTH, datasetB.PSTH_3D] = getPSTH(datasetB.data_sigOnly(find(datasetB.timeLockedCells_temp),:,:), delta, skipFrames);
%Finally, identifying true time-locked cells, using the TI metric
[datasetB.timeLockedCells, datasetB.TI] = getTimeLockedCells(datasetB.PSTH_3D, 1000, 99);

datasetB.data_timeLockedCells = datasetB.data(find(datasetB.timeLockedCells),:,:);
disp('... done!')

% Sorting
if isempty(find(datasetB.timeLockedCells,1))
    %disp('No time cells found')
else
    %Sort PSTHs only for the final list of time-locked cells
    [datasetB.sortedPSTHindices, datasetB.peakIndicies] = sortPSTH(datasetB.PSTH(find(datasetB.timeLockedCells),:));
    datasetB.PSTH_timeLockedCells = datasetB.PSTH(find(datasetB.timeLockedCells),:);
    datasetB.PSTH_sorted = datasetB.PSTH_timeLockedCells(datasetB.sortedPSTHindices,:);
    datasetB.data_sorted_timeCells = datasetB.data_timeLockedCells(datasetB.sortedPSTHindices,:,:);
end

%% Development/Loss of Tuning between datasetA and datasetB (independently analyzed)
%Assuming method 'C' ...
if size(datasetA.PSTH,1) > size(datasetB.PSTH,1)
    nCells_lostTuning = size(datasetA.PSTH,1) - size(datasetB.PSTH,1);
    fprintf('[INFO] There are %i cells that have lost tuning\n', nCells_lostTuning)
elseif size(datasetA.PSTH,1) < size(datasetB.PSTH,1)
    nCells_developedTuning = size(datasetB.PSTH,1) - size(datasetA.PSTH,1);
    fprintf('[INFO] There are %i cells that have developed tuning\n', nCells_developedTuning)
elseif size(datasetA.PSTH,1) == size(datasetB.PSTH,1)
    disp('[INFO] All cell pairs accounted for')
else
    error('[INFO] Unknown comparison of tuning between cell pairs')
end

%% Only for the same cells across both datasets - same cells
checkPoint1 = datasetA.timeLockedCells_temp + datasetB.timeLockedCells_temp;
datasetB.timeLockedCells_temp_same = zeros(size(datasetB.timeLockedCells_temp)); %preallocation
datasetB.timeLockedCells_temp_same(find(checkPoint1==2)) = 1; %These are the same cells as in datasetA
%Now, getting rid of extra cells in datasetA
checkPoint2 = datasetA.timeLockedCells_temp - datasetB.timeLockedCells_temp_same;
datasetA.timeLockedCells_temp_same = datasetA.timeLockedCells_temp; %preallocation
datasetA.timeLockedCells_temp_same(find(checkPoint2)) = 0;

%1
disp('Checking for tuning on the same cells, in datasetA ...')
disp('First filtering for percentage of trials with activity, then PSTH ...')

%Develop PSTH only for cells passing >25% activity and are the same
[datasetA.PSTH_same, datasetA.PSTH_3D_same] = getPSTH(datasetA.data_sigOnly(find(datasetA.timeLockedCells_temp_same),:,:), delta, skipFrames);
%Finally, identifying true time-locked cells, using the TI metric
[datasetA.timeLockedCells_same, datasetA.TI_same] = getTimeLockedCells(datasetA.PSTH_3D_same, 1000, 99);

datasetA.data_timeLockedCells_same = datasetA.data(find(datasetA.timeLockedCells_same),:,:);
disp('... done!')

% Sorting
if isempty(find(datasetA.timeLockedCells_same,1))
    %disp('No time cells found')
else
    %Sort PSTHs only for the final list of time-locked cells
    [datasetA.sortedPSTHindices_same, datasetA.peakIndicies_same] = sortPSTH(datasetA.PSTH_same(find(datasetA.timeLockedCells_same),:));
    datasetA.PSTH_timeLockedCells_same = datasetA.PSTH_same(find(datasetA.timeLockedCells_same),:);
    datasetA.PSTH_sorted_same = datasetA.PSTH_timeLockedCells_same(datasetA.sortedPSTHindices_same,:);
    datasetA.data_sorted_timeCells_same = datasetA.data_timeLockedCells_same(datasetA.sortedPSTHindices_same,:,:);
end

%2
disp('Checking for tuning on the same cells, in datasetB ...')
disp('First filtering for percentage of trials with activity, then PSTH ...')
threshold = 0.25 * (size(datasetB.data,2)); %threshold is 25% of the session trials
%Develop PSTH only for cells passing >25% activity and are the same
[datasetB.PSTH_same, datasetB.PSTH_3D_same] = getPSTH(datasetB.data_sigOnly(find(datasetB.timeLockedCells_temp_same),:,:), delta, skipFrames);
%Finally, identifying true time-locked cells, using the TI metric
[datasetB.timeLockedCells_same, datasetB.TI_same] = getTimeLockedCells(datasetB.PSTH_3D_same, 1000, 99);

datasetB.data_timeLockedCells_same = datasetB.data(find(datasetB.timeLockedCells_same),:,:);
disp('... done!')

% Sorting
if isempty(find(datasetB.timeLockedCells_same,1))
    %disp('No time cells found')
else
    %Sort PSTHs only for the final list of time-locked cells
    [datasetB.sortedPSTHindices_same, datasetB.peakIndicies_same] = sortPSTH(datasetB.PSTH_same(find(datasetB.timeLockedCells_same),:));
    datasetB.PSTH_timeLockedCells_same = datasetB.PSTH_same(find(datasetB.timeLockedCells_same),:);
    datasetB.PSTH_sorted_same = datasetB.PSTH_timeLockedCells_same(datasetB.sortedPSTHindices_same,:);
    datasetB.data_sorted_timeCells_same = datasetB.data_timeLockedCells_same(datasetB.sortedPSTHindices_same,:,:);
end

%% Comparing PSTHs for the same cells, across days
nCells_same = min(size(datasetA.PSTH_same,1), size(datasetB.PSTH_same,1));
rho = zeros(nCells_same,1);
pval = zeros(nCells_same,1);
for cell = 1:nCells_same
    %fprintf('Cell No.: %i\n', cell)
    A = datasetA.PSTH_same(cell,:);
    B = datasetB.PSTH_same(cell,:);
    % Using Correlation Coefficients
    [r, p] = corrcoef(A, B);
    rho(cell) = r(2,1);
    pval(cell) = p(2,1);
    
    % Using Peaks in PSTH
    [~, PeaksA(cell)] = max(A);
    [~, PeaksB(cell)] = max(B);
end
interestingCells              = find(abs(rho)>0.2);
interestingCells_positiveCorr = find(rho>0.2);
fprintf('[INFO] %i cells found with positive correlation\n', length(interestingCells_positiveCorr))
interestingCells_negativeCorr = find(rho< -0.2);
fprintf('[INFO] %i cells found with negative correlation\n', length(interestingCells_negativeCorr))
interestingCells_lostCorr     = find(abs(rho) <= 0.2);
fprintf('[INFO] %i cells found with lost correlation\n', length(interestingCells_lostCorr))
%Sanity checks
if length(rho) ~= length(interestingCells_positiveCorr) + length(interestingCells_negativeCorr) + length(interestingCells_lostCorr)
    error('There is a problem with "rho"')
elseif length(interestingCells) ~= length(interestingCells_positiveCorr) + length(interestingCells_negativeCorr)
    error('There is a problem with "interestingCells"')
end

% Checking for differences in Peaks
diffPeaks = PeaksB - PeaksA; %based on assumption
sameCellPairs_earlierPeaks = find(diffPeaks<0);
fprintf('[INFO] %i cell pairs found with earlier (advanced) peaks\n', length(sameCellPairs_earlierPeaks))
sameCellPairs_samePeaks = find(diffPeaks==0);
fprintf('[INFO] %i cell pairs found with same peaks\n', length(sameCellPairs_samePeaks))
sameCellPairs_laterPeaks = find(diffPeaks>0);
fprintf('[INFO] %i cell pairs found with later (delayed) peaks\n', length(sameCellPairs_laterPeaks))

%Sanity checks
if length(diffPeaks) ~= length(sameCellPairs_earlierPeaks) + length(sameCellPairs_samePeaks) + length(sameCellPairs_laterPeaks)
    error('There is a problem with the Peaks')
end
%% Plots
if ops0.fig == 1
    nBins = size(datasetA.PSTH,2);
    % PSTH - independently analyzed
    fig1 = figure(1);
    clf
    set(fig1,'Position',[100,100,1800,700])
    %subFig1 = subplot(2,2,1);
    subplot(2,1,1)
    plotPSTH(datasetA, datasetA.PSTH_sorted, datasetA.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetA.date)), figureDetails, 1)
    set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin nBins])
    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    set(gca,'FontSize', figureDetails.fontSize-2)
    %subFig2 = subplot(2,2,2);
    subplot(2,1,2)
    plotPSTH(datasetB, datasetB.PSTH_sorted, datasetB.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetB.date)), figureDetails, 1)
    set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    set(gca,'FontSize', figureDetails.fontSize-2)
    colormap(figureDetails.colorMap)
    print(['/Users/ananth/Desktop/figs/chronicAnalysis/psth_simple_' ...
        datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
        '-djpeg');
    
    % Temporal Information - independently analyzed
    fig2 = figure(2);
    clf
    set(fig2,'Position',[100,100,800,400])
    subplot(1,2,1)
    plot(datasetA.TI, 'b*', ...
        'LineWidth', figureDetails.lineWidth, ...
        'MarkerSize', figureDetails.markerSize)
    hold on
    datasetA.TI_onlyTimeLockedCells = nan(size(datasetA.TI));
    datasetA.TI_onlyTimeLockedCells(find(datasetA.timeLockedCells)) = datasetA.TI(find(datasetA.timeLockedCells));
    plot(datasetA.TI_onlyTimeLockedCells, 'ro', ...
        'LineWidth', figureDetails.lineWidth, ...
        'MarkerSize', figureDetails.markerSize)
    axis([0 size(datasetA.TI,1) 0.5 2.5])
    title(sprintf('%s ST%s S%s - Method: %s', datasetA.mouse_name, num2str(datasetA.sessionType), num2str(datasetA.session), ops0.method), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Cell Number', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Temporal Information (bits)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    legend({'All Cells', 'Time-Locked Cells'}, 'location', 'southwest')
    set(gca,'FontSize', figureDetails.fontSize-2)
    
    subplot(1,2,2)
    plot(datasetB.TI, 'b*', ...
        'LineWidth', figureDetails.lineWidth, ...
        'MarkerSize', figureDetails.markerSize)
    hold on
    datasetB.TI_onlyTimeLockedCells = nan(size(datasetB.TI));
    datasetB.TI_onlyTimeLockedCells(find(datasetB.timeLockedCells)) = datasetB.TI(find(datasetB.timeLockedCells));
    plot(datasetB.TI_onlyTimeLockedCells, 'ro', ...
        'LineWidth', figureDetails.lineWidth, ...
        'MarkerSize', figureDetails.markerSize)
    axis([0 size(datasetA.TI,1) 0.5 2.5])
    title(sprintf('%s ST%s S%s - Method: %s', datasetB.mouse_name, num2str(datasetB.sessionType), num2str(datasetB.session), ops0.method), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Cell Number', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Temporal Information (bits)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    legend({'All Cells', 'Time-Locked Cells'}, 'location', 'southwest')
    set(gca,'FontSize', figureDetails.fontSize-2)
    
    print(['/Users/ananth/Desktop/figs/chronicAnalysis/ti_' ...
        datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
        '-djpeg');
    
    % Trends in Temporal Information - independently analyzed
    datasetA.TI_timeLockedCells = datasetA.TI(find(datasetA.timeLockedCells),:);
    datasetA.TI_sorted = datasetA.TI_timeLockedCells(datasetA.sortedPSTHindices,:);
    datasetB.TI_timeLockedCells = datasetB.TI(find(datasetB.timeLockedCells),:);
    datasetB.TI_sorted = datasetB.TI_timeLockedCells(datasetB.sortedPSTHindices,:);
    fig3 = figure(3);
    clf
    set(fig3,'Position',[300,300,800,400])
    subplot(1,2,1)
    plot(datasetA.TI_sorted, 'r*', ...
        'MarkerSize', figureDetails.markerSize)
    axis([0 size(datasetA.TI_sorted,1) 0.5 2.5])
    title(sprintf('TI - Date: %s', datasetA.date), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Sorted Time-Locked Cell Number', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Temporal Information (bits)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    %legend({'All Cells', 'Time-Locked Cells'})
    set(gca,'FontSize', figureDetails.fontSize-2)
    subplot(1,2,2)
    plot(datasetB.TI_sorted, 'r*', ...
        'MarkerSize', figureDetails.markerSize)
    axis([0 size(datasetA.TI_sorted,1) 0.5 2.5])
    title(sprintf('TI - Date: %s', datasetB.date), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Sorted Time-Locked Cell Number', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Temporal Information (bits)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    %legend({'All Cells', 'Time-Locked Cells'})
    set(gca,'FontSize', figureDetails.fontSize-2)
    print(['/Users/ananth/Desktop/figs/chronicAnalysis/ti_sorted_' ...
        datasetB.mouse_name '_' dateA '_' dateB '_' ops0.method '_multiDay'],...
        '-djpeg');
    
    % Scatter plots for peaks of PSTHs b/w datasetA and datasetB - same cells
    fig4 = figure(4);
    clf
    set(fig4,'Position',[100,100,650,550])
    scatter(PeaksA, PeaksB, 110, 'g', 'filled')
    hold on
    scatter(PeaksA(interestingCells), PeaksB(interestingCells), 150, 'rd')
    %axis([])
    title(sprintf('Comparing Peaks between Date %s and Date %s', datasetA.date, datasetB.date))
    xlabel(sprintf('Bin No. for Date: %s', datasetA.date))
    ylabel(sprintf('Bin No. for Date: %s', datasetB.date))
    legend({'All Cells', 'Cells with high corr coeffs'}, 'location', 'southeast')
    set(gca,'FontSize', figureDetails.fontSize-2)
    %axis([1 nBins 1 nBins])
    axis([datasetB.csBin-10 nBins-25 datasetB.csBin-10 nBins-25])
    print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTHpeaks_' ...
        datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
        '-djpeg');
    
    %Correlation Coefficient based selection of cell pairs - same cells
    % High correlation (positive or negative)
    if ~isempty(interestingCells)
        fig5 = figure(5);
        clf
        set(fig5,'Position',[100,100,1800,700])
        for pair = 1:length(interestingCells)
            subplot(length(interestingCells),1, pair)
            plot(datasetA.PSTH_same(interestingCells(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(interestingCells(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            %axis([1 nBins 0 200])
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | (High) Corr Coeff: %0.4f', pair, rho(interestingCells(pair))))
            if pair == ceil(length(interestingCells)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(interestingCells)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_highCorr_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
            '-djpeg');
    end
    % High Positive correlation
    if ~isempty(interestingCells_positiveCorr)
        fig6 = figure(6);
        clf
        set(fig6,'Position',[100,100,1800,700])
        for pair = 1:length(interestingCells_positiveCorr)
            subplot(length(interestingCells_positiveCorr),1, pair)
            plot(datasetA.PSTH_same(interestingCells_positiveCorr(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(interestingCells_positiveCorr(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | (Positive) Corr Coeff: %0.4f', pair, rho(interestingCells_positiveCorr(pair))))
            if pair == ceil(length(interestingCells_positiveCorr)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(interestingCells_positiveCorr)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_positiveCorr_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'], ...
            '-djpeg');
    end
    % High Negative correlation
    if ~isempty(interestingCells_negativeCorr)
        fig7 = figure(7);
        clf
        set(fig7,'Position',[100,100,1800,700])
        for pair = 1:length(interestingCells_negativeCorr)
            subplot(length(interestingCells_negativeCorr),1, pair)
            plot(datasetA.PSTH_same(interestingCells_negativeCorr(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(interestingCells_negativeCorr(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | (Negative) Corr Coeff: %0.4f', pair, rho(interestingCells_negativeCorr(pair))))
            if pair == ceil(length(interestingCells_negativeCorr)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(interestingCells_negativeCorr)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_negativeCorr_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'], ...
            '-djpeg');
    end
    % Lost correlation
    if ~isempty(interestingCells_lostCorr)
        fig8 = figure(8);
        clf
        set(fig8,'Position',[100,100,1800,700])
        for pair = 1:length(interestingCells_lostCorr)
            subplot(length(interestingCells_lostCorr),1, pair)
            plot(datasetA.PSTH_same(interestingCells_lostCorr(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(interestingCells_lostCorr(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | Corr Coeff: %0.4f', pair, rho(interestingCells_lostCorr(pair))))
            if pair == ceil(length(interestingCells_lostCorr)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(interestingCells_lostCorr)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_lostCorr_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
            '-djpeg');
    end
    
    % Advancing peaks
    if ~isempty(sameCellPairs_earlierPeaks)
        fig9 = figure(9);
        clf
        set(fig9,'Position',[100,100,1800,700])
        for pair = 1:length(sameCellPairs_earlierPeaks)
            subplot(length(sameCellPairs_earlierPeaks),1, pair)
            plot(datasetA.PSTH_same(sameCellPairs_earlierPeaks(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(sameCellPairs_earlierPeaks(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | Earlier Peaks | Corr Coeff: %0.4f', pair, rho(sameCellPairs_earlierPeaks(pair))))
            if pair == ceil(length(sameCellPairs_earlierPeaks)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(sameCellPairs_earlierPeaks)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_earlierPeaks_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
            '-djpeg');
    end
    % Same peaks
    if ~isempty(sameCellPairs_samePeaks)
        fig10 = figure(10);
        clf
        set(fig10,'Position',[100,100,1800,700])
        for pair = 1:length(sameCellPairs_samePeaks)
            subplot(length(sameCellPairs_samePeaks),1, pair)
            plot(datasetA.PSTH_same(sameCellPairs_samePeaks(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(sameCellPairs_samePeaks(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | Same Peaks | Corr Coeff: %0.4f', pair, rho(sameCellPairs_samePeaks(pair))))
            if pair == ceil(length(sameCellPairs_samePeaks)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(sameCellPairs_samePeaks)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_samePeaks_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
            '-djpeg');
    end
    % Delayed peaks
    if ~isempty(sameCellPairs_laterPeaks)
        fig11 = figure(11);
        clf
        set(fig11,'Position',[100,100,1800,700])
        for pair = 1:length(sameCellPairs_laterPeaks)
            subplot(length(sameCellPairs_laterPeaks),1, pair)
            plot(datasetA.PSTH_same(sameCellPairs_laterPeaks(pair),:), 'blue', 'LineWidth', figureDetails.lineWidth)
            hold on
            plot(datasetB.PSTH_same(sameCellPairs_laterPeaks(pair),:), 'red', 'LineWidth', figureDetails.lineWidth)
            set(gca,'FontSize', figureDetails.fontSize-5)
            if ops0.acrossSessionTypes
                set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
            else
                set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
            end
            set(gca,'XTickLabel',[])
            %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
            %position = [23 373;35 185;77 107];
            title(sprintf('Cell Pair: %i | Delayed Peaks | Corr Coeff: %0.4f', pair, rho(sameCellPairs_laterPeaks(pair))))
            if pair == ceil(length(sameCellPairs_laterPeaks)/2)
                ylabel('Summed AUC (A.U.)')
            end
            if pair == length(sameCellPairs_laterPeaks)
                %set(gca,'XTickLabel',{'0' sprintf('%i (CS)', csBin) sprintf('%i (US)', usBin) num2str(nBins)})
                if ops0.acrossSessionTypes
                    set(gca,'XTickLabel',{'1' 'CS' 'US_A' 'US_B' num2str(nBins)})
                else
                    set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
                end
            end
            legend({sprintf('Date: %s', datasetA.date), sprintf('Date: %s', datasetB.date)})
        end
        xlabel('Bin No.')
        print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_laterPeaks_' ...
            datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
            '-djpeg');
    end
end
disp('... done!')