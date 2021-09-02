function markROIs(stat,ops)

%Both stat and ops are stuctures.
%stat has details about the centroids
%ops has the mean reference image of the imaged plane.

%Populate centroid positions:
nCells = size(stat,2);
centroid = zeros(nCells,2);

for i = 1:nCells
    centroid(i,:) = stat(i).med;
end

labels = cellstr(num2str((1:nCells)'));

% fig9 = figure(9);
% set(fig9,'Position',[100,100,1800,750])
subplot(1,2,1)
% imagesc(ops.mimg)
% colormap(gray)
hold on;
plot(centroid(:,1), centroid(:,2), 'rx')
title('Mean Image')

subplot(1,2,2)
% imagesc(ops.mimg)
% colormap(gray)
hold on;
plot(centroid(:,1), centroid(:,2), 'rx')
text(centroid(:,1), centroid(:,2), labels, 'Color', 'red', 'FontSize', 14)%, 'VerticalAlignment', 'top')
title('Cell Indices')