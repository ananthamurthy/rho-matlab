i = i + 1;
sdcp(i).timeCellPercent = 50; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 100; %in %
sdcp(i).hitTrialPercentAssignment = 'random'; %fixed or random
sdcp(i).trialOrder = 'basic'; %basic or random
sdcp(i).eventWidth = {50, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'none'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 10; %How much percent of noise to add
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'random hit trial assignment; basic hit trial order; low noise (10%)';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 50; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 50; %in %
sdcp(i).hitTrialPercentAssignment = 'fixed'; %fixed or random
sdcp(i).trialOrder = 'random'; %basic or random
sdcp(i).eventWidth = {100, 'same'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'none'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 10; %How much percent of noise to add
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'fixed hit trial assignment; random hit trial order; low noise (10%)';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 50; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 50; %in %
sdcp(i).hitTrialPercentAssignment = 'fixed'; %fixed or random
sdcp(i).trialOrder = 'random'; %basic or random
sdcp(i).eventWidth = {50, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'none'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 10; %How much percent of noise to add
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'medium event width range';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 50; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 50; %in %
sdcp(i).hitTrialPercentAssignment = 'fixed'; %fixed or random
sdcp(i).trialOrder = 'random'; %basic or random
sdcp(i).eventWidth = {100, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 10;
sdcp(i).eventTiming = 'sequential'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'none'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 10; %How much percent of noise to add
sdcp(i).comment = 'higher event width range, 10x event amplification';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 100; %in %
sdcp(i).hitTrialPercentAssignment = 'fixed'; %fixed or random
sdcp(i).trialOrder = 'random'; %basic or random
sdcp(i).eventWidth = {100, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'uniform'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 25; %How much percent of noise to add
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'uniform imprecision; 25% gaussian noise';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 100; %in %
sdcp(i).cellOrder = 'basic'; %basic or random
sdcp(i).maxHitTrialPercent = 100; %in %
sdcp(i).hitTrialPercentAssignment = 'fixed'; %fixed or random
sdcp(i).trialOrder = 'random'; %basic or random
sdcp(i).eventWidth = {100, 'stddev'}; %{location, width}; e.g. - {percentile, stddev}
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'random'; %sequential or random
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 12; %Will be divided by 2 for positive and negative "width" around the centre
sdcp(i).imprecisionType = 'normal'; %Uniform, Normal, or None
sdcp(i).noise = 'gaussian'; %Gaussian (as noisePercent) or None (renders noisePercent irrelevant)
sdcp(i).noisePercent = 75; %How much percent of noise to add
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'random timing, with gaussian imprecision of FWHM = 12; 75% gaussian noise';
rng(sdcp(i).randomseed)

%% TCM Presentation
i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'random';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {50, 'stddev'};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 10;
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'random hit trial assignment; basic hit trial order; low noise (10%)';
rng(sdcp(i).randomseed)

i = i + 1;
sdcp(i).timeCellPercent = 50;
sdcp(i).cellOrder = 'basic';
sdcp(i).maxHitTrialPercent = 100;
sdcp(i).hitTrialPercentAssignment = 'fixed';
sdcp(i).trialOrder = 'basic';
sdcp(i).eventWidth = {50, 'stddev'};
sdcp(i).eventAmplificationFactor = 1;
sdcp(i).eventTiming = 'sequential';
sdcp(i).startFrame = 116;
sdcp(i).endFrame = 123;
sdcp(i).imprecisionFWHM = 8;
sdcp(i).imprecisionType = 'none';
sdcp(i).noise = 'gaussian';
sdcp(i).noisePercent = 75;
sdcp(i).randomseed = 'default';
sdcp(i).comment = 'fixed hit trial assignment; basic hit trial order; high noise (75%)';
rng(sdcp(i).randomseed)

i = i + 1;
timeCellPercent = 50;
cellOrder = 'basic';
maxHitTrialPercent = 50;
hitTrialPercentAssignment = 'fixed';
trialOrder = 'random';
eventWidth = {50, 'stddev'};
eventAmplificationFactor = 1;
eventTiming = 'sequential';
startFrame = 116;
endFrame = 123;
imprecisionFWHM = 8;
imprecisionType = 'none';
noise = 'gaussian';
noisePercent = 10;
randomseed = 'default';
comment = 'fixed hit trial assignment; basic hit trial order; low noise (10%)';
rng(sdcp(i).randomseed)