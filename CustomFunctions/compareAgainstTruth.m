function [results1, results2, results3] = compareAgainstTruth(X, Y, input)
% TP, FN, FP, TN
nCases = length(Y);

%Preallocation
allTP = zeros(nCases, input.nAlgos);
allTN = zeros(nCases, input.nAlgos);
allFP = zeros(nCases, input.nAlgos);
allFN = zeros(nCases, input.nAlgos);
TPR = zeros(input.nAlgos, 1); %Sensitivity or Recall
FPR = zeros(input.nAlgos, 1); %Fall-out or False Positive Rate
TNR = zeros(input.nAlgos, 1); %Specificity
FNR = zeros(input.nAlgos, 1); %Miss Rate
PPV = zeros(input.nAlgos, 1); %Positive Predictive Value or Precision
NPV = zeros(input.nAlgos, 1); %Negative Predictive Value
FDR = zeros(input.nAlgos, 1); %False Discovery Rate
FOR = zeros(input.nAlgos, 1); %Flase Omission Rate
PT = zeros(input.nAlgos, 1); %Prevalence Threshold
TS = zeros(input.nAlgos, 1); %Threat Score or Critical Success Index (CSI)
ACC = zeros(input.nAlgos, 1); %Accuracy
BA = zeros(input.nAlgos, 1); %Balanced Accuracy

results1 = zeros(input.nAlgos, 4);
results2 = zeros(input.nAlgos, 4);
results3 = zeros(input.nAlgos, 3);

for algo = 1:input.nAlgos
    for myCase = 1:nCases
        if Y(myCase) %Positive Cases
            if X(myCase, algo)
                allTP(myCase, algo) = 1;
            else
                allFN(myCase, algo) = 1;
            end
        else %Negative Cases
            if X(myCase, algo)
                allFP(myCase, algo) = 1;
            else
                allTN(myCase, algo) = 1;
            end
        end
    end
    
    TP = sum(allTP(:, algo));
    FN = sum(allFN(:, algo));
    FP = sum(allFP(:, algo));
    TN = sum(allTN(:, algo));
    
%     fprintf('[INFO] Algorithm: %i\n', algo);
%     fprintf('--> TP = %i\n', TP);
%     fprintf('--> FN = %i\n', FN);
%     fprintf('--> FP = %i\n', FP);
%     fprintf('--> TN = %i\n', TN);
    
    if TP == 0
        %warning('TP = 0 for algo: %i', algo)
        TPR(algo) = 0; %Recall
        PPV(algo) = 0; %Precision
        TS(algo) = 0;
    else
        TPR(algo) = TP/(TP + FN); %Recall
        PPV(algo) = TP/(TP + FP); %Precision
        TS(algo) = TP/(TP + FN + FP);
    end
    
    if FP == 0
        FPR(algo) = 0;
        FDR(algo) = 0;
    else
        FPR(algo) = FP/(FP + TN);
        FDR(algo) = FP/(FP + TP);
    end

    if TN == 0
        TNR(algo) = 0;
        NPV(algo) = 0;
    else
        TNR(algo) = TN/(TN + FP);
        NPV(algo) = TN/(TN + FN);
    end

    if FN == 0
        FNR(algo) = 0;
        FOR(algo) = 0;
    else
        FNR(algo) = FN/(FN + TP);
        FOR(algo) = FN/(FN + TN);
    end
    
    PT(algo) = (sqrt(TPR(algo)*(-TNR(algo) +1)) + TNR(algo) - 1)/(TPR(algo) + TNR(algo) -1);
    
    ACC(algo) = (TP + TN)/(TP + TN + FP + FN);
    BA(algo) = (TPR(algo) + TNR(algo))/2;
    
    results1(algo, 1) = TPR(algo);
    results1(algo, 2) = FPR(algo);
    results1(algo, 3) = TNR(algo);
    results1(algo, 4) = FNR(algo);
    
    results2(algo, 1) = TPR(algo);
    results2(algo, 2) = TNR(algo);
    results2(algo, 3) = FDR(algo);
    results2(algo, 4) = FOR(algo);
    
    results3(algo, 1) = TPR(algo); %Recall
    results3(algo, 2) = PPV(algo); %Precision

    if TP == 0 || TPR(algo) == 0 || PPV(algo) == 0
        results3(algo, 3) = 0;
    else
        results3(algo, 3) = (2 * TPR(algo) * PPV(algo))/(TPR(algo) + PPV(algo)); %F1 Score
    end

    % NaN check - Recall
    if isnan(results3(algo, 1))
        warning('Recall is NaN for Algorithm %i', algo)
    end
    
    % NaN check - Precision
    if isnan(results3(algo, 2))
        warning('Precision is NaN for Algorithm %i', algo)
    end
    
    % NaN check - F1 Score
    if isnan(results3(algo, 3))
        warning('F1 Score is NaN for Algorithm %i', algo)
    end
end
end