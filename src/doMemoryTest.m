function [inUse, runTime] = doMemoryTest(gDate, nSets, nProcedures, workingOnServer, diaryOn)

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
myProfilerTest = 1;
if myProfilerTest
    %profile -memory on
    % Runtime and profile - Synthesis % Analysis
    runTime = zeros(nSets, nProcedures);
    inUse = zeros(nSets, nProcedures);
    for iSet = 1:nSets
        gRun = iSet; %For example datasets - Profiler On
        
        for myProcedure = 1:nProcedures
            if myProcedure == 1
                %use the elapsedTime for generation
                [memoryUsage, totalMem, ~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 2
                [memoryUsage, totalMem, elapsedTime] = runBatchAnalysis(1, 3, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 3
                [memoryUsage, totalMem, elapsedTime] = runBatchAnalysis(1, 3, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 4
                [memoryUsage, totalMem, elapsedTime]= runBatchAnalysis(1, 3, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 5
                [memoryUsage, totalMem, elapsedTime] = runBatchAnalysis(1, 3, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 6
                [memoryUsage, totalMem, elapsedTime] = runBatchAnalysis(1, 3, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myProcedure == 7
                [memoryUsage, totalMem, elapsedTime] = runBatchAnalysis(1, 3, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            end
            sprintf('Set: %i -> nDatasets: 3 -> Procedure: %s -> Time: %d mins. -> Mem.: %.4f MB\n', iSet, char(procedureLabels(myProcedure)), elapsedTime/60, totalMem)
            
            runTime(iSet, myProcedure) = elapsedTime/60;
            inUse(iSet, myProcedure) = totalMem; %as Bytes
            %whos
            %profview
            %keyboard
        end 
    end
    
    %Plots
    input.nMethods = 6;
    figureDetails = compileFigureDetails(12, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
    %Extra colormap options: inferno/plasma/viridis/magma
    %C = distinguishable_colors(input.nMethods);
    C = linspecer(input.nMethods);
    procedureLabels = {'Synth.', 'A', 'B', 'C', 'D', 'E', 'F'};
    procedureLabels2 = {'Synth.', '+A', '+B', '+C', '+D', '+E', '+F'};
    
    fig1 = figure(1);
    set(fig1, 'Position', [100, 100, 800, 400])
    subplot(1, 2, 1)
    b1 = bar(squeeze(inUse(1, :)));
    b1.FaceColor = C(1, :);
    axis tight
    xlabel('Steps', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    ylabel('Memory Usage', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xticklabels(procedureLabels2)
    xtickangle(45)
    set(gca, 'FontSize', figureDetails.fontSize)
    
    subplot(1, 2, 2)
    b2 = bar(squeeze(runTime(1, :)));
    b2.FaceColor = C(2, :);
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
    xticklabels(procedureLabels2)
    xtickangle(45)
    set(gca, 'FontSize', figureDetails.fontSize)
    
    %Save
    save([HOME_DIR 'rho-matlab/profile.mat'], ...
        'runTime', ...
        'inUse')
    
    profile off
end

end