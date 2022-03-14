% TITLE - Custom code to Identify Time Cell Sequences, if any
% AUTHOR - Kambadur Ananthamurthy

% Additional functions may be found in "CustomFunctions"
%profile on
tic
close all
%clear all
clear

%% Addpaths
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions')) % my custom functions
%addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/home/ananth/Desktop/Work/Analysis/Imaging')) % analysis output
%addpath('/home/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth/localCopies')
%% Operations
ops0.multiDayAnalysis          = 0; %For chronic tracking experiments; usually set to 0
ops0.fig                       = 1;
ops0.useLOTO                   = 0;
ops0.gaussianSmoothing         = 0;
ops0.bandpassFilter            = 0;
ops0.loadBehaviourData         = 0;
ops0.loadSyntheticData         = 0;
ops0.onlyProbeTrials           = 0;
ops0.findTimeCells             = 1;
ops0.curateCalciumEventLibrary = 1;
ops0.saveData                  = 0;
%% Dataset
make_db_realBatch
%% Synthetic Data Parameters
if ops0.loadSyntheticData
    setupSyntheticDataParameters
end
%% Main script
for iexp = 1:length(db)
    fprintf('Analyzing %s_%i_%i - Date: %s\n', db(iexp).mouseName, ...
        db(iexp).sessionType, ...
        db(iexp).session, ...
        db(iexp).date)
    
    saveDirec = '/Users/ananth/Desktop/Work/Analysis/Imaging/';
    saveFolder = [saveDirec db(iexp).mouseName '/' db(iexp).date '/'];
    
    if ops0.loadSyntheticData == 1
        i = 1;
        load([saveFolder ...
            'synthDATA' ...
            '_tCP' num2str(sdcp(i).timeCellPercent) ...
            '_cO' lower(sdcp(i).cellOrder) ...
            '_mHTP' num2str(sdcp(i).maxHitTrialPercent) ...
            '_hTPA' lower(sdcp(i).hitTrialPercentAssignment) ...
            '_tO' lower(sdcp(i).trialOrder) ...
            '_eW' num2str(sdcp(i).eventWidth{1}) ...
            '_eAF' num2str(sdcp(i).eventAmplificationFactor) ...
            '_eT' lower(sdcp(i).eventTiming) ...
            '_sF' num2str(sdcp(i).startFrame) ...
            '_eF' num2str(sdcp(i).endFrame) ...
            '_iFWHM' num2str(sdcp(i).imprecisionFWHM) ...
            '_iT' lower(sdcp(i).imprecisionType) ...
            '_n' lower(sdcp(i).noise) ...
            '_np' num2str(sdcp(i).noisePercent) ...
            '.mat'])
        dfbf = sdo.syntheticDATA;
        baselines = zeros(size(sdo.syntheticDATA));
        dfbf_2D = sdo.syntheticDATA_2D;
    else
        %Load Fluorescence Data
        load(sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/F_%s_%s_plane%i.mat', ...
            db(iexp).mouseName, db(iexp).date, db(iexp).expts, ...
            db(iexp).mouseName, db(iexp).date, db(iexp).nplanes))
        
        %Registration Options
        load(sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/regops_%s_%s.mat', ...
            db(iexp).mouseName, db(iexp).date, db(iexp).expts, ...
            db(iexp).mouseName, db(iexp).date))
        
        if ops0.multiDayAnalysis
            [overlaps] = cat_overlap();
            if db(iexp).isDayOne
                newIndices = overlaps.rois.idcs(:,1);
            else
                newIndices = overlaps.rois.idcs(:,2);
            end
            myRawData = Fcell{1,1}(newIndices,:);
        else
            myRawData = Fcell{1,1};
        end
        fprintf('Total cells: %i\n', size(myRawData,1))
        [dfbf, baselines, dfbf_2D] = dodFbyF(db(iexp), myRawData);
    end
    
    nCells = size(dfbf, 1);
    nTrials = size(dfbf, 2);
    nFrames = size(dfbf, 3);
    
    %Load Behaviour Data
    if ops0.loadBehaviourData == 1
        load(sprintf('/Users/ananth/Desktop/Work/Analysis/Behaviour/FEC/%s/%s_%i_%i/fec.mat', ...
            db(iexp).mouseName, db(iexp).mouseName, db(iexp).sessionType, db(iexp).session))
        iProbeTrials = find(probeTrials);
    end
    
    if ops0.fig
        figureDetails = compileFigureDetails(20, 2, 10, 0.5, 'hot'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
    end
    
    trialDetails = getTrialDetails(db(iexp)); %test
    
    %Significant-Only Traces
    if ops0.onlyProbeTrials
        if ops0.loadBehaviourData == 1
            disp('Only analysing Probe Trials ...')
            dfbf_sigOnly = findSigOnly(dfbf(:,iProbeTrials,:));
        else
            error('No behaviour data to get probe trials')
        end
    else
        dfbf_sigOnly = findSigOnly(dfbf);
    end
    
    
    %Search for low frequency events
    if ops0.gaussianSmoothing
        nSamples = 3; %for Gaussian Kernel
        [dfbf_sigOnly_smooth, gaussianKernel] = doGaussianSmoothing(dfbf_sigOnly, nSamples);
        %         cell = 15;
        %         figure(20)
        %         subplot(1,2,1)
        %         surf(squeeze(dfbf_sigOnly(cell,:,:))*100)
        %         title('Data | Cell 15')
        %         xlabel('Frames')
        %         ylabel('Trials')
        %         zlabel('dF/F (%)')
        %         set(gca, 'FontSize', 20)
        %
        %         subplot(1,2,2)
        %         surf(squeeze(dfbf_sigOnly_smooth(cell,:,:))*100)
        %         title('Smoothed Data | Cell 15')
        %         xlabel('Frames')
        %         ylabel('Trials')
        %         zlabel('dF/F (%)')
        %         set(gca, 'FontSize', 20)
        %         colormap summer
        %Visualize filter
        %wvtool(gaussianKernel)
        myData = dfbf_sigOnly_smooth;
    elseif ops0.bandpassFilter
        sampleRate = 14.5; % Hz
        lowEnd = 3; % Hz
        highEnd = 7; % Hz
        filterOrder = 2; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
        [b, a] = butter(filterOrder, [lowEnd highEnd]/(sampleRate/2)); % Generate filter coefficients
        filteredData = zeros(size(dfbf_sigOnly));
        for cell = 1:size(dfbf_sigOnly,1)
            for trial = 1:size(dfbf_sigOnly,2)
                filteredData(cell,trial,:) = filtfilt(b, a, squeeze(dfbf_sigOnly(cell,trial,:))); % Apply filter to data using zero-phase filtering
            end
        end
        myData = filteredData;
    else
        myData = dfbf_sigOnly; % crucial
    end
    
    %% Tuning and time field fidelity using ETH
    if ops0.findTimeCells
        %Area Under Curve
        %AUC = doAUC(myData(:,:,window)); %(Data, percentile)
        trialPhase = 'wholeTrial';
        window = findWindow(trialPhase, trialDetails);
        %window = 100:150;
        %skipFrames = 116; %Skip frame 116, viz., the CS frame. Use skipFrames = 0 to avoid skipping
        %skipFrames = trialDetails.preDuration * db(iexp).samplingDate;
        skipFrames = [];
        %NOTE: Make sure to use significant-only traces else a second
        %trialThreshold needs to be passed as an argument
        % ETH based identification of tuning curves
        trialThreshold = floor(0.25 * (size(myData,2))); %trialThreshold is 25% of the session trials
        shuffleThreshold = 99; %percent of nShuffles for time cell qualification
        nShuffles = 1000;
        delta = 3; %for now; works out to 207 ms if sampling at 14.5 Hz
        allCells = ones(size(myData,1),1); %for indexing only
        
        disp('First filtering for percentage of trials with activity, then ETH ...')
        [cellRastor, cellFrequency, timeLockedCells_temp, importantTrials] = ...
            getFreqBasedTimeCellList(myData, allCells, trialThreshold, skipFrames, delta);
        %iTimeCells_temp = find(selectedIndices);
        %Develop ETH only for cells passing >25% activity
        [ETH, trialAUCs, nbins] = getETH(myData, delta, skipFrames);
        %Finally, identifying true time-locked cells, using the TI metric
        [timeLockedCells, TI] = getTimeLockedCells(trialAUCs, timeLockedCells_temp, nShuffles, shuffleThreshold);
        iTimeCells = find(timeLockedCells); %Absolute indexing
        dfbf_timeLockedCells = myData(iTimeCells,:,:);
        fprintf('%i time-locked cells found\n', length(iTimeCells))
        %ETH_probeTrials = sum(ETH_3D(:,iProbeTrials,:),2);
        %2. There should be at least two consecutive bins with significant
        %values for ETH. TBA
        
        % Sorting
        if isempty(find(timeLockedCells,1))
            %disp('No time cells found')
            %[sortedETHindices, peakIndicies] = [0, 0];
            sortedETHindices = [];
            peakIndicies = [];
            ETH_sorted = [];
            dfbf_sorted_timeLockedCells = [];
            dfbf_2D_sorted_timeCells = [];
        else
            [sortedETHindices, peakIndices] = sortETH(ETH(iTimeCells,:));
            %%%
            %Add a section to use the median time onset delay
            %maybe use ETH_3D
            %%%
            ETH_timeLocked = ETH(iTimeCells,:);
            ETH_sorted = ETH_timeLocked(sortedETHindices,:);
            dfbf_sorted_timeLockedCells = dfbf_timeLockedCells(sortedETHindices,:,:);
            %dfbf_2D_sorted_timeCells = dfbf_2D_timeLockedCells(sortedETHindices,:);
        end
    else
        %Populate library for simulated data
        realProcessedData = load([saveFolder db(iexp).mouseName '_' db(iexp).date '.mat']);
    end
    %Cell specific
    %Use real 2D data
    baseline = zeros(nCells,1);
    stddev = zeros(nCells,1);
    
    %% Curate Calcium Event Library
    if ops0.curateCalciumEventLibrary
        %Use real 2D data
        cellMean = zeros(nCells, 1);
        cellStddev = zeros(nCells, 1);
        binaryData = zeros(nCells, 1);
        
        disp('Basic scan for calcium events ...')
        
        %Preallocation
        s.nEvents = 0;
        s.eventStartIndices = [];
        s.eventWidths = [];
        eventLibrary_2D = repmat(s, 1, nCells);
        clear s
        
        for cell = 1:nCells
            sampledCellActivity = squeeze(dfbf_2D(cell, :));
            cellMean(cell) = mean(sampledCellActivity);
            cellStddev(cell) = std(sampledCellActivity);
            logicalIndices = sampledCellActivity > (cellMean(cell) + 2* cellStddev(cell));
            binaryData(logicalIndices, 1) = 1;
            minNumberOf1s = 4;
            [nEvents, StartIndices, Widths] = findConsecutiveOnes(binaryData, minNumberOf1s);
            eventLibrary_2D(cell).nEvents = nEvents;
            eventLibrary_2D(cell).eventStartIndices = StartIndices;
            eventLibrary_2D(cell).eventWidths = Widths;
            
            clear binaryData
            clear Events
            clear StartIndices
            clear Lengths
        end
        save([saveFolder db.mouseName '_' db.date '_eventLibrary_2D.mat'], 'eventLibrary_2D')
        disp('... calcium activity library created!')
    end
    %     if ~ops0.onlyProbeTrials
    %         % Sort ETHs for only Probe Trials
    %         [sortedETHindices_probeTrials, peakIndicies_probeTrials] = sortETH(ETH_probeTrials(iTimeCells,:));
    %         ETH_timeLocked_probeTrials = ETH(iTimeCells,:);
    %         ETH_sorted_probeTrials = ETH_timeLocked_probeTrials(sortedETHindices,:);
    %     end
    
    if ops0.useLOTO
        [consolidated_iTimeCells_loto, diff_nTimeCells, consolidated_TI_loto, diff_TI] ...
            = runLOTO(myData, trialThreshold, delta, allCells, skipFrames);
    end
    disp('... done!')
    %% Search for large Calcium events
    largeEvents = detectLargeEvents(myData);
    %% Data Saving for Custom section
    if ops0.saveData
        if ops0.findTimeCells
            percentTimeCells = (length(iTimeCells)/size(dfbf,1))*100;
            fprintf('[INFO] %0.4f %% of cells were time-locked\n', percentTimeCells)
            if ~isdir(saveFolder)
                mkdir(saveFolder);
            end
            if ops0.useLOTO
                if ops0.multiDayAnalysis
                    disp('Saving multi-day data after LOTO ...')
                    if ops0.loadSyntheticData == 1
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date  '_synth' num2str(ops0.loadSyntheticData) '_multiDay.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'consolidated_iTimeCells_loto', 'TI', 'consolidated_TI_loto', ...
                            'largeEvents')
                    else
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_multiDay.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'consolidated_iTimeCells_loto', 'TI', 'consolidated_TI_loto', ...
                            'largeEvents')
                    end
                else
                    disp('Saving single session data after LOTO ...')
                    if ops0.loadSyntheticData == 1
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_synth' num2str(ops0.loadSyntheticData) '.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'consolidated_iTimeCells_loto', 'TI', 'consolidated_TI_loto', ...
                            'largeEvents')
                    else
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'consolidated_iTimeCells_loto', 'TI', 'consolidated_TI_loto', ...
                            'largeEvents')
                    end
                end
            else %Not using LOTO
                if ops0.multiDayAnalysis
                    disp('Saving multi-day data ...')
                    if ops0.loadSyntheticData == 1
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_synth' num2str(ops0.loadSyntheticData) '_multiDay.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'TI', ...
                            'largeEvents')
                    else
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_multiDay.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'TI', ...
                            'largeEvents')
                    end
                else
                    disp('Saving single session data ...')
                    if ops0.loadSyntheticData == 1
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '_synth' num2str(ops0.loadSyntheticData) '.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'TI', ...
                            'largeEvents')
                    else
                        save([saveFolder db(iexp).mouseName '_' db(iexp).date '.mat' ], ...
                            'dfbf', 'baselines', 'dfbf_2D', ...
                            'dfbf_timeLockedCells', ...
                            'dfbf_sorted_timeLockedCells', ...
                            'trialPhase', 'window', ...
                            'trialThreshold', ...
                            'cellRastor', 'cellFrequency', 'timeLockedCells', 'importantTrials', ...
                            'delta', ...
                            'ETH', 'iTimeCells', 'TI', ...
                            'largeEvents')
                    end
                end
            end
            disp('... done!')
        else
            %Saving library for simulated data
            disp('Saving the library of events ...')
            save([saveFolder db(iexp).mouseName '_' db(iexp).date '_eventLibrary_2D.mat'], 'eventLibrary_2D')
            disp('... done!')
        end
    end
    
    %% Plots
    if ops0.findTimeCells
        if ops0.fig
            disp('Plotting data ...')
            
            % ETH
            fig1 = figure(1);
            clf
            set(fig1,'Position',[300,300,1200,500])
            subFig1 = subplot(1,2,1);
            plotETH(db(iexp), ETH(iTimeCells,:), trialDetails, 'Bin No.', 'Unsorted Cells', figureDetails, 1)
            subFig2 = subplot(1,2,2);
            plotETH(db(iexp), ETH_sorted, trialDetails, 'Bin No.', 'Sorted Cells', figureDetails, 1)
            colormap(figureDetails.colorMap)
            
            if ops0.multiDayAnalysis
                print(['/Users/ananth/Desktop/figs/psth/psth_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
                    '-djpeg');
            else
                print(['/Users/ananth/Desktop/figs/psth/psth_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
                    '-djpeg');
            end
            
            % Sorting based Sequences - plotting
            %         csFrame = 116;
            %         xTicks = window;
            %         %xLabels = strtrim(cellstr(num2str(window'))');
            %         xLabels = cellstr(num2str(window'))';
            %             clear window %for sanity
            %             window = 80:160;
            %             xTicks = [0 18 36 54 72];
            %             %xTicks = 0:4:window(1);
            %             %automate x label generation
            %             %actualXlabels = ((window(1):4:window(end))-csFrame)*69; %Since the frame rate is 14.5 Hz (each frame = 69 ms)
            %             %temp = cellfun(@num2str,num2cell(actualXlabels(:)),'uniformoutput',false);
            %             %temp2 = strjoin(arrayfun(@(actualXlabels) num2str(actualXlabels),n,'UniformOutput',false),',');
            %             %xLabels = {'-2484', '-2208', '-1932', '-1656', '-1380', '-1104', '-828', '-552', '-276', '0', '276', '552', '828', '1104','1380', '1656', '1932', '2208', '2484', '2760', '3036'};
            %             xLabels = {'-2484', '-1242', '0', '1242', '2484' };
            %         fig2 = figure(2);
            %         set(fig2,'Position', [300, 300, 1200, 500]);
            %         subplot(1,2,1);
            %         %plot unsorted data
            %         plotSequences(db(iexp), dfbf_timeLockedCells, trialPhase, 'Frames', 'Unsorted Cells', figureDetails, 1)
            %         colormap(figureDetails.colorMap)
            %
            %         subplot(1,2,2);
            %         %plot sorted data
            %         plotSequences(db(iexp), dfbf_sorted_timeLockedCells, trialPhase, 'Frames', ['Sorted Cells (Threshold: ' num2str(trialThreshold) ')'], figureDetails, 1)
            %         colormap(figureDetails.colorMap)
            %
            %         if ops0.multiDayAnalysis
            %             print(['/Users/ananth/Desktop/figs/sort/timeCells_allTrialsAvg_sorted_' ...
            %                 'trialThreshold' num2str(trialThreshold) '_' ...
            %                 db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
            %                 '-djpeg');
            %         else
            %             print(['/Users/ananth/Desktop/figs/sort/timeCells_allTrialsAvg_sorted_' ...
            %                 'trialThreshold' num2str(trialThreshold) '_' ...
            %                 db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
            %                 '-djpeg');
            %         end
            
            % Calcium activity for time-locked cells, from all trials
            %         fig3 = figure(3);
            %         clf
            %         set(fig3,'Position',[300,300,1200,500])
            %         if ~isempty(iTimeCells)
            %             subplot(2,1,1);
            %             %plot unsorted data
            %             plotdFbyF(db(iexp), dfbf_2D, trialDetails, 'Frames', 'Unsorted Cells', figureDetails, 0)
            %             %plot sorted data
            %             subplot(2,1,2);
            %             plotdFbyF(db(iexp), dfbf_2D_sorted_timeCells, trialDetails, 'Frames', ['Sorted Cells (Threshold: ' num2str(trialThreshold) ')'], figureDetails, 0)
            %             colormap(figureDetails.colorMap)
            %         else
            %             plotdFbyF(db(iexp), dfbf_2D, trialDetails, 'Frames', 'Unsorted Cells', figureDetails, 0)
            %         end
            %
            %         if ops0.multiDayAnalysis
            %             print(['/Users/ananth/Desktop/figs/calciumActivity/dfbf_2D_allTrials_' ...
            %                 'trialThreshold' num2str(trialThreshold) '_'...
            %                 db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_sorted_multiDay'],...
            %                 '-djpeg');
            %         else
            %             print(['/Users/ananth/Desktop/figs/calciumActivity/dfbf_2D_allTrials_' ...
            %                 'trialThreshold' num2str(trialThreshold) '_'...
            %                 db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_sorted'],...
            %                 '-djpeg');
            %         end
            
            % Temporal Information
            fig4 = figure(4);
            clf
            set(fig4,'Position',[300,300,800,400])
            %TI_all_sorted = TI(sortedETHindices,:);
            plot(TI, 'b*', ...
                'LineWidth', figureDetails.lineWidth, ...
                'MarkerSize', figureDetails.markerSize)
            hold on
            TI_onlyTimeLockedCells = nan(size(TI));
            TI_onlyTimeLockedCells(iTimeCells) = TI(iTimeCells);
            plot(TI_onlyTimeLockedCells, 'ro', ...
                'MarkerSize', figureDetails.markerSize)
            %axis([0 size(TI,1) 0.5 2.5])
            title('Temporal Information', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            xlabel('Cell Number', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            ylabel('Temporal Information (bits)', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            legend({'All Cells', 'Time-Locked Cells'})
            set(gca,'FontSize', figureDetails.fontSize-2)
            
            if ops0.multiDayAnalysis
                print(['/Users/ananth/Desktop/figs/psth/ti_unsorted_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
                    '-djpeg');
            else
                print(['/Users/ananth/Desktop/figs/psth/ti_unsorted_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
                    '-djpeg');
            end
            
            % Trends in Temporal Information
            TI_timeLockedCells = TI(iTimeCells,:);
            TI_sorted = TI_timeLockedCells(sortedETHindices,:);
            fig5 = figure(5);
            clf
            set(fig5,'Position',[300,300,800,400])
            plot(TI_sorted, 'b*', ...
                'MarkerSize', figureDetails.markerSize)
            if ~isempty(TI_sorted)
                axis([0 size(TI_sorted,1) 0 max(TI_sorted)])
            end
            title('Temporal Information | Sorted Time Cells', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            xlabel('Sorted Time-Locked Cell Number', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            ylabel('Temporal Information (bits)', ...
                'FontSize', figureDetails.fontSize, ...
                'FontWeight', 'bold')
            %legend({'All Cells', 'Time-Locked Cells'})
            set(gca,'FontSize', figureDetails.fontSize-2)
            if ops0.multiDayAnalysis
                print(['/Users/ananth/Desktop/figs/psth/ti_sorted_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
                    '-djpeg');
            else
                print(['/Users/ananth/Desktop/figs/psth/ti_sorted_' ...
                    db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
                    '-djpeg');
            end
            
            %Differences observed using LOTO
            if ops0.useLOTO
                %Number of classified time cells
                fig6 = figure(6);
                clf
                set(fig6,'Position',[300,300,800,400])
                stem(diff_nTimeCells, '-red*', ...
                    'MarkerSize', figureDetails.markerSize)
                title(['LOTO - Numbers | ', ...
                    db(iexp).mouseName ' ST' num2str(db(iexp).sessionType) ' S' num2str(db(iexp).session)], ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                xlabel('Excluded Trial No.', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                ylabel('Difference in classified time cells', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                set(gca,'FontSize', figureDetails.fontSize-2)
                if ops0.multiDayAnalysis
                    print(['/Users/ananth/Desktop/figs/importantTrials/diff_nTimeCells_' ...
                        db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
                        '-djpeg');
                else
                    print(['/Users/ananth/Desktop/figs/importantTrials/diff_nTimeCells_' ...
                        db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
                        '-djpeg');
                end
                
                %TI values
                nanLine = nan(size(myData,1),1);
                nanLine(iTimeCells) = 1;
                fig7 = figure(7);
                clf
                set(fig7,'Position',[300,300,1500,1500])
                %             for trial = 1:size(myData,2)
                %                 hold on;
                %                 plot(diff_TI(trial,:), '-bo', ...
                %                     'MarkerSize', figureDetails.markerSize)
                %             end
                subplot(3,1,1:2)
                surf(diff_TI, 'FaceAlpha', 0.4);
                colormap autumn
                title(['LOTO - TI | ', ...
                    db(iexp).mouseName ' ST' num2str(db(iexp).sessionType) ' S' num2str(db(iexp).session)], ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                xlabel('Cell No.', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                ylabel('Excluded Trial No.', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                zlabel('Difference in TI (bits)', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                set(gca,'FontSize', figureDetails.fontSize-2)
                subplot(3,1,3)
                plot(nanLine, 'b*', 'MarkerSize', figureDetails.markerSize)
                xlim([1 size(myData,1)])
                ylim([0 2])
                set(gca, 'YTick', [])
                %             title(['Classified Time Cells | ', ...
                %                 db.mouseName ' ST' num2str(db.sessionType) ' S' num2str(db.session)], ...
                title('Classified Time Cells', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                xlabel('Cell No.', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                ylabel('Is time cell?', ...
                    'FontSize', figureDetails.fontSize, ...
                    'FontWeight', 'bold')
                set(gca,'FontSize', figureDetails.fontSize-2)
                if ops0.multiDayAnalysis
                    print(['/Users/ananth/Desktop/figs/importantTrials/diff_TI_' ...
                        db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session) '_multiDay'],...
                        '-djpeg');
                else
                    print(['/Users/ananth/Desktop/figs/importantTrials/diff_TI_' ...
                        db(iexp).mouseName '_' num2str(db(iexp).sessionType) '_' num2str(db(iexp).session)],...
                        '-djpeg');
                end
                
            end
            disp('... done!')
        end
    end
end
toc
disp('All done!')
%profile viewer