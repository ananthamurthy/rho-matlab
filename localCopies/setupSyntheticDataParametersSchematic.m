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
%%
i = 0;
%% Noise (Low vs High)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 42;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Event Widths (Small vs Large)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {10, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {90, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Imprecision (Low vs High)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 50;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Hit Trial Ratio

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 2;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 0;
sdcp(i).addBackgroundSpikes4oc = 0;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Background Activity
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 1;
sdcp(i).addBackgroundSpikes4oc = 1;
sdcp(i).backDistLambda = 0.5;
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 1;
sdcp(i).addBackgroundSpikes4oc = 1;
sdcp(i).backDistLambda = 2;
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Physiological Regime - Baseline
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 1;
sdcp(i).addBackgroundSpikes4oc = 1;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Physiological Regime - Higher Noise
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {60, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'uniform';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 42;
sdcp(i).randomseed = 'default';
sdcp(i).addBackgroundSpikes4ptc = 1;
sdcp(i).addBackgroundSpikes4oc = 1;
sdcp(i).backDistLambda = randi([2, 3], 1);
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)
