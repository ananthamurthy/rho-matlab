function plotSequences(dataset, Data, trialPhase, xtitle, ytitle,...
    figureDetails, normalizeCell2Max)

if size(Data,1)>1
    Data_Avg = squeeze(mean(Data,2)); %Averages across trials
    %Data_Avg = squeeze(mean(Data,1)); %Averages across cells
    if normalizeCell2Max
        for cell = 1:size(Data_Avg,1)
            Data_Avg(cell,:) = Data_Avg(cell,:)/max(Data_Avg(cell,:));
        end
    end
else
    Data_Avg = squeeze(mean(squeeze(Data),1));
end

imagesc(Data_Avg*100)
%plot(Data_Avg'*100)
title([dataset.mouse_name ' ST' ...
    num2str(dataset.sessionType) ' S' ...
    num2str(dataset.session) ' | ', ...
    trialPhase ' | Trial-Averaged'])
colorbar
z = colorbar;
caxis([0 100])
if normalizeCell2Max == 1
    ylabel(z,'Trial-Averaged Normalized dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
else
    ylabel(z,'Trial-Averaged dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
end
%xticks(xTicks)
%xticklabels(strcat(xLabels))
%xticklabels(xLabels)
xlabel(xtitle, ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
ylabel(ytitle, ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
set(gca,'FontSize', figureDetails.fontSize-2)