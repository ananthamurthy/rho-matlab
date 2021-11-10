% Function call: "Dispatcher" by Kambadur Ananthamurthy
% This code uses actual dfbf curves from my data and analyses it for time
% cells using multiple methods
% Currently uses one session of real data, but can analyze synthetic
% datasets in batch.
% gDate: date when data generation occurred (ideally, analysis should
% happen on the same day as the generation)
% gRun: run number for data generation (multiple runs could happen on the
% same day)

function elapsedTime = runBatchAnalysis(sdcpStart, sdcpEnd, runA, runB, runC, runD, runE, runF, ...
    gDate, gRun, workingOnServer, diaryOn, profilerTest)
if profilerTest
    profile on
end

tic
close all

%% Operations
saveData                  = 1;
onlyProbeTrials           = 0; %Mostly relevant for real physiology datasets
loadSyntheticData         = 1;
doSigOnly                 = 0;

%% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end
%Additinal search paths
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions')))
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies')))
make_db %in localCopies

saveFolder = strcat(saveDirec, db.mouseName, '/', db.date, '/');

methodList = determineMethod(runA, runB, runC, runD, runE, runF);

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
trialDetails = getTrialDetails(db(1));

%% Load Synthetic Dataset config details
if loadSyntheticData
    configSynth %in localCopies
    nDatasets = length(sdcp);
end

%% Preallocation
%Method A
s.Q = [];
s.T = [];
s.timeCells = [];
s.nanList = [];
s.normQ = [];
mAOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method B
s.Mdl = [];
s.Yfit = [];
s.Q = [];
s.trainingTrials = [];
s.testingTrials = [];
s.Yfit_actual = [];
s.YfitDiff = [];
s.Yfit_2D = [];
s.Yfit_actual_2D = [];
s.YfitDiff_2D = [];
s.timeCells = [];
s.nanList = [];
s.normQ = [];
mBOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method C
%s.Q1 = [];
s.Q2 = [];
s.T = [];
%s.timeCells1 = [];
s.timeCells2 = [];
%s.timeCells3 = [];
s.timeCells4 = [];
s.nanList = [];
%s.normQ1 = [];
s.normQ2 = [];
mCOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method D
s.selectedPC = [];
s.d1 = [];
s.dx = [];
s.dt = [];
s.Q = [];
s.T = [];
s.timeCells = [];
s.nanList = [];
s.normQ = [];
mDOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method E
s.X = [];
s.X0 = [];
s.Y = [];
s.SVMModel = [];
s.Yfit = [];
s.YfitDiff = [];
s.Q = [];
s.Yfit_2D = [];
s.Yfit_actual_2D = [];
s.YfitDiff_2D = [];
s.T = [];
s.timeCells = [];
s.nanList = [];
s.normQ = [];
mEOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method F
%s.Q1 = [];
s.Q2 = [];
s.T = [];
%s.timeCells1 = [];
s.timeCells2 = [];
%s.timeCells3 = [];
s.timeCells4 = [];
s.nanList = [];
%s.normQ1 = [];
s.normQ2 = [];
mFOutput_batch = repmat(s, 1, nDatasets);
clear s

%% Main script
if loadSyntheticData %Synthetic Data
    if exist("sdo_batch", "var")
        %No need to load anything
    else
        load([saveFolder ...
            'synthDATA_' ...
            num2str(gDate), ...
            '_gRun', num2str(gRun), ...
            '_batch_', ...
            num2str(nDatasets), ...
            '.mat'], 'sdo_batch');
    end
    
    for runi = sdcpStart:1:sdcpEnd
        fprintf('Dataset: %i\n', runi)
        
        myData.dfbf = sdo_batch(runi).syntheticDATA;
        myData.dfbf_2D = sdo_batch(runi).syntheticDATA_2D;
        myData.baselines = zeros(size(sdo_batch(runi).syntheticDATA)); %initialization
        nCells = size(myData.dfbf_2D, 1);
        
        %Lookout for NaNs - runs even if no method is specified; without
        %interfering with analysis
        %Lookout for NaNs
        nanTest_input.nCells = nCells;
        nanTest_input.dataDesc = sprintf('Loaded Synthetic Dataset %i', runi);
        nanTest_input.dimensions = '2D';
        [~] = lookout4NaNs(myData.dfbf_2D, nanTest_input);
        
        %Significant-Only Traces
        if doSigOnly
            if onlyProbeTrials
                disp('Only analysing Probe Trials ...')
                dfbf_sigOnly = findSigOnly(myData.dfbf(:, iProbeTrials, :));
            else
                dfbf_sigOnly = findSigOnly(myData.dfbf);
            end
            DATA = dfbf_sigOnly;
        else
            DATA = myData.dfbf;
        end
        
        % Analysis Pipelines
        if runA
            %disp('--> Method: A')
            %Method A - Mehrab's Reliability Analysis (Bhalla Lab)
            mAInput.cellList = 1:1:size(DATA,1); %using all cells
            mAInput.onFrame = sdcp(runi).startFrame;
            mAInput.offFrame = sdcp(runi).endFrame;
            %mAInput.ridgeHalfWidth = ((mAInput.offFrame - mAInput.onFrame) * (1000/db(1).samplingRate))/2; %in ms
            mAInput.ridgeHalfWidth = 100; %in ms
            %fprintf('ridgeHalfWidth: %.4e\n', mAInput.ridgeHalfWidth)
            mAInput.nIterations = 5000; % number of iterations of randomisation used to find averaged r-shifted rb ratio - might have to go as high as 3000.
            mAInput.selectNonOverlappingTrials = 1; %1 - non-overlapping trial sets used for kernel estimation and rb ratio calculation, 0 - all trials used for both
            mAInput.earlyOnly = 0; %0 - uses all trials; 1 - uses only the first 5 trials of the session
            mAInput.startTrial = 1; %the analysis begins with this trial number (e.g. - 1: analysis on all trials)
            [mAOutput] = runMehrabR2BAnalysis(DATA, mAInput, trialDetails);
            mAOutput.normQ = (mAOutput.Q)/max(mAOutput.Q(~isinf(mAOutput.Q)));
            mAOutput_batch(runi) = mAOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodA.mat' ], 'mAInput', 'mAOutput')
        end
        
        % ----
        if runB
            %disp('--> Method: B')
            %Method B - William Mau's Temporal Information (Eichenbaum Lab)
            mBInput.delta = 3;
            mBInput.whichTrials = 'alternate';
            mBInput.labelShuffle = 'off';
            mBInput.distribution4Bayes = 'mvmn'; %options:'kernel', 'mv', 'mvmn', or 'normal'
            mBInput.saveModel = 0;
            mBInput.nIterations = 1000;
            mBInput.startFrame = sdcp(runi).startFrame;
            mBInput.endFrame = sdcp(runi).endFrame;
            mBInput.threshold = 99; %in %
            if ~mBInput.saveModel
                try
                    mBOutput_batch = rmfield(mBOutput_batch, 'Mdl');
                catch
                end
            end
            mBInput.getT = 0; %Set this off, unless you have GPU power on your machine
            [mBOutput] = runWilliamTIAnalysis(DATA, mBInput);
            mBOutput.normQ = (mBOutput.Q)/max(mBOutput.Q);
            mBOutput_batch(runi) = mBOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodB.mat' ], 'mBInput', 'mBOutput')
        end
        
        % ----
        if runC
            %disp('--> Method: C')
            %Method C - Simple Analysis
            mCInput.delta = 3;
            mCInput.skipFrames = [];
            mCInput.nIterations = 1000;
            mCInput.startFrame = sdcp(runi).startFrame;
            mCInput.endFrame = sdcp(runi).endFrame;
            mCInput.threshold = 99; %in %
            [mCOutput] = runSimpleTCAnalysis(DATA, mCInput);
            %mCOutput.normQ1 = (mCOutput.Q1)/max(mCOutput.Q1);
            mCOutput.normQ2 = (mCOutput.Q2)/max(mCOutput.Q2);
            mCOutput_batch(runi) = mCOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodC.mat' ], 'mCInput', 'mCOutput')
        end
        
        % ----
        if runD
            %disp('--> Method: D')
            %Method D - Arnaud Malvache' PCA based Analysis for Sequences
            mDInput.delta = 3;
            mDInput.skipFrames = [];
            mDInput.gaussianSmoothing = 1; %logical; "is this necessary?"!!!!!!!!
            mDInput.nSamples = 5; %for Gaussian Kernel
            mDInput.automatic = 1; %for selecting P; logical
            mDInput.timeVector = (1:db(1).nFrames*size(DATA,2)) * (1/db(1).samplingRate); %in seconds; %For derivative
            mDInput.getT = 0;
            mDInput.use1PC = 1;
            [mDOutput] = runSeqBasedTCAnalysis(DATA, mDInput);
            mDOutput.normQ = (mDOutput.Q) ./max(mDOutput.Q);
            mDOutput_batch(runi) = mDOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodD.mat' ], 'mDInput', 'mDOutput')
        end
        
        % ----
        if runE
            %disp('--> Method: E')
            %Method E - SVM based classification of cells
            mEInput.delta = 3;
            mEInput.skipFrames = [];
            mEInput.gaussianSmoothing = 0; %logical
            mEInput.nSamples = 5; %for Gaussian Kernel; relevant only if gaussian smoothing is on
            mEInput.whichTrials = 'alternate';
            mEInput.labelShuffle = 'off';
            mEInput.getT = 0;
            if loadSyntheticData
                mEInput.ptcList = sdo_batch(runi).ptcList;
                mEInput.ocList = sdo_batch(runi).ocList;
            else
                if strcmpi(mEInput.whichCells, 'timeCells')
                    mEInput.ptcList = input('Enter Time Cell List: ');
                elseif strcmpi(mEInput.whichCells, 'otherCells')
                    mEInput.ocList = input('Enter Other Cell List: ');
                end
            end
            mEInput.saveModel = 0;
            if ~mEInput.saveModel
                try
                    mEOutput_batch = rmfield(mEOutput_batch, 'SVMModel');
                catch
                end
            end
            [mEOutput] = runSVMClassification(DATA, mEInput);
            mEOutput.normQ = (mEOutput.Q) ./max(mEOutput.Q);
            mEOutput_batch(runi) = mEOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodE.mat' ], 'mEInput', 'mEOutput')
        end
        
        % ----
        if runF
            %disp('--> Method: F')
            %Method F - Derived Parametric Equations
            mFInput.delta = 3;
            mFInput.skipFrames = [];
            mFInput.alpha = 10;
            mFInput.beta = 1;
            mFInput.gamma = 10;
            mFInput.nIterations = 1000;
            mFInput.startFrame = sdcp(runi).startFrame;
            mFInput.endFrame = sdcp(runi).endFrame;
            mFInput.threshold = 99; %in %s
            [mFOutput] = runDerivedQAnalysis(DATA, mFInput);
            %mFOutput.normQ1 = (mFOutput.Q1)/max(mFOutput.Q1);
            mFOutput.normQ2 = (mFOutput.Q2)/max(mFOutput.Q2);
            mFOutput_batch(runi) = mFOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodF.mat' ], 'mFInput', 'mFOutput')
        end
    end
else %Real Physiology Data
    nDatasets = length(db);
    for runi = 1:nDatasets
        %This needs an update to verify proper handling of multiple real physiology datasets.
        %Load processed data (processed dfbf for dataset/session)
        myData = load([saveFolder db(runi).mouseName '_' db(runi).date '.mat']);
        nCells = size(myData.dfbf_2D, 1); %even myData.dfbf will work
        nanTest_input.nCells = nCells;
        %anTest_input.dataDesc = sprintf('Loaded Physiology Dataset %i', runi);
        nanTest_input.dataDesc = 'Loaded Physiology Dataset';
        nanTest_input.dimensions = '2D';
        [~] = lookout4NaNs(myData.dfbf_2D, nanTest_input);
        
        %Significant-Only Traces
        if doSigOnly
            if ops0.onlyProbeTrials
                disp('Only analysing Probe Trials ...')
                dfbf_sigOnly = findSigOnly(myData.dfbf(:, iProbeTrials, :));
            else
                dfbf_sigOnly = findSigOnly(myData.dfbf);
            end
            DATA = dfbf_sigOnly;
        else
            DATA = myData.dfbf;
        end
        
        % Analysis Pipelines
        if runA
            %disp('--> Method: A')
            %Method A - Mehrab's Reliability Analysis (Bhalla Lab)
            mAInput.cellList = 1:1:size(DATA,1); %using all cells
            mAInput.onFrame = 1;
            mAInput.offFrame = db(runi).nFrames;
            mAInput.ridgeHalfWidth = 100; %in ms
            mAInput.nIterations = 5000; % number of iterations of randomisation used to find averaged r-shifted rb ratio - might have to go as high as 3000.
            mAInput.selectNonOverlappingTrials = 1; %1 - non-overlapping trial sets used for kernel estimation and rb ratio calculation, 0 - all trials used for both
            mAInput.earlyOnly = 0; %0 - uses all trials; 1 - uses only the first 5 trials of the session
            mAInput.startTrial = 1; %the analysis begins with this trial number (e.g. - 1: analysis on all trials)
            [mAOutput] = runMehrabR2BAnalysis(DATA, mAInput, trialDetails);
            mAOutput.normQ = (mAOutput.Q)/max(mAOutput.Q(~isinf(mAOutput.Q)));
            mAOutput_batch(runi) = mAOutput;
            %save([saveFolder db(runi).mouseName '_' db(runi).date '_methodA.mat' ], 'mAInput', 'mAOutput')
        end
        
        % ----
        if runB
            %disp('--> Method: B')
            %Method B - William Mau's Temporal Information (Eichenbaum Lab)
            mBInput.delta = 3;
            mBInput.whichTrials = 'alternate';
            mBInput.labelShuffle = 'off';
            mBInput.distribution4Bayes = 'mvmn'; %options:'kernel', 'mv', 'mvmn', or 'normal'
            mBInput.saveModel = 0;
            mBInput.nIterations = 1000;
            mBInput.startFrame = 1;
            mBInput.endFrame = db(runi).nFrames;
            mBInput.threshold = 99; %in %
            if ~mBInput.saveModel
                try
                    mBOutput_batch = rmfield(mBOutput_batch, 'Mdl');
                catch
                end
            end
            mBInput.getT = 0;
            [mBOutput] = runWilliamTIAnalysis(DATA, mBInput);
            mBOutput.normQ = (mBOutput.Q)/max(mBOutput.Q);
            mBOutput_batch(runi) = mBOutput;
            %save([saveFolder db(runi).mouseName '_' db(runi).date '_methodB.mat' ], 'mBInput', 'mBOutput')
        end
        
        % ----
        if runC
            %disp('--> Method: C')
            %Method C - Simple Analysis
            mCInput.delta = 3;
            mCInput.skipFrames = [];
            mCInput.nIterations = 1000;
            mCInput.startFrame = 1;
            mCInput.endFrame = db(runi).nFrames;
            mCInput.threshold = 99; %in %
            [mCOutput] = runSimpleTCAnalysis(DATA, mCInput);
            %mCOutput.normQ1 = (mCOutput.Q1)/max(mCOutput.Q1);
            mCOutput.normQ2 = (mCOutput.Q2)/max(mCOutput.Q2);
            mCOutput_batch(runi) = mCOutput;
            %save([saveFolder db(runi).mouseName '_' db.date '_methodC.mat' ], 'mCInput', 'mCOutput')
        end
        
        % ----
        if runD
            %disp('--> Method: D')
            %Method D - Arnaud Malvache' PCA based Analysis for Sequences
            mDInput.delta = 3;
            mDInput.skipFrames = [];
            mDInput.gaussianSmoothing = 1; %logical
            mDInput.nSamples = 5; %for Gaussian Kernel
            mDInput.automatic = 0; %for selecting PC; logical
            mDInput.timeVector = (1:db(runi).nFrames*size(DATA,2)) * (1/db(runi).samplingRate); %in seconds; %For derivative
            mDInput.getT = 1;
            [mDOutput] = runSeqBasedTCAnalysis(DATA, mDInput);
            mDOutput.normQ = (mDOutput.Q) ./max(mDOutput.Q);
            mDOutput_batch(runi) = mDOutput;
            %save([saveFolder db(runi).mouseName '_' db(runi).date '_methodD.mat' ], 'mDInput', 'mDOutput')
        end
        
        % ----
        if runE
            %disp('--> Method: E')
            %Method E - SVM based classification of cells
            mEInput.delta = 3;
            mEInput.skipFrames = [];
            mEInput.gaussianSmoothing = 0; %logical
            mEInput.nSamples = 5; %for Gaussian Kernel; relevant only if gaussian smoothing is on
            mEInput.whichTrials = 'alternate';
            mEInput.labelShuffle = 'off';
            mEInput.getT = 0;
            if ops0.loadSyntheticData
                mEInput.ptcList = sdo_batch(runi).ptcList;
                mEInput.ocList = sdo_batch(runi).ocList;
            else
                if strcmpi(mEInput.whichCells, 'timeCells')
                    mEInput.ptcList = input('Enter Time Cell List: ');
                elseif strcmpi(mEInput.whichCells, 'otherCells')
                    mEInput.ocList = input('Enter Other Cell List: ');
                end
            end
            
            mEInput.saveModel = 0;
            if ~mEInput.saveModel
                try
                    mEOutput_batch = rmfield(mEOutput_batch, 'SVMModel');
                catch
                end
            end
            [mEOutput] = runSVMClassification(DATA, mEInput);
            mEOutput.normQ = (mEOutput.Q) ./max(mEOutput.Q);
            mEOutput_batch(runi) = mEOutput;
            %save([saveFolder db(runi).mouseName '_' db(runi).date '_methodE.mat' ], 'mEInput', 'mEOutput')
        end
        
        % ----
        if runF
            %disp('--> Method: F')
            %Method F - Derived Parametric Equations
            mFInput.delta = 3;
            mFInput.skipFrames = [];
            mFInput.alpha = 10;
            mFInput.beta = 1;
            mFInput.gamma = 10;
            mFInput.nIterations = 1000;
            mFInput.startFrame = 1;
            mFInput.endFrame = db(runi).nFrames;
            mFInput.threshold = 99; %in %s
            [mFOutput] = runDerivedQAnalysis(DATA, mFInput);
            %mFOutput.normQ1 = (mFOutput.Q1)/max(mFOutput.Q1);
            mFOutput.normQ2 = (mFOutput.Q2)/max(mFOutput.Q2);
            mFOutput_batch(runi) = mFOutput;
            %save([saveFolder db(runi).mouseName '_' db(runi).date '_methodF.mat' ], 'mFInput', 'mFOutput')
        end
    end
end
elapsedTime = toc;
if profilerTest
    profilerStats = profile('info');
    profile -timestamp
else
    profilerStats = [];
end
profile off
%% Save Data
% If no method is specified, "analysis" will not save anything since no
% analysis would have been run.
if saveData
    disp('Saving everything ...')
    if loadSyntheticData
        if runA
            save([saveFolder db.mouseName ...
                '_' db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodA_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mAInput', ...
                'mAOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runB
            save([saveFolder db.mouseName ...
                '_' db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodB_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mBInput', ...
                'mBOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runC
            save([saveFolder db.mouseName '_' ...
                db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodC_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mCInput', ...
                'mCOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runD
            save([saveFolder db.mouseName '_' ...
                db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodD_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mDInput', ...
                'mDOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runE
            save([saveFolder db.mouseName '_' ...
                db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodE_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mEInput', ...
                'mEOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runF
            save([saveFolder db.mouseName '_' ...
                db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodF_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mFInput', ...
                'mFOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        fprintf('Complete: %i to %i by %s [gDate:%i, gRun:%i]\n', sdcpStart, sdcpEnd, methodList, gDate, gRun);
        
    else %Real Physiology Data
        rightNow = datestr(datetime('now'));
        rightNow_noSpace = rightNow(find(~isspace(rightNow)));
        if runA
            save([saveFolder 'realDataAnalysis_methodA_batch' rightNow_noSpace '.mat' ], ...
                'mAInput', ...
                'mAOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runB
            save([saveFolder 'realDataAnalysis_methodB_batch' rightNow_noSpace '.mat' ], ...
                'mBInput', ...
                'mBOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runC
            save([saveFolder 'realDataAnalysis_methodC_batch' rightNow_noSpace '.mat' ], ...
                'mCInput', ...
                'mCOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runD
            save([saveFolder 'realDataAnalysis_methodD_batch' rightNow_noSpace '.mat' ], ...
                'mDInput', ...
                'mDOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runE
            save([saveFolder 'realDataAnalysis_methodE_batch' rightNow_noSpace '.mat' ], ...
                'mEInput', ...
                'mEOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        if runF
            save([saveFolder 'realDataAnalysis_methodF_batch' rightNow_noSpace '.mat' ], ...
                'mFInput', ...
                'mFOutput_batch', ...
                'elapsedTime', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        fprintf('Complete: Batch Analysis of Real Physiology Datasets by %s on %s\n', methodList, rightNow_noSpace);
    end
    disp('... done!')
end

%emptyOutput = []; %Shell scripts seem to like this; unnecessary for the actual analysis runs.

if diaryOn
    diary off
end

end