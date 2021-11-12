%% Physiology

N = 30;
count = 0;
% Noise
for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*1

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 30;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*2

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 60;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*3

%Event Width
for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {30, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*4

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {60, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*5

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {90, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*6

% Imprecision
for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*7

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 33;
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*8

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 66;
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*9

% Hit Trial Ratio
for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 33;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*10

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 66;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*11

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 99;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {70, 1};
    sdcp(count).eventAmplificationFactor = 1;
    sdcp(count).eventTiming = 'sequential';
    sdcp(count).startFrame = 75;
    sdcp(count).endFrame = 150;
    sdcp(count).imprecisionFWHM = 0;
    sdcp(count).imprecisionType = 'none';
    sdcp(count).noise = 'none';
    sdcp(count).noisePercent = 5;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*12