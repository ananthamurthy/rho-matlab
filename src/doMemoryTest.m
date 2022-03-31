%NOTE: make sure to use the same value for nShuffles in the function call
%as in setupSyntheticDataParametersSingle.m

%NOTE: Keep nShuffles to the same value as in
%setupSyntheticDataParametersSingle.m
function [inUse, runTime] = doMemoryTest(gDate, nSets, nShuffles, nProcedures, plotFigure, workingOnServer, diaryOn)

if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    %saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end

procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)', 'Harvest'};

% Memory and Runtime for Synthesis and Analysis
%Preallocation
runTime = zeros(nSets, nProcedures);
inUse = zeros(nSets, nProcedures);

profilerTest = 1;
for myProcedure = 1:nProcedures
    for iSet = 1:nSets
        gRun = iSet;
        if myProcedure == 1
            disp('[INFO] Running Synthesis ...')
            %use the elapsedTime for generation
            [~, totalMem, ~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 2
            disp('[INFO] Running Analysis by A ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 3
            disp('[INFO] Running Analysis by B ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 4
            disp('[INFO] Running Analysis by C ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 5
            disp('[INFO] Running Analysis by D ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 6
            disp('[INFO] Running Analysis by E ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 7
            disp('[INFO] Running Analysis by F ...')
            [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nShuffles, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, profilerTest);
        elseif myProcedure == 8
            disp('[INFO] Running Harvest ...')
            [~, totalMem, elapsedTime] = consolidateSyntheticAnalysis(cDate, cRun, workingOnServer, diaryOn, profilerTest); %Ideal case; requires knowing when the main analysis will be complete.
            %[~, totalMem, elapsedTime] = consolidateBatch(gDate, gRun, workingOnServer, diaryOn, profilerTest); %using cDate = gDate; cRun = gRun; for small batches.
        end
        sprintf('Set: %i, nDatasets: %i, Procedure: %s, Time: %d mins., Mem.: %.4f MB\n', iSet, nShuffles, char(procedureLabels(myProcedure)), elapsedTime/60, totalMem)

        runTime(iSet, myProcedure) = elapsedTime/60;
        inUse(iSet, myProcedure) = totalMem; %as Bytes
        %whos
        %profview
        %keyboard
    end
end

if plotFigure
    %Plots
    input.nMethods = 6;
    figureDetails = compileFigureDetails(12, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
    %Extra colormap options: inferno/plasma/viridis/magma
    %C = distinguishable_colors(input.nMethods);
    C = linspecer(input.nMethods);
    procedureLabels = {'Synth.', 'A', 'B', 'C', 'D', 'E', 'F'};
    %procedureLabels2 = {'Synth.', '+A', '+B', '+C', '+D', '+E', '+F'};

    %Memory
    meanInUse = mean(inUse, 2);
    stdInUse = std(inUse, 2);

    %Runtime
    meanRunTime = mean(runTime, 2);
    stdRunTime = std(runTime, 2);

    x = 1:7;
    fig1 = figure(1);
    set(fig1, 'Position', [100, 100, 800, 400])
    subplot(1, 2, 1)
    %b1 = bar(squeeze(inUse(1, :)));
    %b1.FaceColor = C(1, :);
    %axis tight
    b1 = bar(meanInUse);
    b1.FaceColor = C(1, :);
    %set(b2,'FaceAlpha', 0.5)
    hold on
    er = errorbar(x, meanInUse, stdInUse, 'CapSize', 12);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    xlabel('Steps', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Memory Usage (MB)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xticklabels(procedureLabels)
    xtickangle(45)
    set(gca, 'FontSize', figureDetails.fontSize)

    subplot(1, 2, 2)
    b1 = bar(meanRunTime);
    b1.FaceColor = C(2, :);
    %set(b2,'FaceAlpha', 0.5)
    hold on
    er = errorbar(x, meanRunTime, stdRunTime, 'CapSize', 12);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    set(gca,'YScale','log')
    %xlim([1, 7])
    xticks([1, 2, 3, 4, 5, 6, 7])
    ylim([1, 100])
    yticks([1, 10, 100])
    axis tight
    title('Runtimes', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xlabel('Steps', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('log(time/mins.)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xticklabels(procedureLabels)
    xtickangle(45)
    set(gca, 'FontSize', figureDetails.fontSize)
end

%Save
save([HOME_DIR 'rho-matlab/profile_nShuffles' num2str(nShuffles) '.mat'], ...
    'runTime', ...
    'inUse')

profile off
end