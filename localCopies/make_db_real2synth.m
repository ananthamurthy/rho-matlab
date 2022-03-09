%disp('Establishing dataset details ...')
i = 0;
i = i+1; %1
db(i).mouseName    = 'M26';
db(i).date          = '20180514';
db(i).isDayOne      = 0; %1 - Yes; 0 - No
db(i).sessionType   = 5;
db(i).session       = 4;
db(i).diameter      = 8;
db(i).scanAmplitude = '1.8V';
db(i).nFrames       = 246;
db(i).samplingRate  = 14.47; %Hz
db(i).nTrials       = 60; %usable trials
db(i).comments      = 'TEC: 500 ms ISI';
db(i).trialDuration = 17; %in seconds
db(i).expts         = 1;
db(i).nplanes       = 1;
db(i).gchannel      = 1;
db(i).nplanes       = 1;
db(i).expred        = [];
db(i).nchannels_red = 0;
%% END
%disp ('... done!')