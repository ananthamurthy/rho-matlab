%Written by Kambadur Ananthamurthy
function [frameIndex, pad] = selectFrameIndex(eventTiming, startFrame, endFrame, imprecisionFWHM, imprecisionType, frameGroup)

%What timing/frame to select?
if strcmpi(eventTiming, 'sequential')
    %Perfect sequence
    frameIndex = startFrame + (frameGroup - 1);
    %fprintf('frameIndex: %i\n', frameIndex)
elseif strcmpi(eventTiming, 'random')
    %randomized
    frameIndex = floor(rand()*(endFrame - startFrame)) + startFrame;
    %fprintf('frameIndex: %i\n', frameIndex)
end

%Add the effect of "imprecision"
if strcmpi(imprecisionType, 'uniform')
    pad = randi([0, (imprecisionFWHM)]) - (imprecisionFWHM/2);
elseif strcmpi(imprecisionType, 'normal')
    stddev = imprecisionFWHM/(2*sqrt(2*log(2))); %NOTE: In MATLAB, log() performs a natural log
    %pad = round(normrnd(0, stddev), 0); %Setting mean = 0
    pad = fix(normrnd(0, stddev)); %Setting mean = 0
elseif strcmpi(imprecisionType, 'none')
    pad = 0; %No imprecision
else
    error('Unable to develop "pad"')
end
%NOTE: The selected frame will be established by (frameIndex + pad),
%outside of this code

end