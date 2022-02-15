function [inUse, runTime] = doFullExperiment(gDate, gRun, cDate, cRun, nTotalDatasets, workingOnServer, diaryOn)

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

procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)', 'Harvest'}; %All; 8 procedures
%procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)'}; % 7 procedures
nProcedures = 8;
runTime = zeros(nProcedures, 1);
inUse = zeros(nProcedures, 1);
myProfilerTest = 0; %Keep this to 0, to avoid going into profile testing mode (see doMemoryTest.m)
for myProcedure = 1:nProcedures
        if myProcedure == 1
            disp('[INFO] Running Synthesis ...')
            %use the elapsedTime for generation
            [~, totalMem, ~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 2
            disp('[INFO] Running Analysis by A ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 3
            disp('[INFO] Running Analysis by B ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 4
            disp('[INFO] Running Analysis by C ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 5
            disp('[INFO] Running Analysis by D ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 6
            disp('[INFO] Running Analysis by E ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 7
            disp('[INFO] Running Analysis by F ...')
            [~, totalMem, elapsedTime] = runBatchAnalysis(1, nTotalDatasets, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        elseif myProcedure == 8
            disp('[INFO] Running Harvest ...')
            [~, totalMem, elapsedTime] = consolidateBatch(cDate, cRun, workingOnServer, diaryOn, profilerTest); %Ideal case; requires knowing when the main analysis will be complete.
            %[~, totalMem, elapsedTime] = consolidateBatch(gDate, gRun, workingOnServer, diaryOn, profilerTest); %using cDate = gDate; cRun = gRun; for small batches.
        end
        sprintf('Procedure: %s, nDatasets: %i, Time: %d sec, Mem.: %.4f MB\n', char(procedureLabels(myProcedure)), nTotalDatasets, elapsedTime, totalMem)

        runTime(myProcedure) = elapsedTime; %in secs
        inUse(myProcedure) = totalMem; %in Bytes
end