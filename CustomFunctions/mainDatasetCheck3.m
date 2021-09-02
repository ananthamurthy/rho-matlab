function mainDatasetCheck3(dIndices, sdo_batch, figureDetails)
count = 0;
for di = dIndices
    count = count + 1;
    fig3 = figure(3);
    set(fig3,'Position',[100, 100, 1500, 1500])
    subplot(length(dIndices), 1, count)
    checkDataset(sdo_batch(di).syntheticDATA_2D(:, :), ...
        sprintf('All Trials | Dataset: %i', di), 'Frame Number', 'Cell Number', figureDetails, 0)
    if di == dIndices(end)
        xlabel('Frame Number', ...
            'FontSize', figureDetails.fontSize,...
            'FontWeight', 'bold')
        set(gca,'XTick', [2000, 4000, 6000, 8000, 10000, 120000, 140000]) %NOTE: Starting 5 frames are skipped
        set(gca,'XTickLabel', ({'2000', '4000', '6000', '8000', '10000', '120000', '140000'})) %NOTE: At 14.5 fps
    end
    
    if di == dIndices(floor(length(dIndices)/2))
        %set(gca,'YTick',[10, 20, 30, 40, 50, 60])
        %set(gca,'YTickLabel',({10; 20; 30; 40; 50; 60}))
        ylabel('Cell Number', ...
            'FontSize', figureDetails.fontSize,...
            'FontWeight', 'bold')
    end
    set(gca,'FontSize', figureDetails.fontSize-2)
    
end
print(sprintf('/Users/ananth/Desktop/figs/checkDataset/check_%i-%i', dIndices(1), dIndices(end)), '-dpng')
end