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

    frameIndex = randi(nFrames); %Mostly all over the trial
    if (nFrames-frameIndex) >= length(event)
        backgroundActivityTrial(frameIndex:frameIndex+cellEvents.eventWidths(eventi), 1) = event;
    else
        backgroundActivityTrial(frameIndex:frameIndex+(nFrames-frameIndex), 1) = event(1:(nFrames-frameIndex)+1);
    end
end
end