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
%% Parameter Sensitivity Analysis (PSA)
%Synthetic Data Parameters - Batch
N = 3;
count = 0;
%Sequential Timing
%PSA - Time cell percents with 'basic' order
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = value;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'basic';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Percent Time Cells: %i; Cell Order: %s; Event Timing: %s', count, value, sdcp(count).cellOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(1:10)

%PSA - Time cell percents with 'random' order
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = value;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'basic';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Percent Time Cells: %i; Cell Order: %s; Event Timing: %s', count, value, sdcp(count).cellOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(11:20)

%PSA - Max Hit Trial Percents with 'fixed' assignment
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = value;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'basic';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(21:30)

%PSA - Max Hit Trial Percents with 'random' assignment
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = value;
        sdcp(count).hitTrialPercentAssignment = 'random';
        sdcp(count).trialOrder = 'basic';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(31:40)

%PSA - Max Hit Trial Percents with 'fixed' assignment, 'random' trial order
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = value;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(41:50)

%PSA - Max Hit Trial Percents with 'random' assignment, 'random' trial order
for value = 10:10:100
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = value;
        sdcp(count).hitTrialPercentAssignment = 'random';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {100, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(51:60)

%PSA - Event Widths (percentiles)
for value = 10:10:70
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {value, 0};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Event Width (percentile): %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(61:67)

%PSA - Event Widths (percentiles) with standard deviations
for value = 10:10:70
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {value, 1};
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
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Event Width (percentile): %i (with stddev); Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(68:74)

%PSA - Uniform Imprecisions
for value = 1:2:20
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {100, 0};
        sdcp(count).eventAmplificationFactor = 1;
        sdcp(count).eventTiming = 'sequential';
        sdcp(count).startFrame = 75;
        sdcp(count).endFrame = 150;
        sdcp(count).imprecisionFWHM = value;
        sdcp(count).imprecisionType = 'uniform';
        sdcp(count).noise = 'none';
        sdcp(count).noisePercent = 10;
        sdcp(count).randomseed = 'shuffle';
        sdcp(count).addBackgroundSpikes4ptc = 0;
        sdcp(count).addBackgroundSpikes4oc = 0;
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Uniform ImprecisionFWHM: %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(75:84)

%PSA - Normal Imprecisions
for value = 1:2:20
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {100, 0};
        sdcp(count).eventAmplificationFactor = 1;
        sdcp(count).eventTiming = 'sequential';
        sdcp(count).startFrame = 75;
        sdcp(count).endFrame = 150;
        sdcp(count).imprecisionFWHM = value;
        sdcp(count).imprecisionType = 'normal';
        sdcp(count).noise = 'none';
        sdcp(count).noisePercent = 10;
        sdcp(count).randomseed = 'shuffle';
        sdcp(count).addBackgroundSpikes4ptc = 0;
        sdcp(count).addBackgroundSpikes4oc = 0;
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Normal ImprecisionFWHM: %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(85:94)

%PSA - Noise (only Gaussian type)
%for value = 10:10:100
for value = 10:10:50
    for shuffles = 1:N
        count = count + 1;
        sdcp(count).timeCellPercent = 50;
        sdcp(count).cellOrder = 'random';
        sdcp(count).maxHitTrialPercent = 100;
        sdcp(count).hitTrialPercentAssignment = 'fixed';
        sdcp(count).trialOrder = 'random';
        sdcp(count).eventWidth = {100, 0};
        sdcp(count).eventAmplificationFactor = 1;
        sdcp(count).eventTiming = 'sequential';
        sdcp(count).startFrame = 75;
        sdcp(count).endFrame = 150;
        sdcp(count).imprecisionFWHM = 0;
        sdcp(count).imprecisionType = 'none';
        sdcp(count).noise = 'gaussian';
        sdcp(count).noisePercent = value;
        sdcp(count).randomseed = 'shuffle';
        sdcp(count).addBackgroundSpikes4ptc = 0;
        sdcp(count).addBackgroundSpikes4oc = 0;
        sdcp(count).backDistLambda = 5;
        sdcp(count).comment = sprintf('%i | Noise Percent: %i; Trial Assignment: %s; Trial Order: %s; Event Timing: %s', count, value, sdcp(count).hitTrialPercentAssignment, sdcp(count).trialOrder, sdcp(count).eventTiming);
        rng(sdcp(count).randomseed)
    end
end
%N*(95:99)

%% Physiology

N = 10;
%count = 0;
% Noise
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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*100

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 40;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*101

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 70;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*102

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*103

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*104

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*105

% Imprecision
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
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*106

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
    sdcp(count).imprecisionFWHM = 33;
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*107

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
    sdcp(count).imprecisionFWHM = 66;
    sdcp(count).imprecisionType = 'normal';
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*108

% Hit Trial Ratio
for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 33;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {60, 1};
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
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*109

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
    sdcp(count).noise = 'gaussian';
    sdcp(count).noisePercent = 10;
    sdcp(count).randomseed = 'shuffle';
    sdcp(count).addBackgroundSpikes4ptc = 0;
    sdcp(count).addBackgroundSpikes4oc = 0;
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*110

for shuffles = 1:N
    count = count + 1;
    sdcp(count).timeCellPercent = 50;
    sdcp(count).cellOrder = 'random';
    sdcp(count).maxHitTrialPercent = 99;
    sdcp(count).hitTrialPercentAssignment = 'random';
    sdcp(count).trialOrder = 'random';
    sdcp(count).eventWidth = {60, 1};
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
    sdcp(count).backDistLambda = 5;
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*111