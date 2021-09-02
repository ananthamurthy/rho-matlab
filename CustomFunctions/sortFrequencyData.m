function [sortedCells, peakIndices] = sortFrequencyData(frequencyData)

disp('Sorting data ...')
%sortedCells = zeros(size(Data,1),1); %preallocation
peakIndices = zeros(size(frequencyData,1),1);

% Sorting (based on Trial Averaged data)
if size(frequencyData,1)>1
    for cell = 1:size(frequencyData,1)
        [~, peakIndices(cell)] = max(frequencyData(cell,:));
    end
    [~, sortedCells] = sort(peakIndices);
else
    %No real point of sorting, is there?
    [~, peakIndices] = max(frequencyData);
    sortedCells = 1;
end

disp('... done!')