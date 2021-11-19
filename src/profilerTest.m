function runTime = profilerTest(gDate, nSets, nMethods, workingOnServer, diaryOn)

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

procedureLabels = {'Synthesis', 'R2B (A)', 'TI (B)', 'Peak AUC/Std (C)', 'PCA (D)', 'SVM (E)', 'Param. Eqs. (F)'};
myProfilerTest = 1;
if myProfilerTest
    % Runtime and profile - Synthesis % Analysis
    runTime = zeros(nSets, nMethods+1);
    for iSet = 1:nSets
        gRun = iSet; %For example datasets - Profiler On
        
        [~, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
        
        for myMethod = 1:nMethods+1
            if myMethod == 1
                %use the elapsedTime for generation
                %Offset by 1
            elseif myMethod == 2
                elapsedTime = runBatchAnalysis(1, 3, 1, 0, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 3
                elapsedTime = runBatchAnalysis(1, 3, 0, 1, 0, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 4
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 1, 0, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 5
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 1, 0, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 6
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 0, 1, 0, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 7
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 0, 0, 1, gDate, gRun, workingOnServer, diaryOn, myProfilerTest);
            end
            sprintf('Set: %i -> nDatasets: 3 -> Procedure: %s -> Time: %d mins.\n', iSet, char(procedureLabels(myMethod)), elapsedTime/60)
            
            runTime(iSet, myMethod) = elapsedTime/60;
        end
    end
    save([HOME_DIR 'rho-matlab/runtimes.mat'])
end

end