function plotHistograms(Z, nBins, labels, C, figureDetails)
    nMethods = size(Z, 2);
    
    labels = char(labels);
    for method = 1:nMethods
        subplot(3, 2, method)
        histogram(Z, nBins, ...
            'EdgeColor', C(method, :), ...
            'FaceColor', C(method, :))
        %xlim([-1, 1])
        title(sprintf('Method: %s', labels(method)))
        set(gca, 'FontSize', figureDetails.fontSize)
    end
end