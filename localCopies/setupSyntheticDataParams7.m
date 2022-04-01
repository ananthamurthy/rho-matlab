%% Physiology without Background Activity

N = 3;
count = 0;
% % Noise
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*1
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 40;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*2
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 70;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*3
% 
% %Event Width
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {30, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*4
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*5
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {90, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*6
% 
% % Imprecision
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'normal';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*7
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 33;
%     sdcp(count).imprecisionType = 'normal';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*8
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 66;
%     sdcp(count).imprecisionType = 'normal';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*9
% 
% % Hit Trial Ratio
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 33;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*10
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 66;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
% %N*11
% 
% for shuffles = 1:N
%     count = count + 1;
%     sdcp(count).timeCellPercent = 50;
%     sdcp(count).cellOrder = 'random';
%     sdcp(count).maxHitTrialPercent = 99;
%     sdcp(count).hitTrialPercentAssignment = 'random';
%     sdcp(count).trialOrder = 'random';
%     sdcp(count).eventWidth = {60, 1};
%     sdcp(count).eventAmplificationFactor = 1;
%     sdcp(count).eventTiming = 'sequential';
%     sdcp(count).startFrame = 75;
%     sdcp(count).endFrame = 150;
%     sdcp(count).imprecisionFWHM = 0;
%     sdcp(count).imprecisionType = 'none';
%     sdcp(count).noise = 'gaussian';
%     sdcp(count).noisePercent = 10;
%     sdcp(count).randomseed = 'shuffle';
%     sdcp(count).addBackgroundSpikes4ptc = 0;
%     sdcp(count).addBackgroundSpikes4oc = 0;
%     sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
%     sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
%     rng(sdcp(count).randomseed)
% end
%N*12

%% Physiology with Background Activity

%N = 10;
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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*13

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*14

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*15

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*16

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*17

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*18

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*19

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*20

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*21

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*22

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*23

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
    sdcp(count).addBackgroundSpikes4ptc = 1;
    sdcp(count).addBackgroundSpikes4oc = 1;
    sdcp(count).backDistLambda = unifrnd(0.03, 0.27);
    sdcp(count).comment = sprintf('%i | Max Hit Trial Percent: %i; Trial Assignment: %s; Event Timing: %s', count, sdcp(count).maxHitTrialPercent, sdcp(count).hitTrialPercentAssignment, sdcp(count).eventTiming);
    rng(sdcp(count).randomseed)
end
%N*24