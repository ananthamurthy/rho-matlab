% "Synthetic Data Maker" by Kambadur Ananthamurthy
% This code uses actual dfbf curves from my data, populates a library of
% calcium events and then creates synthetic datasets based on the arguments
% passed into 'syntheticDataMaker'
% Currently this is being tested for single session data. I will test with a
% batch, soon.

tic
close all
clear

addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))

%% Dataset
make_db
ops0.fig             = 1;
ops0.saveData        = 0;
%ops0.onlyProbeTrials = 0;

%% Synthetic Data Parameters
setupSyntheticDataParameters

%%
if ops0.fig
    figureDetails = compileFigureDetails(16, 2, 10, 0.5, 'jet'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
end

for iexp = 1:length(db)
    fprintf('Analyzing %s_%i_%i - Date: %s\n', db(iexp).mouseName, ...
        db(iexp).sessionType, ...
        db(iexp).session, ...
        db(iexp).date)
    saveDirec = '/Users/ananth/Desktop/Work/Analysis/Imaging/';
    saveFolder = [saveDirec db(iexp).mouseName '/' db(iexp).date '/'];
    
    %Load processed data (processed dfbf for dataset/session)
    realProcessedData = load([saveFolder db(iexp).mouseName '_' db(iexp).date '.mat']);
    trialDetails = getTrialDetails(db(iexp));
    
    %% Curate Calcium Event Library
    %Cell specific curation of the calcium event library
    %Check to see if the library exits
    if isfile([saveFolder db(iexp).mouseName '_' db(iexp).date '_eventLibrary_2D.mat'])
        disp('Loading existing event library ...')
        load([saveFolder db(iexp).mouseName '_' db(iexp).date '_eventLibrary_2D.mat'])
        disp('... done!')
    else
        %Use real 2D data
        baseline = zeros(size(realProcessedData.dfbf_2D,1),1);
        stddev = zeros(size(realProcessedData.dfbf_2D,1),1);
        binaryData = zeros(size(realProcessedData.dfbf_2D,2),1);
        
        %2D
        disp('Basic scan for calcium events ...')
        for cell = 1:size(realProcessedData.dfbf_2D,1)
            B = squeeze(realProcessedData.dfbf_2D(cell,:));
            baseline(cell) = mean(B);
            stddev(cell) = std(B);
            binaryData(find(B > (baseline(cell) + 2*stddev(cell))),1) = 1; %multiplier = 1
            [nEvents, StartIndices, Lengths] = findConsecutiveOnes(binaryData);
            eventLibrary_2D(cell).nEvents = nEvents;
            eventLibrary_2D(cell).eventStartIndices = StartIndices;
            eventLibrary_2D(cell).eventLengths = Lengths;
            % Find a way to optimize memory.
            
            clear binaryData
            clear Events
            clear StartIndices
            clear Lengths
        end
        disp('... calcium event library created!')
    end
    
    %% Make synthetic dataset
    DATA = realProcessedData.dfbf;
    DATA_2D = realProcessedData.dfbf_2D;
    disp('Creating synthetic data ...');
    [syntheticDATA, syntheticDATA_2D, putativeTimeCells, requiredEventLength] = syntheticDataMaker(db(iexp), DATA, DATA_2D, eventLibrary_2D, ...
        percentTimeCells, cellOrder, ...
        maxPercentHitTrials, hitTrialAssignment, trialOrder, ...
        eventWidth, eventAmplificationFactor, eventTiming, startFrame, endFrame, ...
        imprecisionFWHM, imprecisionType, ...
        noise, noisePercent);
    disp('... done!')
    
    if ops0.saveData == 1
        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_eventLibrary_2D.mat'], 'eventLibrary_2D')
        save([saveFolder ...
            'synthDATA' ...
            '_pTC' num2str(percentTimeCells) ...
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
            '.mat'], ...
            'syntheticDATA', 'syntheticDATA_2D', ...
            'percentTimeCells', 'cellOrder', ...
            'maxPercentHitTrials', 'hitTrialAssignment', 'trialOrder', ...
            'eventWidth', 'eventTiming', ...
            'startFrame', 'endFrame', ...
            'imprecisionFWHM', 'imprecisionType', ...
            'noise', 'noisePercent')
    end
    
    if ops0.fig == 1
        fig1 = figure(1);
        set(fig1,'Position', [300, 300, 1200, 500]);
        plotdFbyF(db(iexp), syntheticDATA_2D, trialDetails, 'Frame Number', 'Cell Numbers', figureDetails, 0)
        colormap(figureDetails.colorMap)
        
        print(['/Users/ananth/Desktop/figs/syntheticData/synthData_' ...
            db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)], ...
            '-djpeg');
        
        fig2 = figure(2);
        set(fig2,'Position', [300, 300, 1200, 500]);
        plotdFbyF(db(iexp), syntheticDATA_2D(:,1:(3*trialDetails.nFrames)), trialDetails, 'Frame Number', 'Cell Numbers', figureDetails, 0)
        colormap(figureDetails.colorMap)
        
        print(['/Users/ananth/Desktop/figs/syntheticData/synthData_first3trials_' ...
            db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)], ...
            '-djpeg');
        
    else
    end
end
toc
disp('All done!')