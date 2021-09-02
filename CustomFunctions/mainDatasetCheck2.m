function mainDatasetCheck2(dIndices, sdo_batch, figureDetails)
for di = dIndices
    fig1 = figure(1);
    set(fig1,'Position',[100, 100, 1500, 200])
    clf
    checkDataset(sdo_batch(di).syntheticDATA_2D(:, :), ...
        sprintf('All Trials | Dataset: %i', di), 'Frame Number', 'Cell Number', figureDetails, 0)
    print(sprintf('/Users/ananth/Desktop/figs/checkDataset/%i_check', di), '-dpng')
end