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
                if startFrame ~= 1
                    shift = randi(startFrame);
                else
                    %shift = randi(round(nFrames/2)-1)+(nFrames/2); %right bias
                    shift = randi(nFrames-1);
                end
            elseif option == 1
                if endFrame ~= nFrames
                    shift = randi(nFrames - endFrame) + endFrame;
                else
                    %shift = randi(round(nFrames/2)-1); %left bias
                    shift = randi(nFrames-1);
                end
            end
            %fprintf('Cell: %i, Trial: %i, Option: %i, Shift: %i\n', cell, trial, option, shift)
            %numel(1:shift)
            randDATA(cell, trial, 1:shift) = DATA(cell, trial, (end - shift + 1):end);
            randDATA(cell, trial, shift:end) = DATA(cell, trial, 1:(end - shift +1));
        end
    end
end