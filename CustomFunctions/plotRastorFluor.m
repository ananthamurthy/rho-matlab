function plotRastorFluor(cell, rastor, fluoData)
    subplot(2,1,1)
    imagesc(squeeze(rastor(11,:,:)));
    colormap('gray')
    title(sprintf('Rastor plot for cell %d', cell))
    xlabel('Frames')
    ylabel('Trials')
    
    subplot(2,1,2)
    imagesc(squeeze(fluoData(11,:,:))*100);
    %colorbar
    colormap('jet')
    title(sprintf('dF/F plot for cell %d', cell))
    xlabel('Frames')
    ylabel('Trials')
end