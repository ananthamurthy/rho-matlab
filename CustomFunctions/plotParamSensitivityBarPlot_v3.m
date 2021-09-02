function sensitivity = plotParamSensitivityBarPlot_v3(dIndices, normalize, labels, figureDetails, sdo_batch, cData, nMethods, nParams, useNames, plotPTC)

ptcList = sdo_batch(dIndices(1)).ptcList; %Putative Time Cells
ocList = sdo_batch(dIndices(1)).ocList; %Other Cells

sensitivity = zeros(nMethods, 2);
C = distinguishable_colors(9);

for param = 1:nParams
    for method = 1:nMethods
        if method == 1 %orginal method
            if plotPTC
                y(param, method, :) = sdo_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = sdo_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 2 %method A
            if plotPTC
                y(param, method, :) = cData.methodA.mAOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodA.mAOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 3 %method B
            if plotPTC
                y(param, method, :) = cData.methodB.mBOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodB.mBOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 4 %method C1
            if plotPTC
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q1(ptcList);
            else
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q1(ocList);
            end
        elseif method == 5 %method C2
            if plotPTC
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ptcList);
            else
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ocList);
            end
        elseif method == 6 %method D
            if plotPTC
                y(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 7 %method E
            if plotPTC
                y(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 8 %method F1
            if plotPTC
                y(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q1(ptcList);
            else
                y(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q1(ocList);
            end
        elseif method == 9 %method F2
            if plotPTC
                y(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q2(ptcList);
            else
                y(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q2(ocList);
            end
        else
            error('Unknown method')
        end
        if plotPTC
            y_median(param, method) = nanmedian(y(param, method, :));
        else
            y_median(param, method) = nanmedian(y(param, method, :));
        end
        
        if plotPTC
            y_stddev(param, method) = nanstd(squeeze(y(param, method, :)));
        else
            y_stddev(param, method) = nanstd(squeeze(y(param, method, :)));
        end
    end
end

x = 1:nParams;
%Normalize
if normalize
    y_norm_median = zeros(size(y));
    %     disp('Normalizing ...')
    for method = 1:nMethods
        if plotPTC
            norm = nanmax(nanmax(squeeze(y(:, method, :))));
            y_norm(:, method, :) = y(:, method, :)/norm;
        else
            norm = nanmax(nanmax(squeeze(y(:, method, :))));
            y_norm(:, method, :) = y(:, method, :)/norm;
        end
    end
    
    for param = 1:nParams
        for method = 1:nMethods
            y_norm_median(param, method) = nanmedian(squeeze(y_norm(param, method, :)));
            y_norm_stddev(param, method) = nanstd(squeeze(y_norm(param, method, :)));
        end
    end
    
    for method = 1:nMethods
        %Summarize
        Z = y_norm_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    if plotPTC
        completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    else
        completeTitle = strcat(labels.titleMain, '-', labels.titleOC);
    end
    %Summary
    X = sensitivity(:, 1);
    b = bar(X, 'BaseValue', 0);
    b.FaceColor = 'flat';
    for method = 1:nMethods
        b.CData(method,:) = C(method, :);
    end
    ylim([-0.02, 0.1])
    axis tight
    %axis equal tight
    %title(strcat(completeTitle, '-', labels.xtitle))
    %title(labels.xtitle)
    %xlabel('Methods')
    ylabel('normS')
    if useNames == 1
        xticklabels({'RefQ', 'R2B', 'TI', 'C1', 'C2', 'PCA', 'SVM', 'DerQ1', 'DerQ2'})
    elseif useNames == 2
        xticklabels({'RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'F1', 'F2'})
    else
        xticklabels({'1', '2', '3', '4', '5', '6', '7', '8', '9'})
    end
    set(gca, 'FontSize', figureDetails.fontSize-2)
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/barPlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
else
    for method = 1:nMethods
        %Summarize
        Z = y_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    %Summary
    X = sensitivity(:, 1);
    b = bar(X, 'BaseValue', 0);
    b.FaceColor = 'flat';
    for method = 1:nMethods
        b.CData(method,:) = C(method, :);
    end
    ylim([-0.2, 0.1])
    axis tight
    %axis equal tight
    %title(strcat(completeTitle, '-', labels.xtitle))
    %title(labels.xtitle)
    %xlabel('Methods')
    ylabel('normS')
    if useNames == 1
        xticklabels({'RefQ', 'R2B', 'TI', 'C1', 'C2', 'PCA', 'SVM', 'DerQ1', 'DerQ2'})
    elseif useNames == 2
        xticklabels({'RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'F1', 'F2'})
    else
        xticklabels({'1', '2', '3', '4', '5', '6', '7', '8', '9'})
    end
    set(gca, 'FontSize', figureDetails.fontSize-2)
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/barPlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
end
end
