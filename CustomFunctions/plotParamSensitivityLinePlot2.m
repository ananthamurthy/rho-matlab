function sensitivity = plotParamSensitivityLinePlot2(dIndices, normalize, labels, figureDetails, sdo_batch, cData, nMethods, nParams, useNames)

ptcList = sdo_batch(dIndices(1)).ptcList; %Putative Time Cells
ocList = sdo_batch(dIndices(1)).ocList; %Other Cells

sensitivity = zeros(nMethods, 2);
C = distinguishable_colors(9);

for param = 1:nParams
    for method = 1:nMethods
        if method == 1 %orginal method
            yPTC(param, method, :) = sdo_batch(dIndices(param)).Q(ptcList);
            yOC(param, method, :) = sdo_batch(dIndices(param)).Q(ocList);
        elseif method == 2 %method A
            yPTC(param, method, :) = cData.methodA.mAOutput_batch(dIndices(param)).Q(ptcList);
            yOC(param, method, :) = cData.methodA.mAOutput_batch(dIndices(param)).Q(ocList);
        elseif method == 3 %method B
            yPTC(param, method, :) = cData.methodB.mBOutput_batch(dIndices(param)).Q(ptcList);
            yOC(param, method, :) = cData.methodB.mBOutput_batch(dIndices(param)).Q(ocList);
        elseif method == 4 %method C1
            yPTC(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q1(ptcList);
            yOC(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q1(ocList);
        elseif method == 5 %method C2
            yPTC(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ptcList);
            yOC(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ocList);
        elseif method == 6 %method D
            yPTC(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ptcList);
            yOC(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ocList);
        elseif method == 7 %method E
            yPTC(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ptcList);
            yOC(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ocList);
        elseif method == 8 %method F1
            yPTC(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q1(ptcList);
            yOC(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q1(ocList);
        elseif method == 9 %method F2
            yPTC(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q2(ptcList);
            yOC(param, method, :) = cData.methodF.mFOutput_batch(dIndices(param)).Q2(ocList);
        else
            error('Unknown method')
        end
        yPTC_median(param, method) = nanmedian(yPTC(param, method, :));
        yOC_median(param, method) = nanmedian(yOC(param, method, :));
        
        yPTC_stddev(param, method) = nanstd(squeeze(yPTC(param, method, :)));
        yOC_stddev(param, method) = nanstd(squeeze(yOC(param, method, :)));
    end
end

x = 1:nParams;
%Normalize
if normalize
    %     disp('Normalizing ...')
    for method = 1:nMethods
        normValPTC = nanmax(nanmax(squeeze(yPTC(:, method, :))));
        yPTC_norm(:, method, :) = yPTC(:, method, :)/normValPTC;
        
        normValOC = nanmax(nanmax(squeeze(yOC(:, method, :))));
        yOC_norm(:, method, :) = yOC(:, method, :)/normValOC;
    end
    
    for param = 1:nParams
        for method = 1:nMethods
            yPTC_norm_median(param, method) = nanmedian(squeeze(yPTC_norm(param, method, :)));
            yOC_norm_median(param, method) = nanmedian(squeeze(yOC_norm(param, method, :)));
            
            yPTC_norm_stddev(param, method) = nanstd(squeeze(yPTC_norm(param, method, :)));
            yOC_norm_stddev(param, method) = nanstd(squeeze(yOC_norm(param, method, :)));
        end
    end
    
    %For Putative Time Cells
    fig1 = figure(1);
    set(fig1,'Position',[300, 300, 500, 500])
    %subplot(1, 2, 1)
    for method = 1:nMethods
        if method == 1
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 8
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 9
            errorbar(yPTC_norm_median(:, method), yPTC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        
        %Summarize
        Z = yPTC_norm_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    if plotPTC
        completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    else
        completeTitle = strcat(labels.titleMain, '-', labels.titleOC);
    end
    title(completeTitle)
    xlabel(labels.xtitle)
    ylabel(labels.ytitle)
    if useNames
        legend('RefQ', 'R2B', 'TI', 'C1', 'C2', 'PCA', 'SVM', 'DerQ1', 'DerQ2')
    else
        legend('RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'DerQ1', 'DerQ2')
    end
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/norm_linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
    %Summary - Putative Time Cells
    fig4 = figure(4);
    set(fig4,'Position',[300, 300, 900, 500])
    X = sensitivity(:, 1);
    bar(X,'BaseValue',0)
    %axis equal tight
    title(strcat(completeTitle, '-', labels.xtitle))
    xlabel('Methods')
    ylabel('Sensitivity')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/sensitivity_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
    %For Other Cells
    fig2 = figure(2);
    set(fig2,'Position',[900, 300, 500, 500])
    for method = 1:nMethods
        if method == 1
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 8
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 9
            errorbar(yOC_norm_median(:, method), yOC_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        
%         %Summarize
%         Z = yOC_norm_median;
%         cellType = 2;
%         sensitivity = summarize(Z, cellType, nMethods, nParams);
        
    end
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titleOC);
    title(completeTitle)
    xlabel(labels.xtitle)
    ylabel(labels.ytitle)
    if useNames
        legend('RefQ', 'R2B', 'TI', 'C1', 'C2', 'PCA', 'SVM', 'DerQ1', 'DerQ2')
    else
        legend('RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'DerQ1', 'DerQ2')
    end
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/norm_linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
%     %Summary - Other Cells
%     fig5 = figure(5);
%     set(fig5,'Position',[900, 300, 500, 500])
%     X = sensitivity(:, 2);
%     bar(X,'BaseValue',0)
%     title(completeTitle)
%     xlabel('Methods')
%     ylabel('Sensitivity')
%     print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/sensitivity_Qvs', ...
%         labels.xtitle(~isspace(labels.xtitle)), ...
%         '-', ...
%         completeTitle(~isspace(completeTitle))), ...
%         '-dpng')
    
else
    %For Putative Time Cells
    fig1 = figure(1);
    set(fig1,'Position',[300, 300, 500, 500])
    %subplot(1, 2, 1)
    for method = 1:nMethods
        if method == 1
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 8
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 9
            errorbar(yPTC_median(:, method), yPTC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        
        %Summarize
        Z = yPTC_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams); 
    end
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    title(completeTitle)
    xlabel(labels.xtitle)
    ylabel(labels.ytitle)
    legend('RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'DerQ1', 'DerQ2')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
    %Summary - Putative Time Cells
    fig4 = figure(4);
    set(fig4,'Position',[300, 300, 900, 500])
    X = sensitivity(:, 1);
    bar(X,'BaseValue',0)
    %axis equal tight
    title(strcat(completeTitle, '-', labels.xtitle))
    xlabel('Methods')
    ylabel('Sensitivity')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/sensitivity_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
    %For Other Cells
    fig2 = figure(2);
    set(fig2,'Position',[900, 300, 500, 500])
    for method = 1:nMethods
        if method == 1
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 8
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 9
            errorbar(yOC_median(:, method), yOC_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        
        %Summarize
        Z = yOC_median;
        cellType = 2;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titleOC);
    title(completeTitle)
    xlabel(labels.xtitle)
    ylabel(labels.ytitle)
    legend('RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'DerQ1', 'DerQ2')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
    
%     %Summary - Other Cells
%     fig6 = figure(6);
%     set(fig6,'Position',[900, 300, 500, 500])
%     X = sensitivity(:, 2);
%     bar(X,'BaseValue',0)
%     title(completeTitle)
%     xlabel('Methods')
%     ylabel('Sensitivity')
%     print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/sensitivity_Qvs', ...
%         labels.xtitle(~isspace(labels.xtitle)), ...
%         '-', ...
%         completeTitle(~isspace(completeTitle))), ...
%         '-dpng')
end
end
