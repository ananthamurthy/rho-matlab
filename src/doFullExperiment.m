function [inUse, runTime] = doFullExperiment(gDate, gRun, nTotalDatasets, workingOnServer, diaryOn)

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

%procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)', 'Harvest'}; %All; 8 procedures
procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)'}; % 7 procedures
nProcedures = 7;
runTime = zeros(nProcedures, 1);
inUse = zeros(nProcedures, 1);

for myProcedure = 1:nProcedures
        if myProcedure == 1
            %use the elapsedTime for generation
            [~, totalMem, ~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 2
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 3
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 4
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 5
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 6
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 7
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        end
        sprintf('Set: %i, nDatasets: %i, Procedure: %s, Time: %d mins., Mem.: %.4f MB\n', iSet, nTotalDatasets, char(procedureLabels(myProcedure)), elapsedTime/60, totalMem)

        runTime(myProcedure) = elapsedTime/60;
        inUse(myProcedure) = totalMem; %as Bytes
end