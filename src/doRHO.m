%NOTE: this script is to do the full experiment of RHO, i.e.- Synthesis and
%Analysis.

function [inUse, runTime] = doRHO(gDate, gRun, cDate, cRun, nTotalDatasets, workingOnServer, diaryOn, profilerTest)

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

%Additinal search paths
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))
addpath(genpath('/home/ananth/Documents/rho-matlab/localCopies'))

procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)', 'Harvest'}; %All; 8 procedures
nProcedures = 8; %8 for everything, 7 to skip Harvest.
runTime = zeros(nProcedures, 1);
inUse = zeros(nProcedures, 1);
%profilerTest = 0; %Keep this to 0, to avoid going into profile testing mode (see doMemoryTest.m)
startProcedure = 8;
for myProcedure = startProcedure:nProcedures
    if myProcedure == 1
        disp('[INFO] Running Synthesis ...')
        %use the elapsedTime for generation
        [~, totalMem, ~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 2
        disp('[INFO] Running Analysis by A ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 3
        disp('[INFO] Running Analysis by B ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 4
        disp('[INFO] Running Analysis by C ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 5
        disp('[INFO] Running Analysis by D ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 6
        disp('[INFO] Running Analysis by E ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 7
        disp('[INFO] Running Analysis by F ...')
        [~, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(1, nTotalDatasets, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, profilerTest);
    elseif myProcedure == 8
        disp('[INFO] Running Harvest ...')
        [~, totalMem, elapsedTime] = consolidateSyntheticDataAnalysis(cDate, cRun, workingOnServer, diaryOn, profilerTest);
    end
    sprintf('Procedure: %s, nDatasets: %i, Time: %d sec, Mem.: %.4f MB\n', char(procedureLabels(myProcedure)), nTotalDatasets, elapsedTime, totalMem)

    runTime(myProcedure) = elapsedTime; %in secs
    inUse(myProcedure) = totalMem; %in Bytes
end