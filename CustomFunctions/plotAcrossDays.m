% AUTHOR - Kambadur Ananthmurthy
% Plot consistently identified cells across multiple days
clear all
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

[datasetA, datasetB] = compileChronicData(mouseName, dateA, dateB, ...
    sessionA, sessionB, sessionTypeA, sessionTypeB, nFrames, trialDuration);
[datasetA, datasetB] = loadChronicData(datasetA, datasetB); %NOTE: requires _reg.mat file

%% Check for tuning
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
disp('First filtering for percentage of trials with activity, then PSTH ...')
threshold = 0.25 * (size(datasetA.data,2)); %threshold is 25% of the session trials
[datasetA.cellRastor, datasetA.cellFrequency, datasetA.timeLockedCells_temp, datasetA.importantTrials] = ...
    getFreqBasedTimeCellList(datasetA.data_sigOnly, threshold, skipFrames);
[datasetA.PSTH, datasetA.PSTH_3D] = getPSTH(datasetA.data_sigOnly(find(datasetA.timeLockedCells_temp),:,:), delta, skipFrames);
[datasetA.timeLockedCells, datasetA.TI] = getTimeLockedCells(datasetA.PSTH_3D, 1000, 99);

datasetA.data_timeLockedCells = datasetA.data(find(datasetA.timeLockedCells),:,:);
datasetA.data_2D_timeLockedCells = datasetA.data_2D(find(datasetA.timeLockedCells),:,:);

% Sorting
if isempty(find(datasetA.timeLockedCells,1))
    %disp('No time cells found')
else
    [datasetA.sortedPSTHindices, datasetA.peakIndicies] = sortPSTH(datasetA.PSTH(find(datasetA.timeLockedCells),:));
    datasetA.PSTH_timeLockedCells = datasetA.PSTH(find(datasetA.timeLockedCells),:);
    datasetA.PSTH_sorted = datasetA.PSTH_timeLockedCells(datasetA.sortedPSTHindices,:);
    datasetA.data_sorted_timeCells = datasetA.data_timeLockedCells(datasetA.sortedPSTHindices,:,:);
    %datasetA.data_2D_sorted_timeCells = datasetA.data_2D_timeLockedCells(datasetA.sortedPSTHindices,:);
end

%2
disp('First filtering for percentage of trials with activity, then PSTH ...')
threshold = 0.25 * (size(datasetB.data,2)); %threshold is 25% of the session trials
[datasetB.cellRastor, datasetB.cellFrequency, datasetB.timeLockedCells_temp, datasetB.importantTrials] = ...
    getFreqBasedTimeCellList(datasetB.data_sigOnly, threshold, skipFrames);
[datasetB.PSTH, datasetB.PSTH_3D] = getPSTH(datasetB.data_sigOnly(find(datasetB.timeLockedCells_temp),:,:), delta, skipFrames);
[datasetB.timeLockedCells, datasetB.TI] = getTimeLockedCells(datasetB.PSTH_3D, 1000, 99);

datasetB.data_timeLockedCells = datasetB.data(find(datasetB.timeLockedCells),:,:);
datasetB.data_2D_timeLockedCells = datasetB.data_2D(find(datasetB.timeLockedCells),:,:);

% Sorting
if isempty(find(datasetB.timeLockedCells,1))
    %disp('No time cells found')
else
    %sorting based on B
    [datasetB.sortedPSTHindices, datasetB.peakIndicies] = sortPSTH(datasetB.PSTH(find(datasetB.timeLockedCells),:));
    datasetB.PSTH_timeLockedCells = datasetB.PSTH(find(datasetB.timeLockedCells),:);
    datasetB.PSTH_sorted = datasetB.PSTH_timeLockedCells(datasetB.sortedPSTHindices,:);
    datasetB.data_sorted_timeCells = datasetB.data_timeLockedCells(datasetB.sortedPSTHindices,:,:);
    %datasetB.data_2D_sorted_timeCells = datasetB.data_2D_timeLockedCells(datasetB.sortedPSTHindices,:);
    
    %sorting based on B
    %datasetA.PSTH_sorted_byB = datasetA.PSTH(datasetB.sortedPSTHindices,:);
    %datasetA.data_timeLockedCells_byB = datasetA.data_sigOnly(find(datasetB.timeLockedCells),:,:);
    %datasetA.data_sorted_timeCells_byB = datasetA.data_timeLockedCells_byB(datasetB.sortedPSTHindices,:,:);
    %datasetA.data_2D_timeLockedCells_byB = ;
    %datasetA.data_2D_sorted_timeCells_B = datasetA.data_2D_timeLockedCells_byB(datasetB.sortedPSTHindices,:);
    
    %sorting based on A
    %datasetB.PSTH_sorted_byA = datasetB.PSTH(datasetA.sortedPSTHindices,:);
    %datasetB.data_sorted_timeCells_byA = datasetB.data_timeLockedCells(datasetA.sortedPSTHindices,:,:);
    %datasetB.data_2D_sorted_timeCells_byA = datasetB.data_2D_timeLockedCells(datasetB.sortedPSTHindices,:);
end
%% Comparing PSTHs across days

nCells = size(datasetA.PSTH,1);
rho = zeros(nCells,1);
pval = zeros(nCells,1);
for cell = 1:nCells
    %fprintf('Cell No.: %i\n', cell)
    A = datasetA.PSTH(cell,:);
    B = datasetB.PSTH(cell,:);
    % Using Correlation Coefficients
    [r, p] = corrcoef(A, B);
    rho(cell) = r(2,1);
    pval(cell) = p(2,1);
    
    % Using Peaks in PSTH
    [~, PeaksA(cell)] = max(A);
    [~, PeaksB(cell)] = max(B);
    
end
interestingCells = find(abs(rho)>0.2);
interestingCells_positiveCorr = find(rho>0.2);
interestingCells_negativeCorr = find(rho<0.2);
interestingCells_lostCorr     = find(abs(rho)<= 0.2);
%Sanity checks
if length(rho) ~= length(interestingCells_positiveCorr) + length(interestingCells_negativeCorr + length(interestingCells_lostCorr)
    disp('[INFO] There is a problem with the Interesting Cells')
elseif length(interestingCells) ~= length(interestingCells_positiveCorr) + length(interestingCells_negativeCorr)
    disp('[INFO] There is a problem with the Interesting Cells')
end
%% Plots
if ops0.fig == 1
    nBins = size(datasetA.PSTH,2);
    % Trial Averaged - Sequences
    %     fig1 = figure(1);
    %     set(fig1,'Position',[300,300,2000,500])
    %     %1
    %     %trialDetails = getTrialDetails(dataset);
    %     subplot(1,2,1)
    %     trialPhase = 'wholeTrial';
    %     plotSequences(datasetA, datasetA.data_sorted_timeCells, trialPhase, 'Frames', 'Chronically Tracked Cells (Unsorted)', figureDetails, 0)
    %     %A = datasetA.sigOnly(find(datasetA.timeLockedCells),:,:);
    %     %plotSequences(datasetB, A, trialPhase, 'Frames', 'Chronically Tracked Cells (Unsorted)', figureDetails, 0)(datasetA, datasetA.trialAvg, trialPhase, 'Frames', 'Chronically Tracked Tuned Cells', figureDetails, 0)
    %     set(gca,'FontSize',figureDetails.fontSize-4)
    %     %hold on
    %
    %     %2
    %     %trialDetails = getTrialDetails(dataset);
    %     subplot(1,2,2)
    %     trialPhase = 'wholeTrial';
    %     plotSequences(datasetB, datasetB.data_sorted_timeCells, trialPhase, 'Frames', 'Chronically Tracked Cells (Unsorted)', figureDetails, 0)
    %     %B = datasetB.sigOnly(find(datasetB.timeLockedCells),:,:);
    %     %plotSequences(datasetB, B, trialPhase, 'Frames', 'Chronically Tracked Tuned Cells', figureDetails, 0)
    %     set(gca,'FontSize',figureDetails.fontSize-4)
    %     colormap('hot')
    %     %print(['/Users/ananth/Desktop/figs/chronicAnalysis/calciumActivity/dfbf_trialAvg_' ...
    %     print(['/Users/ananth/Desktop/figs/chronicAnalysis/dfbf_trialAvg_' ...
    %         datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
    %         '-djpeg');
    
    % PSTH
    fig2 = figure(2);
    clf
    set(fig2,'Position',[100,100,1800,700])
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
    %     % PSTH sorted by different dates
    %     fig3 = figure(3);
    %     clf
    %     set(fig3,'Position',[100,100,2000,800])
    %     %subFig1 = subplot(2,2,1);
    %     subplot(2,2,1)
    %     plotPSTH(datasetA, datasetA.PSTH_sorted, datasetA.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetA.date)), figureDetails, 1)
    %     set(gca, 'XTick', [1 csBin usBin nBins])
    %     set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    %     set(gca,'FontSize', figureDetails.fontSize-2)
    %     %subFig2 = subplot(2,2,2);
    %     subplot(2,2,2)
    %     plotPSTH(datasetB, datasetB.PSTH_sorted_byA, datasetB.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetA.date)), figureDetails, 1)
    %     set(gca, 'XTick', [1 csBin usBin nBins])
    %     set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    %     set(gca,'FontSize', figureDetails.fontSize-2)
    %     subplot(2,2,3)
    %     plotPSTH(datasetA, datasetA.PSTH_sorted_byB, datasetA.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetB.date)), figureDetails, 1)
    %     set(gca, 'XTick', [1 csBin usBin nBins])
    %     set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    %     set(gca,'FontSize', figureDetails.fontSize-2)
    %     %subFig2 = subplot(2,2,2);
    %     subplot(2,2,4)
    %     plotPSTH(datasetB, datasetB.PSTH_sorted, datasetB.trialDetails, 'Bin No.', sprintf('Sorted Cells (by %s)',num2str(datasetB.date)), figureDetails, 1)
    %     set(gca, 'XTick', [1 csBin usBin nBins])
    %     set(gca,'XTickLabel',{'1' 'CS' 'US' num2str(nBins)})
    %     set(gca,'FontSize', figureDetails.fontSize-2)
    %     colormap(figureDetails.colorMap)
    %
    %     print(['/Users/ananth/Desktop/figs/chronicAnalysis/psth_' ...
    %         datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
    %         '-djpeg');
    
    % Temporal Information
    fig4 = figure(4);
    clf
    set(fig4,'Position',[100,100,800,400])
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
    axis([0 size(datasetA.TI,1) 0 2])
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
    datasetB.TI_onlyTimeLockedCells = datasetB.TI(find(datasetB.timeLockedCells),:); %check
    plot(datasetB.TI_onlyTimeLockedCells, 'ro', ...
        'LineWidth', figureDetails.lineWidth, ...
        'MarkerSize', figureDetails.markerSize)
    axis([0 size(datasetB.TI,1) 0 2])
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
    
    % Trends in Temporal Information
    TI_timeLockedCells = TI(find(timeLockedCells),:);
    TI_sorted = TI_timeLockedCells(sortedPSTHindices,:);
    fig5 = figure(5);
    clf
    set(fig5,'Position',[300,300,800,400])
    plot(TI_sorted, 'r*', ...
        'MarkerSize', figureDetails.markerSize)
    title(sprintf('Trends in Temporal Information (Method: %s)', ops0.method), ...
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
        db(iexp).mouse_name '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_' ops0.method '_multiDay'],...
        '-djpeg');
    
    %Correlation Coefficient based selection of cell pairs
    fig6 = figure(6);
    clf
    set(fig6,'Position',[100,100,1500,700])
    for pair = 1:length(interestingCells)
        subplot(length(interestingCells),1, pair)
        bar(datasetA.PSTH(interestingCells(pair),:), 'blue', 'FaceAlpha', 0.3)
        hold on
        bar(datasetB.PSTH(interestingCells(pair),:), 'red', 'FaceAlpha', 0.3)
        set(gca,'FontSize', figureDetails.fontSize-5)
        if ops0.acrossSessionTypes
            set(gca, 'XTick', [1 datasetA.csBin datasetA.usBin datasetB.usBin nBins])
        else
            set(gca, 'XTick', [1 datasetB.csBin datasetB.usBin nBins])
        end
        set(gca,'XTickLabel',[])
        %text_str = sprintf('Correlation Coefficient: %0.4f', rho(interestingCells(pair)));
        %position = [23 373;35 185;77 107];
        title(sprintf('Cell Pair: %i | Corr Coeff: %0.4f', pair, rho(interestingCells(pair))))
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
    print(['/Users/ananth/Desktop/figs/chronicAnalysis/comparingPSTH_' ...
        datasetB.mouse_name '_' dateA '_' dateB  '_multiDay'],...
        '-djpeg');
    
    fig7 = figure(7);
    clf
    set(fig7,'Position',[100,100,650,550])
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
end
disp('... done!')