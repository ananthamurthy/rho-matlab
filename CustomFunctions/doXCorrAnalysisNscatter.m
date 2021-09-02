function [rMatrix, lagMatrix, rCells_var, lagCells_var] = doXCorrAnalysisNscatter(DATA)

nCells = size(DATA, 1);
nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

rMatrix = nan(nCells, nTrials, nTrials);
lagMatrix = nan(nCells, nTrials, nTrials);

%count = 0;
for cell = 1:nCells
    rCell = [];
    lagCell = [];
    for tx = 1:nTrials
        for ty = (tx+1):nTrials
            x = squeeze(DATA(cell, tx, :));
            y = squeeze(DATA(cell, ty, :));
            [r, lag] = xcorr(x, y, 'coeff');
            [val, ind] = max(r);
            rMatrix(cell, tx, ty) = val;
            lagMatrix(cell, tx, ty) = lag(ind);
            rCell = [rCell val];
            lagCell = [lagCell lag(ind)];
        end
    end
    rCells_var(cell) = var(rCell);
    lagCells_var(cell) = var(lagCell);
%     figure()
%     scatter(rCell, lagCell)
%     title(['Cell' num2str(cell)], ...
%         'FontSize', 16, ...
%         'FontWeight', 'bold')
%     
%     xlabel('Max Cross-Correlation', ...
%         'FontSize', 16, ...
%         'FontWeight', 'bold')
%     
%     ylabel('Lag (frames)', ...
%         'FontSize', 16, ...
%         'FontWeight', 'bold')
%     set(gca, 'FontSize', 15)
%     print(['/Users/ananth/Desktop/DataScat/Cell' num2str(cell)], ...
%         '-djpeg')
    %rCell_avg(cell) = mean(rCell);
    %lagCell_avg(cell) = mean(lagCell);
%     count = count + 1;
%     if count == 7
%         scatter(rCell, lagCell, 'k.')
%         hold on
%         count = 0;
%     elseif count == 1
%         scatter(rCell, lagCell, 'b.')
%         hold on
%     elseif count == 2
%         scatter(rCell, lagCell, 'g.')
%         hold on
%     elseif count == 3
%         scatter(rCell, lagCell, 'r.')
%         hold on
%     elseif count == 4
%         scatter(rCell, lagCell, 'c.')
%         hold on
%     elseif count == 5
%         scatter(rCell, lagCell, 'm.')
%         hold on
%     elseif count == 6
%         scatter(rCell, lagCell, 'y.')
%         hold on
%     end
%     clear rCell
%     clear lagCell
end
% colors = linspace(0, 1, length(rCell_avg));
% 
% scatter(rCell_avg, lagCell_avg, [], colors);
% title('All Cells', ...
%     'FontSize', 16, ...
%     'FontWeight', 'bold')
% 
% xlabel('Max Cross-Correlation', ...
%     'FontSize', 16, ...
%     'FontWeight', 'bold')
% 
% ylabel('Lag(frames)', ...
%     'FontSize', 16, ...
%     'FontWeight', 'bold')
% set(gca, 'FontSize', 15)
%rVector = reshape(rMatrix, [], 1);
%lagVector = reshape(lagMatrix, [], 1);

end

%{
b     blue
g     green
r     red
c     cyan
m     magenta
y     yellow
k     black
%}