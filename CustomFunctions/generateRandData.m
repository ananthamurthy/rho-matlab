function randDATA = generateRandData(DATA, controls)
    nCells = size(DATA, 1);
    nTrials = size(DATA, 2);
    nFrames = size(DATA, 3);
    
    startFrame = controls.startFrame; %beginning of stimulus window
    endFrame = controls.endFrame; %end of stimulus window
    
    randDATA = nan(size(DATA));
    for cell = 1:nCells
        for trial = 1:nTrials
            option = round(rand);
            if option == 0
                shift = randi(startFrame);
            elseif option == 1
                shift = randi(nFrames - endFrame) + endFrame;
            end
            %fprintf('Cell: %i, Trial: %i, Option: %i, Shift: %i\n', cell, trial, option, shift)
            %numel(1:shift)
            randDATA(cell, trial, 1:shift) = DATA(cell, trial, (end - shift + 1):end);
            randDATA(cell, trial, shift:end) = DATA(cell, trial, 1:(end - shift +1));
        end
    end
end