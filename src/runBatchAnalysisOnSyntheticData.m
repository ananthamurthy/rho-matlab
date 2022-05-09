% Function call: "Dispatcher" by Kambadur Ananthamurthy
% This code uses actual dfbf curves from my data and analyses it for time
% cells using multiple methods
% Currently uses one session of real data, but can analyze synthetic
% datasets in batch.
% gDate: date when data generation occurred (ideally, analysis should
% happen on the same day as the generation)
% gRun: run number for data generation (multiple runs could happen on the
% same day)

function [memoryUsage, totalMem, elapsedTime] = runBatchAnalysisOnSyntheticData(sdcpStart, sdcpEnd, runA, runB, runC, runD, runE, runF, ...
    gDate, gRun, workingOnServer, diaryOn, profilerTest)
if profilerTest
    profile on
end

tic
%close all

%% Operations
saveData                  = 1;
onlyProbeTrials           = 0; %Mostly relevant for real physiology datasets
loadSyntheticData         = 1;
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
%make_db_realBatch %in localCopies

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
s.Q1 = [];
s.T1 = [];
s.timeCells1 = []; %Bootstrap
s.timeCells2 = []; %Otsu's
s.nanList1 = [];
s.negList1 = zeros(537, 135); %Boolean for emperical
s.negList2 = zeros(nDatasets, 135); %Out of 5000 for surrogate 
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
            mAInput.ridgeHalfWidth = 250; %in ms
            %fprintf('ridgeHalfWidth: %.4e\n', mAInput.ridgeHalfWidth)
            mAInput.nIterations = 10; % number of iterations of randomisation used to find averaged r-shifted rb ratio - might have to go as high as 3000.
            mAInput.selectNonOverlappingTrials = 1; %1 - non-overlapping trial sets used for kernel estimation and rb ratio calculation, 0 - all trials used for both
            mAInput.earlyOnly = 0; %0 - uses all trials; 1 - uses only the first 5 trials of the session
            mAInput.startTrial = 1; %the analysis begins with this trial number (e.g. - 1: analysis on all trials)
            mAInput.runi = runi;
            [mAOutput] = runMehrabR2BAnalysis2(DATA, mAInput, trialDetails);
            mAOutput.normQ1 = (mAOutput.Q1)/max(mAOutput.Q1(~isinf(mAOutput.Q1)));
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
            mBInput.nIterations = 100;
            mBInput.startFrame = sdcp(runi).startFrame;
            mBInput.endFrame = sdcp(runi).endFrame;
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
            mCOutput.normQ1 = (mCOutput.Q1)/max(mCOutput.Q1);
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
            mDOutput.normQ1 = (mDOutput.Q1) ./max(mDOutput.Q1);
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
            mEOutput.normQ1 = (mEOutput.Q1) ./max(mEOutput.Q1);
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
            mFOutput.normQ1 = (mFOutput.Q1)/max(mFOutput.Q1);
            mFOutput_batch(runi) = mFOutput;
            %save([saveFolder db(1).mouseName '_' db(1).date '_methodF.mat' ], 'mFInput', 'mFOutput')
        end
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
    if loadSyntheticData
        if runA
            save([saveFolder db.mouseName ...
                '_' db.date '_synthDataAnalysis_' num2str(gDate) ...
                '_gRun' num2str(gRun) '_methodA_batch_' num2str(sdcpStart) '-' ...
                num2str(sdcpEnd) '.mat' ], ...
                'mAInput', ...
                'mAOutput_batch', ...
                'elapsedTime', ...
                'memoryUsage', ...
                'totalMem', ...
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
                'memoryUsage', ...
                'totalMem', ...
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
                'memoryUsage', ...
                'totalMem', ...
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
                'memoryUsage', ...
                'totalMem', ...
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
                'memoryUsage', ...
                'totalMem', ...
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
                'memoryUsage', ...
                'totalMem', ...
                'profilerStats', ...
                '-v7.3')
        end
        
        fprintf('Complete: %i to %i by %s [gDate:%i, gRun:%i]\n', sdcpStart, sdcpEnd, methodList, gDate, gRun);
    end
    disp('... done!')
end

%emptyOutput = []; %Shell scripts seem to like this; unnecessary for the actual analysis runs.

if diaryOn
    diary off
end

end
