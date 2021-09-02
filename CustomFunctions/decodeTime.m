% Time Decoder - Modified from Mehrab's code
% Written by Kambadur Ananthamurthy
tic
clf
clear
close all

%% Addpaths
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))
addpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth/localCopies')

%% Dataset
make_db
ops0.fig                       = 1;
ops0.saveData                  = 1;
ops0.onlyProbeTrials           = 0;
ops0.loadSyntheticData         = 1;

if ops0.loadSyntheticData
    setupSyntheticDataParameters
end

%% Figure details
if ops0.fig
    figureDetails = compileFigureDetails(20, 2, 10, 0.5, 'hot'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
end

%% Main script
for iexp = 1:length(db)
    fprintf('Analyzing %s_%i_%i - Date: %s\n', db(iexp).mouse_name, ...
        db(iexp).sessionType, ...
        db(iexp).session, ...
        db(iexp).date)
    saveDirec = '/Users/ananth/Desktop/Work/Analysis/Imaging/';
    saveFolder = [saveDirec db(iexp).mouse_name '/' db(iexp).date '/'];
    
    if ops0.loadSyntheticData
        load([saveFolder ...
            'synthDATA' ...
            '_pTC' num2str(percentTimeCells) ...
            '_aE2NTC' num2str(addEvents2NonTimeCells) ...
            '_cO' lower(cellOrder) ...
            '_mPHT' num2str(maxPercentHitTrials) ...
            '_hTA' lower(hitTrialAssignment) ...
            '_tO' lower(trialOrder) ...
            '_eW' num2str(eventWidth{1}) ...
            '_eAF' eventAmplificationFactor ...
            '_eT' lower(eventTiming) ...
            '_sF' num2str(startFrame) ...
            '_eF' num2str(endFrame) ...
            '_iFWHM' num2str(imprecisionFWHM) ...
            '_iT' lower(imprecisionType) ...
            '_n' lower(noise) ...
            '_np' num2str(noisePercent) ...
            '.mat']);
        myData.dfbf = syntheticDATA;
        myData.baselines = zeros(size(syntheticDATA));
        myData.dfbf_2D = syntheticDATA_2D;
    else
        %Load processed data (processed dfbf for dataset/session)
        myData = load([saveFolder db(iexp).mouse_name '_' db(iexp).date '.mat']);
    end
    trialDetails = getTrialDetails(db(iexp));
    
    %Significant-Only Traces
    if ops0.onlyProbeTrials
        disp('Only analysing Probe Trials ...')
        dfbf_sigOnly = findSigOnly(myData.dfbf(:, iProbeTrials, :));
    else
        dfbf_sigOnly = findSigOnly(myData.dfbf);
    end
    
    runAdapter4MehrabAnalysis;
    
    
    
end
toc