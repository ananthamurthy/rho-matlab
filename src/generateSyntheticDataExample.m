% "Synthetic Data Generator" by Kambadur Ananthamurthy
% This code uses real dfbf data, eventLibrary_2D, and control parameters to
% generate synthetic datasets.
% Currently uses one session of real data, but can generate synthetic
% datasets in batch.
% gDate: date when data generation occurred
% gRun: run number of data generation (multiple runs could occur on the same date)

function generateSyntheticDataExample(workingOnServer, figureDetails)

disp('Generating Example Schematics ...')
gDate = erase(datestr(now, 29), '-'); % Format: yyyymmdd
gRun = 1;
normalizeEachCell = 1;
%workingOnServer = 0;

if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
end
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions'))) % my custom functions
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies'))) % Scripts to config files

%ops0.fig             = 1;
ops0.saveData        = 1;
ops0.plotData        = 1;
ops0.diary           = 0;

%figureDetails = compileFigureDetails(16, 2, 10, 0.5, 'jet'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
ops0.onlyProbeTrials = 0;
C = magma(8);

%selectedRGBs = [4, 1, 3, 5];
selectedRGBs = [5, 1, 7, 8];
C1 = zeros(length(selectedRGBs), 3);
for rgbi = 1:length(selectedRGBs)
    C1(rgbi, :) = C(selectedRGBs(rgbi), :);
end
C1rev = C1(length(selectedRGBs):-1:1, :);

if ops0.diary
    if workingOnServer == 1
        diary (strcat(HOME_DIR, '/logs/dataGenDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/dataGenDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

%% Load real dataset details
make_db %Currently only for one session at a time

fprintf('Reference Dataset - %s_%i_%i | Date: %s\n', ...
    db.mouseName, ...
    db.sessionType, ...
    db.session, ...
    db.date)

if workingOnServer == 1
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
else
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/RHO/');
end

saveFolder = strcat(saveDirec, db.mouseName, '/', db.date, '/');

%% Load processed dF/F data for dataset
realProcessedData = load(strcat(saveFolder, db.mouseName, '_', db.date, '.mat'));
DATA = realProcessedData.dfbf;
DATA_2D = realProcessedData.dfbf_2D;
nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3);
fprintf('Total cells: %i\n', nCells)

%Lookout for NaNs
input.nCells = nCells;
input.dataDesc = 'Reference Data';
input.dimensions = '2D';
[~] = lookout4NaNs(DATA_2D, input);

%% Load synthetic dataset control parameters
setupSyntheticDataParametersSchematic
nDatasets = length(sdcp);

%% Organize Library of Calcium Events
%Cell specific curation of the calcium event library
%Check to see if the library exits, else create
if isfile(strcat(saveFolder, db.mouseName, '_', db.date, '_eventLibrary_2D.mat'))
    disp('Loading existing event library ...')
    filepath = strcat(saveFolder, db.mouseName, '_', db.date, '_eventLibrary_2D.mat');
    load(filepath);
    disp('... done!')
else
    disp('Curating Library ...')
    eventLibrary_2D = curateLibrary(DATA_2D);
    save(strcat(saveFolder, db.mouseName, '_', db.date, '_eventLibrary_2D.mat'), 'eventLibrary_2D')
    disp('... done!')
end

%% Generate synthetic dataset(s)
%Preallocation
s.syntheticDATA = zeros(nCells, nTrials, nFrames);
s.syntheticDATA_2D = zeros(nCells, nTrials * nFrames);
s.maxSignal = zeros(nCells, 1);
s.ptcList = [];
s.ocList = [];
s.nCells = nCells;
s.actualEventWidth = zeros(nCells, 2);
s.allEventWidths = zeros(nCells, nTrials);
s.hitTrialPercent = zeros(nCells, 1);
s.hitTrials = zeros(nCells, nTrials);
s.frameIndex = zeros(nCells, nTrials);
s.pad = zeros(nCells, nTrials);
s.noiseComponent = zeros(nCells, nTrials, nFrames);
s.scurr = {};
s.endTime = '';
s.Q = zeros(nCells, 1);
s.T = zeros(nCells, 1);
s.nanList = zeros(nCells, 1);
sdo_batch = repmat(s, 1, nDatasets);
clear s

for runi = 1:1:nDatasets
    fprintf('Dataset: %i\n', runi)
    sdo = syntheticDataMaker(db, DATA_2D, eventLibrary_2D, sdcp(runi));

    %Run specifics
    scurr = rng;
    sdo.scurr = scurr; %Saves current status of randomseed
    sdo.endTime = datestr(now,'mm-dd-yyyy_HH-MM');

    % Develop Reference Quality (Q)
    params4Q.nCells = nCells;
    params4Q.hitTrialPercent = sdo.hitTrialPercent;
    params4Q.noisePercent = sdcp(runi).noisePercent;
    params4Q.eventAmplificationFactor = sdcp(runi).eventAmplificationFactor;
    params4Q.maxSignal = sdo.maxSignal;
    %params4Q.actualEventWidth = sdo.actualEventWidth;
    params4Q.allEventWidths = sdo.allEventWidths;
    params4Q.hitTrials = sdo.hitTrials;
    %params4Q.imprecisionFWHM = sdcp(runi).imprecisionFWHM;
    params4Q.pad = sdo.pad;
    params4Q.stimulusWindow = sdcp(runi).endFrame - sdcp(runi).startFrame;
    params4Q.alpha = 1;
    params4Q.beta = 1;
    params4Q.gamma = 10;

    sdo.Q = developRefQ(params4Q);

    %     % Derived Time
    %     delta = 3;
    %     skipFrames = [];
    %     [ETH, ETH_3D, nbins] = getETH(sdo.syntheticDATA, delta, skipFrames);
    %     %[~, derivedT] = max(ETH(sdo.ptcList,:), [], 2); % Actual Time Vector
    %     [~, derivedT] = max(ETH(:,:), [], 2); % Actual Time Vector
    %     sdo.T = derivedT;
    sdo.T = zeros(nCells, 1); %No strict need

    %And finally
    sdo_batch(runi) = sdo;
end

%% Plots
%figureDetails = compileFigureDetails(12, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
fig1 = figure(1);
clf
set(fig1, 'Position', [100, 300, 900, 1200])

for myCase = 1:10
    %cell = randi(100);
    cell = 50;

    a = squeeze(sdo_batch(myCase).syntheticDATA(cell, 1:5, :));

    if myCase == 1
        myText = sprintf('Noise: Low (%i%%)', sdcp(myCase).noisePercent);
    elseif myCase == 2
        myText = sprintf('Noise: High (%i%%)', sdcp(myCase).noisePercent);
    elseif myCase == 3
        myText = sprintf('Event Widths: Small (%ith)', sdcp(myCase).eventWidth{1});
    elseif myCase == 4
        myText = sprintf('Event Widths: Large (%ith)', sdcp(myCase).eventWidth{1});
    elseif myCase == 5
        myText = sprintf('Imprecision: Low (%i frames)', sdcp(myCase).imprecisionFWHM);
    elseif myCase == 6
        myText = sprintf('Imprecision: High (%i frames)', sdcp(myCase).imprecisionFWHM);
    elseif myCase == 7
        myText = sprintf('Hit Trial Ratio: Low (%i%%)', sdcp(myCase).maxHitTrialPercent);
    elseif myCase == 8
        myText = sprintf('Hit Trial Ratio: High (%i%%)', sdcp(myCase).maxHitTrialPercent);
    elseif myCase == 9
        myText = ['Background: Low (\lambda = ' sprintf('%.1f)', sdcp(myCase).backDistLambda)];
    elseif myCase == 10
        myText = ['Background: High (\lambda = ' sprintf('%.1f)', sdcp(myCase).backDistLambda)];
    end

    subplot(7, 2, myCase)
    if mod(myCase, 2) ~= 0
        for trial =  1:5
            plot((a(trial, :)*100) + (trial-1)*250, 'Color', C1(2, :), 'LineWidth', figureDetails.lineWidth)
            set(gca,'YTick',[-200 200])
            xlim([1 246])
            ylim([-200 1500])
            hold on
        end
        hold off
        if myCase == 9
            xlabel('Frames (@14.5Hz)', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            ylabel('dF/F (%)', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
        end
    else
        if myCase == 1 %High Noise
            for trial = 1:1
                plot((a(trial, :)*100) + (trial-1)*250, 'Color', C1(1, :), 'LineWidth', figureDetails.lineWidth)
                set(gca,'YTick',[-200 200])
                xlim([1 246])
                ylim([-200 1500])
                hold on
            end
            hold off
        else
            for trial = 1:5
                plot((a(trial, :)*100) + (trial-1)*250, 'Color', C1(1, :), 'LineWidth', figureDetails.lineWidth)
                set(gca,'YTick',[-200 200])
                xlim([1 246])
                ylim([-200 1500])
                hold on
            end
            hold off
        end

    end
    title(myText, ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')

    set(gca, 'FontSize', figureDetails.fontSize)
    clear a
end

subplot(7, 2, [11, 13])
if normalizeEachCell
    myDatasetTrialAvg = mean(sdo_batch(11).syntheticDATA, 2);
    for celli = 1:size(myDatasetTrialAvg, 1)
        maxVal = max(squeeze(myDatasetTrialAvg(celli, :)));
        myDatasetTrialAvg(celli, :) = myDatasetTrialAvg(celli, :)/maxVal;
    end
    imagesc(squeeze(myDatasetTrialAvg)*100);
else
    imagesc(squeeze(mean(sdo_batch(11).syntheticDATA, 2)*100));
end
% title('Trial-Avg. Synth. Calcium Traces', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
xlabel('Frames', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel(sprintf('Cells (@ %i%% Noise)', sdcp(11).noisePercent), ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
z = colorbar;
% if normalizeEachCell
%     ylabel(z,'Norm. dF/F (%)', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
% else
% ylabel(z,'dF/F (%)', ...
%         'FontSize', figureDetails.fontSize, ...
%         'FontWeight', 'bold')
% end
colormap(magma)
set(gca, 'FontSize', figureDetails.fontSize)

subplot(7, 2, [12, 14])
if normalizeEachCell
    myDatasetTrialAvg = mean(sdo_batch(12).syntheticDATA, 2);
    for celli = 1:size(myDatasetTrialAvg, 1)
        maxVal = max(squeeze(myDatasetTrialAvg(celli, :)));
        myDatasetTrialAvg(celli, :) = myDatasetTrialAvg(celli, :)/maxVal;
    end
    imagesc(squeeze(myDatasetTrialAvg)*100);
else
    imagesc(squeeze(mean(sdo_batch(12).syntheticDATA, 2)*100));
end
% title('Trial-Avg. Synth. Calcium Traces', ...
%     'FontSize', figureDetails.fontSize, ...
%     'FontWeight', 'bold')
xlabel('Frames', ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
ylabel(sprintf('Cells (@ %i%% Noise)', sdcp(12).noisePercent), ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
z = colorbar;
if normalizeEachCell
    ylabel(z,'Trial-Avg. Norm. dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
else
    ylabel(z,'dF/F (%)', ...
        'FontSize', figureDetails.fontSize, ...
        'FontWeight', 'bold')
end
colormap(magma)
set(gca, 'FontSize', figureDetails.fontSize)

print(sprintf('%s/figs/1-Examples', ...
    HOME_DIR2), ...
    '-dpng')

%% Save Everything
if ops0.saveData == 1
    disp ('Saving example ...')
    save(strcat(saveFolder, ...
        'synthDATA_example_', ...
        num2str(nDatasets), ...
        '.mat'), ...
        'sdcp', 'sdo_batch', ...
        '-v7.3')
    disp('... done!')
end
disp('... Example created.')

if ops0.diary
    diary off
end