%"Dispatcher" by Kambadur Ananthamurthy
% This code uses actual dfbf curves from my data and analyses it for time
% cells using multiple methods
% Currently uses one session of real data, but can analyze synthetic
% datasets in batch.

tic
clear
close all

%% Addpaths
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))
addpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth/localCopies')

%% Main Real Dataset
make_db %Currently only one session at a time
fprintf('Analyzing %s_%i_%i - Date: %s\n', db.mouseName, ...
    db.sessionType, ...
    db.session, ...
    db.date)

saveDirec = '/Users/ananth/Desktop/Work/Analysis/Imaging/';
saveFolder = [saveDirec db.mouseName '/' db.date '/'];

ops0.saveData                  = 1;
ops0.onlyProbeTrials           = 0;
ops0.loadSyntheticData         = 1;
ops0.doSigOnly                 = 0;
ops0.comment                   = ''; %No spaces or "-"; capitalization is handled

if ops0.loadSyntheticData
    setupSyntheticDataParameters_batch
end

%% Preallocation
%Method A
s.Q = [];
s.T = [];
s.timeCells = [];
s.normQ = [];
mAOutput_batch = repmat(s, 1, length(sdcp));
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
s.normQ = [];
mBOutput_batch = repmat(s, 1, length(sdcp));
clear s

%Method C
s.Q1 = [];
s.Q2 = [];
s.T = [];
s.timeCells = [];
s.normQ1 = [];
s.normQ2 = [];
mCOutput_batch = repmat(s, 1, length(sdcp));
clear s

%Method D
s.selectedPC = [];
s.d1 = [];
s.dx = [];
s.dt = [];
s.Q = [];
s.T = [];
s.normQ = [];
s.timeCells = [];
mDOutput_batch = repmat(s, 1, length(sdcp));
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
s.Q_2D = [];
s.T = [];
s.timeCells = [];
mEOutput_batch = repmat(s, 1, length(sdcp));
clear s

%% Main script
for runi = 1: 1: length(sdcp)
    fprintf('Currently running parameter set: %i\n', runi)
    
    if ops0.loadSyntheticData
        load([saveFolder ...
            'synthDATA' ...
            '_batch_', ...
            lower(ops0.comment), ...
            '.mat']);
        myData.dfbf = sdo_batch(runi).syntheticDATA;
        myData.dfbf_2D = sdo_batch(runi).syntheticDATA_2D;
        myData.baselines = zeros(size(sdo_batch(runi).syntheticDATA)); %initialization
    else
        %Load processed data (processed dfbf for dataset/session)
        myData = load([saveFolder db.mouseName '_' db.date '.mat']);
    end
    trialDetails = getTrialDetails(db);
    
    %Significant-Only Traces
    if ops0.doSigOnly
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
    
    %% Analysis Pipelines
    %Method A - Mehrab's Reliability Analysis (Bhalla Lab)
    mAInput.cellList = 1:1:size(DATA,1); %using all cells
    mAInput.onFrame = sdcp.startFrame;
    mAInput.offFrame = sdcp.endFrame;
    mAInput.ridgeHalfWidth = 100; %in ms
    mAInput.nIterations = 5000; %number of iterations of randomisation used to find averaged r-shifted rb ratio - might have to go as high as 3000.
    mAInput.selectNonOverlappingTrials = 1; %1 - non-overlapping trial sets used for kernel estimation and rb ratio calculation, 0 - all trials used for both
    mAInput.earlyOnly = 0; %0 - uses all trials; 1 - uses only the first 5 trials of the session
    mAInput.startTrial = 1; %the analysis begins with this trial number (e.g. - 1: analysis on all trials)
    [mAOutput] = runMehrabR2BAnalysis(DATA, mAInput, trialDetails);
    mAOutput.normQ = (mAOutput.Q)/max(mAOutput.Q(~isinf(mAOutput.Q)));
    
    %save([saveFolder db.mouseName '_' db.date '_methodA.mat' ], 'mAInput', 'mAOutput')
    
    % ----
    %Method B - William Mau's Temporal Information (Eichenbaum Lab)
    mBInput.delta = 3;
    mBInput.whichTrials = 'alternate';
    mBInput.labelShuffle = 'off';
    mBInput.distribution4Bayes = 'mvmn';
    [mBOutput] = runWilliamTIAnalysis(DATA, mBInput);
    mBOutput.normQ = (mBOutput.Q)/max(mBOutput.Q);
    
    %save([saveFolder db.mouseName '_' db.date '_methodB.mat' ], 'mBInput', 'mBOutput')
    
    % ----
    %Method C - Simple Analysis
    mCInput.delta = 3;
    mCInput.skipFrames = [];
    mCInput.trialThreshold = 25; % in %
    [mCOutput] = runSimpleTCAnalysis(DATA, mCInput);
    mCOutput.normQ1 = (mCOutput.Q1)/max(mCOutput.Q1);
    mCOutput.normQ2 = (mCOutput.Q2)/max(mCOutput.Q2);
    
    %save([saveFolder db.mouseName '_' db.date '_methodC.mat' ], 'mCInput', 'mCOutput')
    
    % ----
    %Method D - Arnaud Malvache' PCA based Analysis for Sequences
    mDInput.delta = 3;
    mDInput.skipFrames = [];
    mDInput.gaussianSmoothing = 1; %logical
    mDInput.nSamples = 5; %for Gaussian Kernel
    mDInput.automatic = 1; %for selecting P; logical
    mDInput.timeVector = (1:db.nFrames*size(DATA,2)) * (1/db.samplingRate); %in seconds; %For derivative
    [mDOutput] = runSeqBasedTCAnalysis(DATA, mDInput);
    mDOutput.normQ = (mDOutput.Q) ./max(mDOutput.Q);
    
    %save([saveFolder db.mouseName '_' db.date '_methodD.mat' ], 'mDInput', 'mDOutput')
    
    % ----
    %Method E - SVM based classification of cells
    mEInput.delta = 3;
    mEInput.skipFrames = [];
    mEInput.gaussianSmoothing = 0; %logical
    mEInput.nSamples = 5; %for Gaussian Kernel; relevant only if gaussian smoothing is on
    mEInput.whichTrials = 'alternate';
    mEInput.labelShuffle = 'off';
    if ops0.loadSyntheticData
        mEInput.ptcList = sdo.ptcList;
        mEInput.ocList = sdo.ocList;
    else
        if strcmpi(mEInput.whichCells, 'timeCells')
            mEInput.ptcList = input('Enter Time Cell List: ');
        elseif strcmpi(mEInput.whichCells, 'otherCells')
            mEInput.ocList = input('Enter Other Cell List: ');
        end
    end
    [mEOutput] = runSVMClassification(DATA, mEInput);
    
    %save([saveFolder db.mouseName '_' db.date '_methodE.mat' ], 'mEInput', 'mEOutput')
    
    %Collate
    mAOutput_batch(runi) = mAOutput;
    mBOutput_batch(runi) = mBOutput;
    mCOutput_batch(runi) = mCOutput;
    mDOutput_batch(runi) = mDOutput;
    mEOutput_batch(runi) = mEOutput;
    
end

%% Save Data
if ops0.saveData
    
    if ops0.loadSyntheticData
        save([saveFolder db.mouseName '_' db.date '_synthDataAnalysis_methodA_batch.mat' ], 'mAInput', 'mAOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_synthDataAnalysis_methodB_batch.mat' ], 'mBInput', 'mBOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_synthDataAnalysis_methodC_batch.mat' ], 'mCInput', 'mCOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_synthDataAnalysis_methodD_batch.mat' ], 'mDInput', 'mDOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_synthDataAnalysis_methodE_batch.mat' ], 'mEInput', 'mEOutput_batch')
    else
        save([saveFolder db.mouseName '_' db.date '_realDataAnalysis_methodA_batch.mat' ], 'mAInput', 'mAOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_realDataAnalysis_methodB_batch.mat' ], 'mBInput', 'mBOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_realDataAnalysis_methodC_batch.mat' ], 'mCInput', 'mCOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_realDataAnalysis_methodD_batch.mat' ], 'mDInput', 'mDOutput_batch')
        save([saveFolder db.mouseName '_' db.date '_realDataAnalysis_methodE_batch.mat' ], 'mEInput', 'mEOutput_batch')
    end
end
toc