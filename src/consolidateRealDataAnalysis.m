% AUTHOR: Kambadur Ananthamurthy
% Run this function to collect outputs from independent jobs and
% consolidate them into one file.
% cDate: Harvest Date
% cRun: Harvest Number

function [memoryUsage, totalMem, elapsedTime] = consolidateRealDataAnalysis(cDate, cRun, workingOnServer, diaryOn, myProfilerTest)
if myProfilerTest
    profile on
end

tic

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

make_db_real2synth %in localCopies
%make_db_realBatch %in localCopies

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

%% Load Harvest config details
configHarvest4RealData %in localCopies

%% Consolidate analysis outputs
for job = 1:length(params)
    fprintf('Parsing output from job: %i\n', job)
    jobData = harvestAnalyzedRealData(params(job));
    if strcmpi(params(job).methodList, 'A')
        if ~params(job).trim
            cData.methodA.mAInput = jobData.mAInput;
            cData.methodA.mAOutput_batch(params(job).starti:params(job).endi) = jobData.mAOutput_batch(params(job).starti:params(job).endi);
        else
            cData.methodA.holyData.mAInput = jobData.holyData.mAInput;
            cData.methodA.holyData.mAOutput_batch(params(job).starti:params(job).endi) = jobData.holyData.mAOutput_batch(params(job).starti:params(job).endi);
        end
    elseif strcmpi(params(job).methodList, 'B')
        if ~params(job).trim
            cData.methodB.mBInput = jobData.mBInput;
            cData.methodB.mBOutput_batch(params(job).starti:params(job).endi) = jobData.mBOutput_batch(params(job).starti:params(job).endi);
        else
            cData.methodB.holyData.mBInput = jobData.holyData.mBInput;
            cData.methodB.holyData.mBOutput_batch(params(job).starti:params(job).endi) = jobData.holyData.mBOutput_batch(params(job).starti:params(job).endi);
        end
    elseif strcmpi(params(job).methodList, 'C')
        if ~params(job).trim
            cData.methodC.mCInput = jobData.mCInput;
            cData.methodC.mCOutput_batch(params(job).starti:params(job).endi) = jobData.mCOutput_batch(params(job).starti:params(job).endi);
        else
            cData.methodC.holyData.mCInput = jobData.holyData.mCInput;
            cData.methodC.holyData.mCOutput_batch(params(job).starti:params(job).endi) = jobData.holyData.mCOutput_batch(params(job).starti:params(job).endi);
        end
    elseif strcmpi(params(job).methodList, 'D')
        if ~params(job).trim
            cData.methodD.mDInput = jobData.mDInput;
            cData.methodD.mDOutput_batch(params(job).starti:params(job).endi) = jobData.mDOutput_batch(params(job).starti:params(job).endi);
        else
            cData.methodD.holyData.mDInput = jobData.holyData.mDInput;
            cData.methodD.holyData.mDOutput_batch(params(job).starti:params(job).endi) = jobData.holyData.mDOutput_batch(params(job).starti:params(job).endi);
        end
    elseif strcmpi(params(job).methodList, 'F')
        if ~params(job).trim
            cData.methodF.mFInput = jobData.mFInput;
            cData.methodF.mFOutput_batch(params(job).starti:params(job).endi) = jobData.mFOutput_batch(params(job).starti:params(job).endi);
        else
            cData.methodF.holyData.mFInput = jobData.holyData.mFInput;
            cData.methodF.holyData.mFOutput_batch(params(job).starti:params(job).endi) = jobData.holyData.mFOutput_batch(params(job).starti:params(job).endi);
        end
    else
    end
end

filename = ['realDATA_Analysis_' num2str(cDate) '_cRun' num2str(cRun) '_cData.mat' ];
fullPath4Save = strcat(saveDirec, filename);

disp('Saving everything ...')

elapsedTime = toc;
memoryUsage = whos;
nVariables = length(memoryUsage);
totalMem = 0;
for vari = 1:nVariables
    totalMem = totalMem + (memoryUsage(vari).bytes/(1024^2));
end

if myProfilerTest
    profilerStats = profile('info');
    profile -timestamp
else
    profilerStats = [];
end
profile off

save(fullPath4Save, 'cData', 'elapsedTime', 'profilerStats', '-v7.3')
%save(fullPath4Save, 'cData')
disp('... done!')

% %Information about new file
% h5info(filename, saveFolder)
% h5disp(filename, saveFolder)
disp('All done!')

end