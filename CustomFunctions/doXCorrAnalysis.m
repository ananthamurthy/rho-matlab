%function [rVector, lagVector, rMatrix, lagMatrix] = doXCorrAnalysis(DATA)
function [rAll, lagAll, X] = doXCorrAnalysis(DATA)

nCells = size(DATA, 1);
nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

nDataPoints = (nTrials-1)*(nTrials/2);

rAll = zeros(nCells, nDataPoints);
lagAll = zeros(nCells, nDataPoints);

for cell = 1:nCells
    rCell = zeros(nDataPoints, 1);
    lagCell = zeros(nDataPoints, 1);
    %rCell = [];
    %lagCell = [];
    count = 1;
    for tx = 1:nTrials
        for ty = (tx+1):nTrials
            x = squeeze(DATA(cell, tx, :));
            y = squeeze(DATA(cell, ty, :));
            [r, lag] = xcorr(x, y, 'coeff');
            [val, ind] = max(r);
            rCell(count) = val;
            lagCell(count) = lag(ind);
            count = count + 1;
        end
    end
    rAll(cell, :) = rCell;
    lagAll(cell, :) = lagCell;
end
X(:, 1) = reshape(rAll, [], 1);
X(:, 2) = reshape(lagAll, [], 1);
%processedDataMatrix(:,1,:) = rAll;
%processedDataMatrix(:,2,:) = lagAll;


end

%{
%k-means clustering
[IDX, C] = kmeans(X, 2);

%Plots
figure;
plot(X(IDX==1,1),X(IDX==1,2),'r.','MarkerSize',12)
hold on
plot(X(IDX==2,1),X(IDX==2,2),'b.','MarkerSize',12)
plot(C(:,1),C(:,2),'kx',...
     'MarkerSize',15,'LineWidth',3)
%}