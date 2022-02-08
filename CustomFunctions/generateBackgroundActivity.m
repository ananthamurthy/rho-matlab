function backgroundActivityTrial = generateBackgroundActivity(cellRec, cellEvents, control, nFrames)

%Preallocate
backgroundActivityTrial = zeros(nFrames, 1);

%Select event
eventi = randi(cellEvents.nEvents);
%clear event %for sanity
event = cellRec(cellEvents.eventStartIndices(eventi): cellEvents.eventStartIndices(eventi) + cellEvents.eventWidths(eventi));

%How many Background or Spurious Events to add?
nBackgroundEvents = poissrnd(5);
for backi = 1:nBackgroundEvents
    %if ~isHitTrial
    frameIndex = floor(rand()*(control.endFrame - control.startFrame)) + control.startFrame;
    backgroundActivityTrial(frameIndex:frameIndex+cellEvents.eventWidths(eventi), 1) = event;
    %else
    %end
end
end