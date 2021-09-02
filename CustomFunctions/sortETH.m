% AUTHOR - Kambadur Ananthmurthy
function [sortedETHindices, peakIndices] = sortETH(ETH)
peakIndices = zeros(size(ETH,1),1);

% Sorting (based on Trial-Summed data)
if size(ETH,1)>1
    for cell = 1:size(ETH,1)
        [~, peakIndices(cell)] = max(ETH(cell,:));
    end
    [~, sortedETHindices] = sort(peakIndices, 'ascend');
else
    %No real point of sorting, is there?
    [~, peakIndices] = max(ETH);
    sortedETHindices = 1;
end
end