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
comment = 'anything you like'

Random Seed
rng('seed', 'generator')  %See help rng for details; Typically: 'default' or 'shuffle'
%}
%%
i = 0;

%% Noise
%1
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%2
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%3
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%4
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 15;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%5
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 15;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%6
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 15;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%7
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {100, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 15;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%8
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {100, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 30;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Event Width
%9
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {30, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%10
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {30, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%11
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {30, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%12
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {50, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%13
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {50, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%14
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {50, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%15
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%16
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%17
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%18
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {100, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Imprecision
%19
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 2;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%20
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 2;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%21
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 2;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%22
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 7;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%23
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 7;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%24
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 7;
sdcp(i).imprecisionType = 'normal';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%% Hit Trial Ratio
%25
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 33;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%26
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 33;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%27
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 33;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%28
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%29
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%30
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 66;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%31
i = i + 1;
sdcp(i).timeCellPercent = 1;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%32
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)

%33
i = i + 1;
sdcp(i).timeCellPercent = 100;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {70, 1};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 75;
sdcp(i).endFrame = 150;
sdcp(i).imprecisionFWHM = 0;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'none';
sdcp(i).noisePercent = 0;
sdcp(i).randomseed = 'default';
sdcp(i).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', i, sdcp(i).maxHitTrialPercent, sdcp(i).hitTrialPercentAssignment, sdcp(i).eventTiming);
rng(sdcp(i).randomseed)