function backgroundActivityTrial = generateBackgroundActivity(cellRec, cellEvents, control, nFrames)

%Preallocate
backgroundActivityTrial = zeros(nFrames, 1);

%How many Background or Spurious Events to add?
nBackgroundEvents = poissrnd(control.backDistLambda);
for backi = 1:nBackgroundEvents
    %Select event
    eventi = randi(cellEvents.nEvents);
    clear event %for sanity
    event = cellRec(cellEvents.eventStartIndices(eventi): cellEvents.eventStartIndices(eventi) + cellEvents.eventWidths(eventi));

    %if ~isHitTrial
    %frameIndex = floor(rand()*(control.endFrame - control.startFrame)) + control.startFrame; %Only during stim window
    frameIndex = randi(nFrames-21); %Mostly all over the trial. Leaving a bit at the end just in case a really wide event is inserted right at the end.
    if (nFrames-frameIndex) > length(event)
        backgroundActivityTrial(frameIndex:frameIndex+cellEvents.eventWidths(eventi), 1) = event;
    else
        %Skipping
    end
    %else
    %end
end
end