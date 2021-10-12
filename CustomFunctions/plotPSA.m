function results3Line = plotPSA(nExpts, nShuffles, myList, mainBarplotTitle, figureDetails, sdo_batch, cData, input, valueList, algoLabels, metricLabels)

results3Line = zeros(input.nAlgos, nExpts);

for expt = 1:nExpts
    
    iStart = myList(expt);
    iSelected = iStart: (iStart + nShuffles -1);
    
    [Y, X] = developConfusionMatrix4Effects(input, sdo_batch, cData, iSelected);
    
    %[results1, results2, results3] = compareAgainstTruth(X, Y, input);
    [~, ~, results3] = compareAgainstTruth(X, Y, input);
    
    title([mainBarplotTitle, num2str(valueList(expt))], ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    
    %subplot(nExpts, 1, expt)
    b = bar(results3);
    xlim([0, 2])
    axis tight
    % title(sprintf('Performance Evaluation (N=%i)', input.nDatasets), ...
    %     'FontSize', figureDetails.fontSize, ...
    %     'FontWeight', 'bold')
    
    ylabel('Rate', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
    xticklabels(algoLabels)
    xtickangle(45)
    set(gca,'xtick',[])
    lgd = legend(metricLabels, ...
        'Location', 'best');
    lgd.FontSize = figureDetails.fontSize-3;
    set(gca, 'FontSize', figureDetails.fontSize)
    
    results3Line(:, expt) = results3(:, 3);
end
end