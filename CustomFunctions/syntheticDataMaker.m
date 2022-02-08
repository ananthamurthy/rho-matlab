%syntheticDataMaker
%Written by Kambadur Ananthamurthy
function output = syntheticDataMaker(dataset, DATA_2D, eventLibrary_2D, control)

%disp('Creating synthetic data ...')

%Preallocation
nCells = size(DATA_2D,1);
nTrials = dataset.nTrials;
nFrames = dataset.nFrames;
syntheticDATA = zeros(nCells, nTrials, nFrames);
syntheticDATA_2D = zeros(nCells, nTrials*nFrames);
backgroundActivity = zeros(nCells, nTrials, nFrames);
noiseComponent = zeros(nCells, nFrames);
recordingNoise = zeros(nCells, nTrials, nFrames);
eventMax = zeros(nCells, nTrials);
maxSignal = zeros(nCells, 1);

%Which cells to select?
nPutativeTimeCells = floor((control.timeCellPercent/100) * nCells);
%nOtherCells = nCells - nPutativeTimeCells;
%fprintf('... Number of Putative Time Cells: %i\n', nPutativeTimeCells)
%fprintf('... Number of Other Cells: %i\n', nOtherCells)
if nPutativeTimeCells ~= 0
    if strcmpi(control.cellOrder, 'basic')
        ptcList = 1:nPutativeTimeCells;
        ocList = (nPutativeTimeCells+1):nCells;
    elseif strcmpi(control.cellOrder, 'random')
        ptcList = randperm(nCells, nPutativeTimeCells);
        ocList = 1:nCells;
        ocList(ptcList) = [];
    else
        error('Unknown Cell Order')
    end
else
    ptcList = [];
    ocList = 1:nCells;
end

eventWidthRangeInFrames = zeros(nCells, 2);
allEventWidths = zeros(nCells, nTrials);
eventWidthRangeInSD = zeros(nCells, 1);
hitTrials = zeros(nCells, nTrials);
hitTrialPercent = zeros(nCells, 1);

frameIndex = nan(nCells, nTrials);
pad = zeros(nCells, nTrials);

for cell = 1:nCells
    %For Putative Time Cells
    if ismember(cell, ptcList)
        if strcmpi(control.hitTrialPercentAssignment, 'fixed')
            hitTrialPercent(cell) = control.maxHitTrialPercent;
        elseif strcmpi(control.hitTrialPercentAssignment, 'random')
            hitTrialPercent(cell) = randi([floor(control.maxHitTrialPercent/2), control.maxHitTrialPercent]); % Ensures that the range of Hit Trial Percent is within [max/2, max]
            %hitTrialPercent(cell) = randi(sdcp.maxHitTrialPercent);
        else
            error('Unknown sdcp.hitTrialPercentAssignment')
        end
        
        %What trials to select?
        nHitTrials = floor((hitTrialPercent(cell)/100) * nTrials);
        if strcmpi(control.trialOrder, 'basic')
            hitTrials(cell, 1:nHitTrials) = 1;
        elseif strcmpi(control.trialOrder, 'random')
            hitTrials(cell, 1) = 1;
            hitTrials(cell, randperm(nTrials, (nHitTrials-1))) = 1;
        else
            error('Unknown sdcp.trialOrder')
        end
        
        %What range of calcium events to select?
        value = control.eventWidth{1};
        multiplier = control.eventWidth{2};
        try
            vector = eventLibrary_2D(cell).eventWidths;
        catch
            %fprintf('Cell: %i has trouble with event widths\n', cell);
        end
        eventWidthRangeInSD(cell) = multiplier * std(vector);
        eventWidthRangeInFrames(cell, 1) = prctile(vector, value) - eventWidthRangeInSD(cell); % Min
        eventWidthRangeInFrames(cell, 2) = prctile(vector, value) + eventWidthRangeInSD(cell); % Max
        
        %This section is only important for the sequential case
        %Here we need to define which frame each cell gets targetted to
        if strcmpi(control.eventTiming, 'sequential')
            nGroups = control.endFrame - control.startFrame;
            if length(ptcList) >= nGroups
                nCellsPerFrame = floor(length(ptcList)/nGroups);
                frameGroup = ceil(find(ptcList == cell)/nCellsPerFrame);
            else
                frameGroup = cell; %uses the cell index
            end
        else
            frameGroup = 0;
        end
        
        for trial = 1:nTrials
            %fprintf('>>> Dataset: %i, Cell: %i, Trial: %i ...\n', runi, cell, trial)
            eventIndices = [];
            if hitTrials(cell, trial) == 1
                if control.eventWidth{2} == 0
                    eventIndices = find(eventLibrary_2D(cell).eventWidths == eventWidthRangeInFrames(cell, 1)); %equivalently, eventWidthRangeInFrames(cell, 2)
                elseif control.eventWidth{2} ~= 0
                    eventIndices = find((eventLibrary_2D(cell).eventWidths >= eventWidthRangeInFrames(cell, 1)) & ...
                        (eventLibrary_2D(cell).eventWidths <= eventWidthRangeInFrames(cell, 2)));
                else
                    %eventIndices = [];
                end
                %fprintf('>>>>>> Hit trial; %i suitable event(s) found ...\n', length(eventIndices))
                
                if isempty(eventIndices)
                    %warning('>>>>>>>>> Continuing to next cell ...\n');
                    hitTrials(cell, trial) = 0; %assertion
                    break
                end
                [selectedEventIndex, eventStartIndex] = randomlyPickEvent(eventIndices, eventLibrary_2D, cell);
                
                clear event %For sanity
                %Now, we pick out exactly one event per trial
                event = DATA_2D(cell, eventStartIndex:1:eventStartIndex+eventLibrary_2D(cell).eventWidths(selectedEventIndex) - 1);
                
                allEventWidths(cell, trial) = length(event);
                %fprintf('Dataset: %i, Cell: %i, Trial: %i, Event Width: %i\n', runi, cell, trial, length(event))
                
                %disp('Selecting the Frame Index ...')
                [frameIndex(cell, trial), pad(cell, trial)] = selectFrameIndex(control.eventTiming, control.startFrame, control.endFrame, control.imprecisionFWHM, control.imprecisionType, frameGroup);
                %fprintf('For cell: %i, trial: %i, the frameIndex is %i and the pad is %i\n', cell, trial, frameIndex(cell, trial), pad(cell, trial))
                
                [eventMax(cell, trial), I] = max(event);
                %Prune trial lengths, if necessary
                tailClip = (frameIndex(cell, trial) + pad(cell, trial)) + length(event) - 1 - nFrames;
                
                if tailClip > 0
                    %fprintf('tail-clip: %i\n', tailClip)
                    %remove a tailClip number of frames from the end of the
                    %event before insertion (by replacement)
                    syntheticDATA(cell, trial, ((frameIndex(cell, trial) + pad(cell, trial)) - I :((frameIndex(cell, trial) + (pad(cell, trial)) - I + length(event)) - 1 - tailClip))) = event(1:(length(event) - tailClip)) * control.eventAmplificationFactor;
                else
                    if ~isinteger(pad(cell, trial))
                        pad(cell, trial) = round(pad(cell, trial));
                    end
                    
                    try
                        %directly insert the event (by replacement)
                        syntheticDATA(cell, trial, ((frameIndex(cell, trial)+ pad(cell, trial)) - I :(frameIndex(cell, trial) + (pad(cell, trial)) - I + length(event) - 1))) = event * control.eventAmplificationFactor;
                    catch
                        warning('Cannot insert event as Pad: %d', pad(cell, trial))
                    end
                end
                %fprintf('syntheticDATA trial length: %i\n', length(syntheticDATA(cell, trial, :)))
                %fprintf('Event added to cell:%i, trial:%i at frame:%i\n', cell, trial, (frameIndex(cell, trial)+ pad (cell, trial)))
                
                clear eventIndices
                clear eventStartIndex
                clear event
                clear tailClip
                %disp(frameIndex(cell, trial) + pad(cell, trial))
                
            elseif hitTrials(cell, trial) == 0 % For Non-Hit Trials
                allEventWidths(cell, trial) = 0;
                %disp('>>>>>> Miss trial ...')
            else
                error('Unknown case for hitTrial')
            end
        end
        
    elseif ismember(cell, ocList) % For Other Cells
        allEventWidths(cell, :) = 0;
        %fprintf('>>>>>> Cell: %i is not a putative time cell ...\n', cell)
    else
        error('Unknown nature of cell')
    end
    %ht = find(hitTrials(cell, :));
    %mEW = nanmean(allEventWidths(cell, ht));
    %sdEW = nanstd(allEventWidths(cell, ht));
    %sdbymEW = sdEW/mEW;
    %fprintf('>>>>>>>>> Dataset: %i, Cell: %i, Mean EW: %.4f, Stddev EW: %.4f, Stddev/Mean: %.4f\n', runi, cell, mEW, sdEW, sdbymEW)
    
    maxSignal(cell) = max(eventMax(cell, :));
    %fprintf('Max signal value for cell:%i is %d\n', cell, maxSignal(cell))
end

% Background (Spurious) Activity
if control.addBackgroundSpikes4ptc == 1
    for celli = 1:length(ptcList)
        cell = ptcList(celli);
        
        for trial = 1:nTrials
            backgroundActivity(cell, trial, :) = generateBackgroundActivity(DATA_2D(cell, :), eventLibrary_2D(cell), control, nFrames); % A trial's worth
        end
        syntheticDATA(cell, :, :) = syntheticDATA(cell, :, :) + backgroundActivity(cell, :, :);
    end
end

if control.addBackgroundSpikes4oc == 1
    for celli = 1:length(ocList)
        cell = ocList(celli);
        
        for trial = 1:nTrials
            backgroundActivity(cell, trial, :) = generateBackgroundActivity(DATA_2D(cell, :), eventLibrary_2D(cell), control, nFrames); % A trial's worth
        end
        syntheticDATA(cell, :, :) = syntheticDATA(cell, :, :) + backgroundActivity(cell, :, :); %(cell, trial, frame)
    end
end

% Noise
%if ~strcmpi(control.noise, 'none')
if control.noisePercent ~= 0
    %for cell = 1:nCells
    for celli = 1:length(ptcList)
        cell = ptcList(celli);
        
        %disp(cell)
        for trial = 1:nTrials
            ceil2zero = 0;
            % Generate noise
            recordingNoise(cell, trial, :) = squeeze(generateNoise(maxSignal(cell), control.noise, control.noisePercent, nFrames, ceil2zero));
        end
        % Add noise
        syntheticDATA(cell, :, :) = syntheticDATA(cell, :, :) + recordingNoise(cell, :, :); %(cell, trial, frame)
    end
    
    for celli = 1:length(ocList)
        cell = ocList(celli);
        
        %Randomly choose a Putative Time Cell to copy background
        selectedCellOption = ptcList(randperm(length(ptcList), 1));
        recordingNoise(cell, :, :) = recordingNoise(selectedCellOption, :, :);
        
        %Add noise
        syntheticDATA(cell, :, :) = syntheticDATA(cell, :, :) + recordingNoise(cell, :, :); %(cell, trial, frame)
    end
end

% %Ceil negative values to 0.
% disp('Ceiling negative values to 0 ...')
% syntheticDATA(syntheticDATA<0) = 0;
% disp('... done!')

%mustBeNonnegative(syntheticDATA)

%2D Synthetic Data
for cell = 1:nCells
    syntheticDATA_2D(cell, :) = reshape(squeeze(syntheticDATA(cell, :, :))', 1, []);
end

%Setup output structure
output.syntheticDATA = syntheticDATA;
output.syntheticDATA_2D = syntheticDATA_2D;
output.maxSignal = maxSignal;
output.ptcList = ptcList;
output.ocList = ocList;
output.nCells = nCells;
output.actualEventWidth = eventWidthRangeInFrames;
output.allEventWidths = allEventWidths;
output.hitTrialPercent = hitTrialPercent;
output.hitTrials = hitTrials;
output.frameIndex = frameIndex;
output.pad = pad;
output.noiseComponent = noiseComponent;

%Lookout for "NaN"s
input.nCells = nCells;
input.dataDesc = 'Synthetic Data';
input.dimensions = '2D';
nanList = lookout4NaNs(syntheticDATA_2D, input);
output.nanList = nanList;

% %Populated elsewhere
% output.scurr = {};
% output.Q = [];
% output.T = [];
% output.endtime = '';

%disp('... done!')
end