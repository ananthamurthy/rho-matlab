function window = findWindow(trialPhase, trialDetails)

%disp('Finding window for analysis ...')

if strcmp(trialPhase, 'Pre')
    On = 1;
    Off = floor(trialDetails.preDuration ...
        * trialDetails.frameRate);
    
elseif strcmp(trialPhase,'CS')
    On = floor(trialDetails.preDuration ...
        * trialDetails.frameRate) + 1;
    Off = On + floor(trialDetails.csDuration * trialDetails.frameRate);
    
elseif strcmp(trialPhase, 'Trace')
    On = floor((trialDetails.preDuration + trialDetails.csDuration) ...
        * trialDetails.frameRate) + 1;
    Off = On + floor(trialDetails.traceDuration * trialDetails.frameRate);
    
elseif strcmp(trialPhase, 'US')
    On = floor((trialDetails.preDuration + ...
        trialDetails.csDuration + ...
        trialDetails.traceDuration) ...
        * trialDetails.frameRate) + 1;
    Off = On + floor(trialDetails.usDuration * trialDetails.frameRate);
    
elseif strcmp(trialPhase, 'Post')
    On = floor((trialDetails.preDuration + ...
        trialDetails.csDuration + ...
        trialDetails.traceDuration + ...
        trialDetails.usDuration) ...
        * trialDetails.frameRate) + 1;
    Off = On + floor(trialDetails.postDuration * trialDetails.frameRate);
    
elseif strcmp(trialPhase, 'CS-Trace-US')
    On = floor((trialDetails.preDuration ...
        * trialDetails.frameRate) + 1);
    Off = On + floor((trialDetails.csDuration + ...
        trialDetails.traceDuration + ...
        trialDetails.usDuration) ...
        * trialDetails.frameRate) + 1;
    
elseif strcmp(trialPhase, 'Trace-US')
    On = floor(((trialDetails.preDuration + trialDetails.csDuration) ...
        * trialDetails.frameRate) + 1);
    Off = On + floor((trialDetails.traceDuration + trialDetails.usDuration) ...
        * trialDetails.frameRate) + 1;
    
elseif strcmp(trialPhase, 'wholeTrial')
    On = 1; %hard
    Off = trialDetails.nFrames;
    
else
    warning('Unknown trial phase')
end

window = On:Off;

disp('... done!')