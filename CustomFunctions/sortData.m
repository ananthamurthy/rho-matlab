% AUTHOR - Kambadur Ananthmurthy
function [sortedCells, peakIndices] = sortData(Data, normalizeCell2Max)

disp('Sorting data ...')
%sortedCells = zeros(size(Data,1),1); %preallocation
peakIndices = zeros(size(Data,1),1);
%nCells = size(Data,1);
%nTrials = size(Data,2);

% Trial average
Data_Avg = squeeze(mean(Data,2)); %2nd dimension is trials

if normalizeCell2Max
    for cell = 1:size(Data_Avg,1)
        Data_Avg(cell,:) = Data_Avg(cell,:)/max(Data_Avg(cell,:));
    end
end

% Sorting (based on Trial Averaged data)
if size(Data,1)>1
    for cell = 1:size(Data_Avg,1)
        [~, peakIndices(cell)] = max(Data_Avg(cell,:));
    end
    [~, sortedCells] = sort(peakIndices);
else
    %No real point of sorting, is there?
    [~, peakIndices] = max(Data_Avg);
    sortedCells = 1;
end

disp('... done!')
