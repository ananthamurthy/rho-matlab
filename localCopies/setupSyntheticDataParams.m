%NOTE: String arguments may be provided in uppercase, partial capitalization, or lowercase

%{
JUST FOR REFERENCE
% Synthetic Data Parameters
timeCellPercent = 50; %in %
cellOrder = 'basic'; %basic or random
maxHitTrialPercent = 100; %in %
hitTrialPercentAssignment = 'random'; %fixed or random
trialOrder = 'random'; %basic or random
eventWidth = {50, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
eventAmplificationFactor = 10;
eventTiming = 'sequential'; %sequential or random
startFrame = 116; %Try to leave a good set of frames (depending on sampling rate) as buffer
endFrame = 123; %Try to leave a good set of frames (depending on sampling rate) as buffer
imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
imprecisionType = 'uniform'; %Uniform, Normal, or None
noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
noisePercent = 20; %How much percent of noise to add
randomseed = 'shuffle'; %typically 'shuffle' or 'default'. See documentation for 'rng'
addBackgroundSpikes4ptc = 1;
addBackgroundSpikes4oc = 1;
backDistLambda = 5;
comment = 'anything you like';
Random Seed
rng('seed', 'generator')  %See help rng for details; Typically: 'default' or 'shuffle'
%}
%% Physiology (without Background Activity)

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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
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
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = unifrnd(0.8, 1.6);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*12