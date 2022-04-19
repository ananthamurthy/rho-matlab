% Function call: "Dispatcher" by Kambadur Ananthamurthy
% This code uses actual dfbf curves from my data and analyses it for time
% cells using multiple methods
% Currently uses one session of real data, but can analyze synthetic
% datasets in batch.
% gDate: date when data generation occurred (ideally, analysis should
% happen on the same day as the generation)
% gRun: run number for data generation (multiple runs could happen on the
% same day)

function [memoryUsage, totalMem, elapsedTime] = runBatchAnalysisOnRealData(starti, endi, runA, runB, runC, runD, runE, runF, workingOnServer, diaryOn, profilerTest)

if profilerTest
    profile on
end

tic
%close all

%% Operations
saveData                  = 1;
onlyProbeTrials           = 0; %Mostly relevant for real physiology datasets
doSigOnly                 = 0;

if onlyProbeTrials
    iProbeTrials = []; %Add based on experiment
end
%% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end
%Additinal search paths
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions')))
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies')))

%make_db_real2synth %in localCopies
make_db_realBatch %in localCopies
nDatasets = endi-starti+1;

methodList = determineMethod(runA, runB, runC, runD, runE, runF);

if diaryOn
    if workingOnServer == 1
        diary (strcat(HOME_DIR, '/logs/dataGenDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/dataGenDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

%% Preallocation
%Method A
s.Q1 = [];
s.T1 = [];
s.timeCells1 = []; %Bootstrap
s.timeCells2 = []; %Otsu's
s.nanList1 = [];
s.normQ1 = [];
mAOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method B
s.Mdl = [];
s.Yfit = [];
s.Q1 = [];
s.Q2 = [];
s.Q3 = [];
s.trainingTrials = [];
s.testingTrials = [];
s.Yfit_actual = [];
s.YfitDiff = [];
s.Yfit_2D = [];
s.Yfit_actual_2D = [];
s.YfitDiff_2D = [];
s.timeCells1 = [];
s.timeCells2 = [];
s.timeCells3 = [];
s.timeCells4 = [];
s.timeCells5 = [];
s.timeCells6 = [];
s.nanList1 = [];
s.nanList2 = [];
s.nanList3 = [];
s.normQ1 = [];
s.normQ2 = [];
s.normQ3 = [];
mBOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method C
s.Q1 = [];
s.T1 = [];
s.timeCells1 = [];
s.timeCells2 = [];
s.nanList1 = [];
s.normQ1 = [];
mCOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method D
s.selectedPC = [];
s.d1 = [];
s.dx = [];
s.dt = [];
s.Q1 = [];
s.T1 = [];
s.timeCells1 = []; %Otsu's; not implementing Bootstrap for now
s.nanList1 = [];
s.normQ1 = [];
mDOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method E
s.SVMModel = [];
s.Yfit = [];
s.YfitDiff = [];
s.Q1 = [];
s.Yfit_2D = [];
s.Yfit_actual_2D = [];
s.YfitDiff_2D = [];
s.Q1_2D = [];
s.T1 = [];
s.timeCells1 = []; %Otsu's; not implementing Bootstrap for now
s.nanList1 = [];
s.normQ1 = [];
mEOutput_batch = repmat(s, 1, nDatasets);
clear s

%Method F
s.Q1 = [];
s.T1 = [];
s.timeCells1 = []; %Bootstrap
s.timeCells2 = []; %Otsu's
s.nanList1 = [];
s.normQ1 = [];
mFOutput_batch = repmat(s, 1, nDatasets);
clear s
%% Main script

%for runi = 1:nDatasets
for runi = starti:endi
    try
        fprintf('Current Dataset - %s_%i_%i | Date: %s\n', ...
            db0(runi).mouseName, ...
            db0(runi).sessionType, ...
            db0(runi).session, ...
            db0(runi).date)
    catch
        disp(runi)
    end
    trialDetails = getTrialDetails(db0(runi));

    %Load processed data (processed dfbf for dataset/session)
    myData = load([saveDirec db0(runi).mouseName '_' db0(runi).date '.mat']);
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
        if onlyProbeTrials
            disp('Only analysing Probe Trials ...')
            DATA = myData.dfbf(:, iProbeTrials, :);
        else
            DATA = myData.dfbf;
        end
    end

    % Analysis Pipelines
    if runA
        %disp('--> Method: A')
        %Method A - Mehrab's Reliability Analysis (Bhalla Lab)
        mAInput.cellList = 1:1:size(DATA,1); %using all cells
        mAInput.onFrame = db0(runi).startFrame;
        mAInput.offFrame = db0(runi).endFrame;
        %mAInput.ridgeHalfWidth = ((mAInput.offFrame - mAInput.onFrame) * (1000/db0(1).samplingRate))/2; %in ms
        mAInput.ridgeHalfWidth = 100; %in ms
        %fprintf('ridgeHalfWidth: %.4e\n', mAInput.ridgeHalfWidth)
        mAInput.nIterations = 10; % number of iterations of randomisation used to find averaged r-shifted rb ratio - might have to go as high as 3000.
        mAInput.selectNonOverlappingTrials = 1; %1 - non-overlapping trial sets used for kernel estimation and rb ratio calculation, 0 - all trials used for both
        mAInput.earlyOnly = 0; %0 - uses all trials; 1 - uses only the first 5 trials of the session
        mAInput.startTrial = 1; %the analysis begins with this trial number (e.g. - 1: analysis on all trials)
        [mAOutput] = runMehrabR2BAnalysis(DATA, mAInput, trialDetails);
        mAOutput.normQ1 = (mAOutput.Q1)/max(mAOutput.Q1(~isinf(mAOutput.Q1)));
        mAOutput_batch(runi) = mAOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodA.mat' ], 'mAInput', 'mAOutput')
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
        mBInput.startFrame = db0(runi).startFrame;
        mBInput.endFrame = db0(runi).endFrame;
        mBInput.limit2StimWindow = 1;
        mBInput.activityFilter = 1;
        mBInput.threshold = 99; %in %
        if ~mBInput.saveModel
            try
                mBOutput_batch = rmfield(mBOutput_batch, 'Mdl');
            catch
            end
        end
        mBInput.getT = 0; %Set this off, unless you have GPU power on your machine
        [mBOutput] = runWilliamTIAnalysis(DATA, mBInput);
        mBOutput.normQ1 = (mBOutput.Q1)/max(mBOutput.Q1);
        mBOutput.normQ2 = (mBOutput.Q2)/max(mBOutput.Q2);
        mBOutput.normQ3 = (mBOutput.Q3)/max(mBOutput.Q3);
        mBOutput_batch(runi) = mBOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodb0.mat' ], 'mBInput', 'mBOutput')
    end

    % ----
    if runC
        %disp('--> Method: C')
        %Method C - Simple Analysis
        mCInput.delta = 3;
        mCInput.skipFrames = [];
        mCInput.nIterations = 1000;
        mCInput.startFrame = db0(runi).startFrame;
        mCInput.endFrame = db0(runi).endFrame;
        mCInput.threshold = 99; %in %
        [mCOutput] = runSimpleTCAnalysis(DATA, mCInput);
        mCOutput.normQ1 = (mCOutput.Q1)/max(mCOutput.Q1);
        mCOutput_batch(runi) = mCOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodC.mat' ], 'mCInput', 'mCOutput')
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
        mDInput.timeVector = (1:db0(1).nFrames*size(DATA,2)) * (1/db0(1).samplingRate); %in seconds; %For derivative
        mDInput.getT = 0;
        mDInput.use1PC = 1;
        [mDOutput] = runSeqBasedTCAnalysis(DATA, mDInput);
        mDOutput.normQ1 = (mDOutput.Q1) ./max(mDOutput.Q1);
        mDOutput_batch(runi) = mDOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodD.mat' ], 'mDInput', 'mDOutput')
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
        mEOutput.normQ1 = (mEOutput.Q1) ./max(mEOutput.Q1);
        mEOutput_batch(runi) = mEOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodE.mat' ], 'mEInput', 'mEOutput')
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
        mFInput.startFrame = db0(runi).startFrame;
        mFInput.endFrame = db0(runi).endFrame;
        mFInput.threshold = 99; %in %s
        [mFOutput] = runDerivedQAnalysis(DATA, mFInput);
        mFOutput.normQ1 = (mFOutput.Q1)/max(mFOutput.Q1);
        mFOutput_batch(runi) = mFOutput;
        %save([saveDirec db0(1).mouseName '_' db0(1).date '_methodF.mat' ], 'mFInput', 'mFOutput')
    end
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
%% Save Data
% If no method is specified, "analysis" will not save anything since no
% analysis would have been run.
if saveData
    disp('Saving everything ...')
    rightNow = datestr(datetime('now'));
    rightNow_noSpace = rightNow(find(~isspace(rightNow)));
    if runA
        save([saveDirec 'realDATAAnalysis_methodA_batch_' num2str(starti) '-' ...
            num2str(endi) '.mat' ], ...
            'mAInput', ...
            'mAOutput_batch', ...
            'elapsedTime', ...
            'memoryUsage', ...
            'totalMem', ...
            'profilerStats', ...
            '-v7.3')
    end

    if runB
        save([saveDirec 'realDATAAnalysis_methodB_batch_' num2str(starti) '-' ...
            num2str(endi) '.mat' ], ...
            'mBInput', ...
            'mBOutput_batch', ...
            'elapsedTime', ...
            'totalMem', ...
            'profilerStats', ...
            '-v7.3')
    end

    if runC
        save([saveDirec 'realDATAAnalysis_methodC_batch_' num2str(starti) '-' ...
            num2str(endi) '.mat' ], ...
            'mCInput', ...
            'mCOutput_batch', ...
            'elapsedTime', ...
            'memoryUsage', ...
            'totalMem', ...
            'profilerStats', ...
            '-v7.3')
    end

    if runD
        save([saveDirec 'realDATAAnalysis_methodD_batch_' num2str(starti) '-' ...
            num2str(endi) '.mat' ], ...
            'mDInput', ...
            'mDOutput_batch', ...
            'elapsedTime', ...
            'memoryUsage', ...
            'totalMem', ...
            'profilerStats', ...
            '-v7.3')
    end

    if runF
        save([saveDirec 'realDATAAnalysis_methodF_batch_' num2str(starti) '-' ...
            num2str(endi) '.mat' ], ...
            'mFInput', ...
            'mFOutput_batch', ...
            'elapsedTime', ...
            'memoryUsage', ...
            'totalMem', ...
            'profilerStats', ...
            '-v7.3')
    end

    fprintf('Complete: Batch Analysis of Real Physiology Datasets by %s on %s\n', methodList, rightNow_noSpace);
end
disp('... done!')

%emptyOutput = []; %Shell scripts seem to like this; unnecessary for the actual analysis runs.

if diaryOn
    diary off
end

end
