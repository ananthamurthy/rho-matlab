function largeEvents = detectLargeEvents(Data)
%Preallocation
%largeEvents.trials = [];
trialRastor = zeros(1, size(Data,3),1);
signal = ones(1,15);

for cell = 1:size(Data,1)
    for trial = 1:size(Data,2)
        %Generate threshold
        trialThreshold = mean(Data(cell, trial, :) + 2*std(Data(cell, trial, :)));
        for frame = 1:size(Data,3)
            if Data(cell, trial, frame) >= trialThreshold
                %disp('Threshold crossed')
                trialRastor(1,frame) = 1;
            else
                trialRastor(1,frame) = 0;
            end
        end
        largeEvents.trialRastor(trial,:) = trialRastor;
        %String Search
        %fprintf('trial rastor -> %d\n', trialRastor)
        check = strfind(trialRastor, signal);
        %disp(check)
        if ~isempty(check)
            %disp('Large event detected')
            largeEvents.frames{trial} = check;
        end
    end
end