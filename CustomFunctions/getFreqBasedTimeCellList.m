% AUTHOR - Kambadur Ananthmurthy
function [cellRastor, cellFrequency, timeLockedCells, importantTrials] ...
    = getFreqBasedTimeCellList(Data, selectedIndices, trialThreshold, skipFrames, delta)
%Develop Ca activity Frequency using threshold

%fprintf(['Total cells: %i\n', size(Data,1)])
disp('Now, checking for time-locked cells based on Event Frequency ...')
fprintf('Threshold (in number of trials): %i\n', trialThreshold)

%NOTE: 'Data' is organized as cells, trials, frames
%A = zeros(1,size(Data,3));
cellRastor = zeros(size(Data));
importantTrials = zeros(size(Data,1),size(Data,2));
cellFrequency = zeros(size(Data,1),size(Data,3)); %crucial
timeLockedCells = zeros(size(Data,1),1); %Important to initialize with "0"

for cell = 1:size(Data,1)
    if selectedIndices(cell) == 1
        for trial = 1:size(Data,2)
            %Get rid of CS artifact
            Data(cell,trial,skipFrames) = 0;
            
            if ~isempty(find(Data(cell,trial,:),1))
                importantTrials(cell,trial) = 1;
            end
            
            for frame = 1:size(Data,3)
                if Data(cell, trial, frame) > 0 %NOTE: the data should be significant-only
                    cellRastor(cell, trial, frame) = 1; % Rastor plot
                    cellFrequency(cell,frame) = cellFrequency(cell,frame)+1; %Frequency matrix
                end
            end
        end
        
        if (mod(cell, 10) == 0) && cell ~= size(Data,1)
            fprintf('... %i cells checked ...\n', cell)
        end
        
        %Identify time-locked cells based on activity on more than threshold
        %number of trials
        if ~isempty(find((cellFrequency(cell,:) >= trialThreshold),1))
            timeLockedCells(cell) = 1;
            %fprintf('Cell %i a time cell\n', cell)
            %fprintf('Max: %i\n', max(cellFrequency(cell,:)))
        else
            timeLockedCells(cell) = 0;
        end
    else
        timeLockedCells(cell) = 0;
    end
end
%fprintf('After first step, %i time-locked cells found\n', length(find(timeLockedCells)))
disp('... done!')