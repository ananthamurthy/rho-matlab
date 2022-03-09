% Function call: "Synthetic Data Generator" by Kambadur Ananthamurthy
% This code uses real dfbf data, eventLibrary_2D, and control parameters to
% generate synthetic datasets.
% Currently uses one session of real data, but can generate synthetic
% datasets in batch.
% gDate: date when data generation occurred
% gRun: run number of data generation (multiple runs could occur on the same date)

function [memoryUsage, totalMem, sdo_batch, elapsedTime] = generateSyntheticData(gDate, gRun, workingOnServer, diaryOn, profilerTest)

if profilerTest
    profile on
end

tic
%close all

%% Operations
saveData        = 1;
%onlyProbeTrials = 0;
%fig             = 1;
%figureDetails = compileFigureDetails(16, 2, 10, 0.5, 'jet'); %(fontSize, lineWidth, markerSize, transparency, colorMap)

%% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/RHO/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/RHO/');
end
%Additinal search paths
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions')))
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies')))
make_db_real2synth %in localCopies

saveFolder = strcat(saveDirec, db.mouseName, '/', db.date, '/');

if diaryOn
    if workingOnServer == 1
        diary (strcat(HOME_DIR, '/logs/dataGenDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/dataGenDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

fprintf('Reference Dataset - %s_%i_%i | Date: %s\n', ...
    db.mouseName, ...
    db.sessionType, ...
    db.session, ...
    db.date)

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
configSynth
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
elapsedTime = toc;
memoryUsage = whos;
nVariables = length(memoryUsage);
totalMem = 0;
for vari = 1:nVariables
    totalMem = totalMem + (memoryUsage(vari).bytes/(1024^2));
end

if profilerTest
    profilerStats = profile('info');
    profile -timestamp
else
    profilerStats = [];
end
profile off
%% Save Everything
if saveData == 1
    disp ('Saving everything ...')
    save(strcat(saveFolder, ...
        'synthDATA_', ...
        num2str(gDate), ...
        '_gRun', num2str(gRun), ...
        '_batch_', ...
        num2str(nDatasets), ...
        '.mat'), ...
        'sdcp', ...
        'sdo_batch', ...
        'elapsedTime', ...
        'memoryUsage', ...
        'totalMem', ...
        'profilerStats', ...
        '-v7.3')
    disp('... done!')
end

disp('All done!')
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime)

if diaryOn
    diary off
end