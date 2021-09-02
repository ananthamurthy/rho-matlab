%AUTHOR - Kambadur Ananthamurthy

function [consolidated_iTimeCells_loto, diff_nTimeCells, consolidated_TI_loto, diff_TI] = runLOTO(Data, freqThreshold, delta, allCells, skipFrames)
disp('Now using LOTO to find important trials ...')
lotoData = zeros(size(Data)); %done for every cell
%fprintf('... working on time cell %i\n', timeCell)
for trial2remove = 1:size(Data,2)
    fprintf('[INFO] LOTO trial2remove - %i\n', trial2remove)
    %preallocation
    lotoData = squeeze(Data); %crucial
    lotoData(:, trial2remove,:) = []; %crucial
    nTrials = size(lotoData,2);
    if nTrials ~= (size(Data,2)-1)
        error('Error with total trials using LOTO')
    end
    
    disp('LOTO; first filtering for percentage of trials with activity, then PSTH ...')
    [cellRastor_loto, cellFrequency_loto, timeLockedCells_temp_loto, importantTrials_loto] = ...
        getFreqBasedTimeCellList(lotoData, allCells, freqThreshold, skipFrames, delta);
    %iTimeCells_temp_loto = find(timeLockedCells_temp_loto);
    %Develop PSTH only for cells passing >25% activity
    [PSTH_loto, PSTH_3D_loto, nbins] = getPSTH(lotoData, delta, skipFrames);
    %Finally, identifying true time-locked cells, using the TI metric
    [timeLockedCells_loto, TI_loto] = getTimeLockedCells(PSTH_3D_loto, timeLockedCells_temp_loto, 1000, 99);
    iTimeCells_loto = find(timeLockedCells_loto); %Absolute indexing
    dfbf_timeLockedCells_loto = Data(iTimeCells_loto,:,:);
    fprintf('%i time-locked cells found\n', length(iTimeCells_loto))
    
    consolidated_TI_loto{trial2remove} = TI_loto;
    consolidated_iTimeCells_loto{trial2remove} = iTimeCells_loto;
end
%preallocation
diff_nTimeCells = zeros(size(Data,2),1);
diff_TI = zeros(size(Data,2), size(Data,1));
%Look for Differences
for trial = 1:size(Data,2) % trial is basically the trial2remove
    diff_nTimeCells(trial,:) = length(iTimeCells) - length(consolidated_iTimeCells_loto{1, trial});
    diff_TI(trial,:) = TI - consolidated_TI_loto{1, trial};
end
disp('... done!')
end