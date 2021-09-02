% AUTHOR - Kambadur Ananthmurthy
function [sortedPSTHindices, peakIndices] = sortPSTH(Data)
peakIndices = zeros(size(Data,1),1);

% Sorting (based on Trial-Summed data)
if size(Data,1)>1
    for cell = 1:size(Data,1)
        [~, peakIndices(cell)] = max(Data(cell,:));
    end
    [~, sortedPSTHindices] = sort(peakIndices, 'ascend');
else
    %No real point of sorting, is there?
    [~, peakIndices] = max(Data);
    sortedPSTHindices = 1;
end
end