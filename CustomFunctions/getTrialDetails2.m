function trialDetails = getTrialDetails2(dataset)

%disp('Getting trial details ...')
trialDetails.nFrames = dataset.nFrames;

%trialDetails.frameRate          = round((dataset.nFrames/dataset.trialDuration),1);
trialDetails.frameRate          = dataset.samplingRate;
trialDetails.preDuration        = 8.0000; %in seconds
trialDetails.csDuration         = 0.0500; %in seconds
trialDetails.usDuration         = 0.0500; %in seconds
trialDetails.traceDuration      = 0.4500; %in seconds
% trialDetails.postDuration       = dataset.trialDuration - ...
%                                     (trialDetails.preDuration + ...
%                                     trialDetails.csDuration + ...
%                                     trialDetails.traceDuration + ...
%                                     trialDetails.usDuration); %in seconds
trialDetails.postDuration       = 8.4500; %in seconds
%disp('... done!')
end