%Maybe this is silly, but I've decided to write out two separate functions
%to identify time cells (isTimeLockedCell.m), and
%to populate a list of the same (getTimeLockedCellList.m).
function timeLockedCells = getTimeLockedCellList(Data, nShuffles, identificationPrinciple, comparisonPrinciple, threshold, window, skipFrames)

fprintf('Total cells: %i\n', size(Data,1))
timeLockedCells = zeros(size(Data,1)); %preallocation

disp('Now, checking for time-locked cells ...')
fprintf('Identification Principle: %s; Comparison Principle: %s\n', ...
    identificationPrinciple, comparisonPrinciple)
fprintf('Threshold: %s\n',num2str(threshold))

if exist ('skipFrames', 'var')
    %NOTE: Data has 3 dimensions - Cells, Trials and Frames
    if skipFrames ~= 0
        Data(:,:,skipFrames) = [];
        %local modification:
        window(end) = [];
    end
end

for cell = 1:size(Data,1)
    if strcmp(identificationPrinciple,'AOC') || strcmp(identificationPrinciple, 'Peak')
        result = isTimeLockedCell(squeeze(Data(cell, :, :)), nShuffles, identificationPrinciple, comparisonPrinciple, threshold, window);
        %disp(['comparison: ' num2str(comparison)])
        if result
            timeLockedCells = 1;
        end
    else
        error('Unknown Identification Principle')
    end
    
    if (mod(cell, 10) == 0) && cell ~= size(Data,1)
        fprintf('... %i cells checked ...\n', cell)
    end
end
fprintf('%i time-locked cells found!\n', length(find(timeLockedCells)))
disp('... done!')

