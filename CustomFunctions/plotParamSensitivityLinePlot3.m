function sensitivity = plotParamSensitivityLinePlot3(dIndices, normalize, labels, figureDetails, sdo_batch, cData, nMethods, nParams, useNames, plotPTC)

ptcList = sdo_batch(dIndices(1)).ptcList; %Putative Time Cells
ocList = sdo_batch(dIndices(1)).ocList; %Other Cells

%NOTE: nMethods includes the 6 along with the Reference, so totally 7
sensitivity = zeros(nMethods, 2);
C = distinguishable_colors(nMethods);

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
        elseif method == 4 %method C
            if plotPTC
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ptcList);
            else
                y(param, method, :) = cData.methodC.mCOutput_batch(dIndices(param)).Q2(ocList);
            end
        elseif method == 5 %method D
            if plotPTC
                y(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodD.mDOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 6 %method E
            if plotPTC
                y(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ptcList);
            else
                y(param, method, :) = cData.methodE.mEOutput_batch(dIndices(param)).Q(ocList);
            end
        elseif method == 7 %method F
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
        if method == 1
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(y_norm_median(:, method), y_norm_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        ylim([-0.2, 1.2])
        %For Summary plot
        Z = y_norm_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    axis tight
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    %title(completeTitle)
    xlabel(labels.xtitle)
    ylabel('Norm. Q')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/norm_linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
else
    fig1 = figure(1);
    set(fig1,'Position',[300, 300, 500, 500])
    %subplot(1, 2, 1)
    for method = 1:nMethods
        if method == 1
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 2
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 3
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 4
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 5
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 6
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        elseif method == 7
            errorbar(y_median(:, method), y_stddev(:, method), 'color', C(method, :), 'LineWidth', figureDetails.lineWidth, 'MarkerSize', figureDetails.markerSize);
            hold on
        else
            error('Unknown method')
        end
        ylim([-0.2, 1.2])
        
        %Summarize
        Z = y_median;
        cellType = 1;
        sensitivity = summarize(Z, cellType, nMethods, nParams);
    end
    axis tight
    %axis equal tight
    xticks([1 2 3 4 5 6 7 8 9 10])
    xticklabels(labels.xtickscell)
    completeTitle = strcat(labels.titleMain, '-', labels.titlePTC);
    %title(completeTitle)
    xlabel(labels.xtitle)
    ylabel('Norm. Q')
%     legend('RefQ', 'A', 'B', 'C1', 'C2', 'D', 'E', 'DerQ1', 'DerQ2')
    set(gca, 'FontSize', figureDetails.fontSize-2)
    hold off
    print(strcat('/Users/ananth/Desktop/figs/tcAnalysisPaper/linePlots_Qvs', ...
        labels.xtitle(~isspace(labels.xtitle)), ...
        '-', ...
        completeTitle(~isspace(completeTitle))), ...
        '-dpng')
end
end