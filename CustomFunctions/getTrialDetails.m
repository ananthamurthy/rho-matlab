function trialDetails = getTrialDetails(dataset)

%disp('Getting trial details ...')
trialDetails.nFrames = dataset.nFrames;

%trialDetails.frameRate          = round((dataset.nFrames/dataset.trialDuration),1);
trialDetails.frameRate          = dataset.samplingRate;
trialDetails.preDuration        = 8.0000; %in seconds
trialDetails.csDuration         = 0.0500; %in seconds
trialDetails.usDuration         = 0.0500; %in seconds

if strcmp(dataset.sessionType, 'All1') %No stimulus
    trialDetails.traceDuration = 0.2500; %in seconds
    
elseif strcmp(dataset.sessionType, 'All3') %No Puff
    trialDetails.traceDuration = 0.2500; %in seconds
    
elseif strcmp(dataset.sessionType, 'SoAn1') %250 ms trace
    trialDetails.traceDuration = 0.2500; %in seconds
    
elseif strcmp(dataset.sessionType, 'An1') %350 ms trace
    trialDetails.traceDuration = 0.3500; %in seconds
    
elseif strcmp(dataset.sessionType, 'An2') %450 ms trace
    trialDetails.traceDuration = 0.4500; %in seconds
    
elseif strcmp(dataset.sessionType, 'An3') %550 ms trace
    trialDetails.traceDuration = 0.5500; %in seconds
    
elseif strcmp(dataset.sessionType, 'An4') %650 ms trace
    trialDetails.traceDuration = 0.6500; %in seconds
    
elseif strcmp(dataset.sessionType, 'An5') %750 ms trace
    trialDetails.traceDuration = 0.7500; %in seconds
    
elseif dataset.sessionType == 5 %250 ms trace - legacy
    trialDetails.traceDuration = 0.4500; %in seconds
    
elseif dataset.sessionType == 9 %250 ms trace - legacy
    trialDetails.traceDuration = 0.2500; %in seconds
    
elseif dataset.sessionType == 11 %250 ms trace - legacy
    trialDetails.traceDuration = 0.4500; %in seconds
    
else
    warning('Unknown session type, using trace duration as 250 ms')
    trialDetails.traceDuration = 0.2500; %in seconds
end

trialDetails.postDuration = dataset.trialDuration - ...
    (trialDetails.preDuration + ...
    trialDetails.csDuration + ...
    trialDetails.traceDuration + ...
    trialDetails.usDuration); %in seconds

%disp('... done!')
end