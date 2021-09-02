function eventLibrary_2D = curateLibrary(DATA_2D)

%Preallocation
nCells = size(DATA_2D, 1);
%nTrials = size(DATA, 2);
%nFrames = size(DATA, 3);

%Use real 2D data
cellMean = zeros(nCells, 1);
cellStddev = zeros(nCells, 1);
binaryData = zeros(nCells, 1);

%disp('Basic scan for calcium events ...')

%Preallocation
s.nEvents = 0;
s.eventStartIndices = [];
s.eventWidths = [];
eventLibrary_2D = repmat(s, 1, nCells);
clear s

nanList = zeros(nCells, 1);
for cell = 1:nCells
    sampledCellActivity = squeeze(DATA_2D(cell, :));
    
    %Lookout for NaNs
    if ~isempty(find(isnan(sampledCellActivity), 1))
        nanList(cell, 1) = 1;
        fprintf('Cell: %i got "NaN"s\n', cell)
    end
    
    cellMean(cell) = mean(sampledCellActivity);
    cellStddev(cell) = std(sampledCellActivity);
    logicalIndices = sampledCellActivity > (cellMean(cell) + 2* cellStddev(cell));
    binaryData(logicalIndices, 1) = 1;
    minNumberOf1s = 3;
    [nEvents, StartIndices, Width] = findConsecutiveOnes(binaryData, minNumberOf1s);
    eventLibrary_2D(cell).nEvents = nEvents;
    eventLibrary_2D(cell).eventStartIndices = StartIndices;
    eventLibrary_2D(cell).eventWidths = Width;
    
    clear binaryData
    clear Events
    clear StartIndices
    clear Lengths
end
end