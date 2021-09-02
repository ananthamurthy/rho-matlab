%NOTE: make sure to define "cell"
function plotCell_Analysis(cell, trialPhase, cellRastor, dfbf_sigOnly, cellFrequency, AUC, MAX_value, MAX_index, importantTrials, fontSize, lineWidth)
    clf
    onlyImportantTrials = importantTrials;
    onlyImportantTrials(onlyImportantTrials==0) = nan;
    
    subFig1 = subplot(2,2,1);
    imagesc(squeeze(dfbf_sigOnly(cell,:,:))*100);
    c1 = colorbar;
    ylabel(c1,'dF/F (%)', 'FontSize', fontSize)
    %c1.Limits = [0 100];
    colormap(subFig1, 'cool')
    ylabel('Trials', 'FontSize', fontSize)
    title(sprintf('Activity | Cell %d | %s', cell, trialPhase), 'FontSize', fontSize)
    xlabel('Frames', 'FontSize', fontSize)
    
    %subFig2 = subplot(2,2,2);
    subplot(2,2,2)
    yyaxis left
    %activity = sum(dfbf_sigOnly,2);
    activity = mean(dfbf_sigOnly,2);
    plot(squeeze(activity(cell,:)*100), 'LineWidth', lineWidth)
    ylabel('Mean Activity (dF/F in %)','FontSize', fontSize) 
    hold on
    yyaxis right
    plot(squeeze(cellFrequency(cell,:)), 'LineWidth', lineWidth)
    ylabel('Number of Trials','FontSize', fontSize)
    %legend
    legend({'Mean Fluorescence Activity', 'Sum of Significant Events'}, 'Location', 'northwest')
    title(sprintf('Tuning Curve | Cell %d', cell), 'FontSize', fontSize)
    xlabel('Frames','FontSize', fontSize)
    
    subFig3 = subplot(2,2,3);
    imagesc(squeeze(cellRastor(cell,:,:)));
    c3 = colorbar;
    ylabel(c3,'Significant Event?', 'FontSize', fontSize)
    set(c3,'YTick',[0, 1])
    set(c3, 'YTickLabel', {'No', 'Yes'})
    colormap(subFig3, 'gray')
    ylabel('Trials','FontSize', fontSize)
    title(sprintf('Rastor | Cell %d', cell), 'FontSize', fontSize)
    xlabel('Frames','FontSize', fontSize)
    
    %subFig4 = subplot(2,2,4);
    subplot(2,2,4)
    plot(AUC(cell,:), 'blue', 'LineWidth', lineWidth)
    hold on
    %plot(squeeze(importantTrials(cell,:))*max(AUC(cell,:)), 'r*')
    plot(squeeze(onlyImportantTrials(cell,:)), 'r*')
    ylabel('AUC (A.U.)', 'FontSize', fontSize)
    title(sprintf('Area Under Curve | Cell %d', cell),'FontSize', fontSize)
    xlabel('Trials', 'FontSize', fontSize)
    camroll(-270)
    %set(gca,'ydir','reverse')
    %view([90 -90])
    legend({'AUC', 'Important Trial'}, 'Location', 'north')
    
%     subplot(2,3,5)
%     yyaxis left
%     plot(MAX_index(cell,:), 'LineWidth', lineWidth-1)
%     ylabel('Frame Number', 'LineWidth', lineWidth)
%     yyaxis right
%     plot(MAX_value(cell,:), 'LineWidth', lineWidth)
%     ylabel('dF/F', 'LineWidth', lineWidth)
%     title('Max dF/F', 'FontSize', fontSize)
%     xlabel('Trials', 'FontSize', fontSize)
%     legend('Frame with Max', 'Value of Max')
%     
%     subplot(2,3,6)
%     title('Reliability', 'FontSize', fontSize)
end
%cellRastor, cellFrequency, timeLockedCells, importantTrials