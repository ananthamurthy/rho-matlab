%NOTE: this script is for doing a full analysis on real datasets.

function [inUse, runTime] = analyzeRealData(cDate, cRun, nTotalDatasets, workingOnServer, diaryOn, profilerTest)

%workingOnServer = 0;
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    %saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end

procedureLabels = {'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'Param. Eqs. (F)', 'Harvest'}; %6 procedures (no synthesis or SVM)
nProcedures = 6;
runTime = zeros(nProcedures, 1);
inUse = zeros(nProcedures, 1);
%profilerTest = 0; %Keep this to 0, to avoid going into profile testing mode (see doMemoryTest.m)
startProcedure = 1;
for myProcedure = startProcedure:nProcedures
    if myProcedure == 1
        disp('[INFO] Running Analysis by A ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnRealData(1, nTotalDatasets, 1, 0, 0, 0, 0, 0, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 2
        disp('[INFO] Running Analysis by B ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnRealData(1, nTotalDatasets, 0, 1, 0, 0, 0, 0, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 3
        disp('[INFO] Running Analysis by C ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnRealData(1, nTotalDatasets, 0, 0, 1, 0, 0, 0, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 4
        disp('[INFO] Running Analysis by D ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnRealData(1, nTotalDatasets, 0, 0, 0, 1, 0, 0, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 5
        disp('[INFO] Running Analysis by F ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnRealData(1, nTotalDatasets, 0, 0, 0, 0, 0, 1, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 6
        disp('[INFO] Running Harvest ...')
        [~, totalMem, elapsedTime] = consolidateRealDataAnalysis(cDate, cRun, workingOnServer, diaryOn, profilerTest);
    end
    sprintf('Procedure: %s, nDatasets: %i, Time: %d sec, Mem.: %.4f MB\n', char(procedureLabels(myProcedure)), nTotalDatasets, elapsedTime, totalMem)

    runTime(myProcedure) = elapsedTime; %in secs
    inUse(myProcedure) = totalMem; %in Bytes
end