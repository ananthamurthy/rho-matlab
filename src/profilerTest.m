myProfilerTest = 1;
if myProfilerTest
    % Runtime and profile - Synthesis % Analysis
    %[diagnostics] = generateSyntheticData(20211029, 2, 0, 0, 1);
    gDate2 = 20211111; %For example datasets - Profiler On
    gRun2 = 1;
    nSets = 3;
    nMethods = input.nMethods;
    runTime = zeros(nSets, nMethods+1);
    for iSet = 1:nSets
        gRun2 = iSet; %For example datasets - Profiler On
        
        [~, elapsedTime] = generateSyntheticData(gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
        
        for myMethod = 1:nMethods+1
            if myMethod == 1
                %use the elapsedTime for generation
                %Offset by 1
            elseif myMethod == 2
                elapsedTime = runBatchAnalysis(1, 3, 1, 0, 0, 0, 0, 0, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 3
                elapsedTime = runBatchAnalysis(1, 3, 0, 1, 0, 0, 0, 0, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 4
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 1, 0, 0, 0, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 5
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 1, 0, 0, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 6
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 0, 1, 0, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            elseif myMethod == 7
                elapsedTime = runBatchAnalysis(1, 3, 0, 0, 0, 0, 0, 1, gDate2, gRun2, workingOnServer, diaryOn, myProfilerTest);
            end
            sprintf('Set %i: Analysis of %i datasets by %s took %d mins.\n', iSet, num2str(3), char(methodLabels(myMethod)), elapsedTime/60)
            
            runTime(iSet, myMethod) = elapsedTime/60;
        end
    end
end
