function h = giveHistograms(normPredictor)
for method = 1:input.nMethods
    ptcScores = normPredictor(response == 1, method);
    ocScores = normPredictor(response == 0, method);
    
    if method == 1
        subplotNum = 1;
    elseif method == 2
        subplotNum = 2;
    elseif method == 3
        subplotNum = 9;
    elseif method == 4
        subplotNum = 10;
    elseif method == 5
        subplotNum = 17;
    elseif method == 6
        subplotNum = 18;
    end
    
    subplot(16, 2, subplotNum)
    h = histogram(ptcScores, ...
        'EdgeColor', C(2, :), ...
        'FaceColor', C(2, :));
    %     ylabel('Counts', ...
    %         'FontSize', figureDetails.fontSize, ...
    %         'FontWeight', 'bold')
    hold off
    title(sprintf('Method - %s', char(methodLabels(method))), ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    %     if method == 3 || method == 6
    %         %do nothing
    %     elseif method == 4
    %         xlim([-0.5, 0.5])
    %     else
    %         xlim([0, 0.03])
    %     end
    lgd = legend({'Time Cells'}, ...
        'Location', 'best');
    lgd.FontSize = figureDetails.fontSize-3;
    set(gca, 'FontSize', figureDetails.fontSize)
    
    subplot(16, 2, subplotNum+4)
    histogram(ocScores, ...
        'EdgeColor', C(1, :), ...
        'FaceColor', C(1, :))
    ylabel('Counts', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    hold off
    if method == 5 || method == 6
        xlabel('Binned Norm. Scores', ...
            'FontSize', figureDetails.fontSize, ...
            'FontWeight', 'bold')
    end
    xlim([-0.02, 0.02])
    lgd = legend({'Other Cells'}, ...
        'Location', 'best');
    lgd.FontSize = figureDetails.fontSize-3;
    set(gca, 'FontSize', figureDetails.fontSize)
    
end
hold off
end