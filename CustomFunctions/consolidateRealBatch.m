% AUTHOR: Kambadur Ananthamurthy
% Run this function to collect outputs from independent jobs and
% consolidate them into one file.
% cDate: Harvest Date
% cRun: Harvest Number

function cData = consolidateRealBatch(cDate, cRun, workingOnServer)

tic

if workingOnServer
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    ANALYSIS_DIR = strcat(HOME_DIR, 'Work/Analysis');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    ANALYSIS_DIR = strcat(HOME_DIR2, 'Work/Analysis');
end

addpath(strcat(HOME_DIR, '/MATLAB/ImagingAnalysis/Suite2P-ananth/localCopies'))
addpath(genpath(strcat(HOME_DIR, '/MATLAB/CustomFunctions'))) % my custom functions

disp('Loading main dataset details ...')
make_dbase
nDatasets = length(dbase);
disp('... done!')

disp('Setting up parameters for harvest ...')
setupHarvestParamsforRealData
disp('... done!')

for dataseti = 1:nDatasets
    for job = 1:length(params)
        fprintf('Parsing output from job %i for dataset %i\n', job, dataseti)
        mouseName = dbase(dataseti).mouseName;
        date = dbase(dataseti).date;
        saveFolder = strcat(ANALYSIS_DIR, '/Imaging/', mouseName, '/', date, '/');
        jobData = harvestAnalyzedRealData(mouseName, date, params(job), saveFolder);
        if strcmpi(params(job).methodList, 'A')
            cData(dataseti).methodA.mAOutput_batch = jobData.mAOutput_batch;
        elseif strcmpi(params(job).methodList, 'B')
            cData(dataseti).methodB.mBOutput_batch = jobData.mBOutput_batch;
        elseif strcmpi(params(job).methodList, 'C')
            cData(dataseti).methodC.mCOutput_batch = jobData.mCOutput_batch;
        elseif strcmpi(params(job).methodList, 'D')
            cData(dataseti).methodD.mDOutput_batch = jobData.mDOutput_batch;
        elseif strcmpi(params(job).methodList, 'E')
            cData(dataseti).methodE.mEOutput_batch = jobData.mEOutput_batch;
        elseif strcmpi(params(job).methodList, 'F')
            cData(dataseti).methodF.mFOutput_batch = jobData.mFOutput_batch;
        else
            error('Unknown method')
        end
    end
    filename = [mouseName '_' date '_comparativeRealDataAnalysis_' num2str(cDate) '_cRun' num2str(cRun) '_cData.mat' ];
    saveFolder = strcat(ANALYSIS_DIR, '/Imaging/', mouseName, '/', date, '/');
    fullPath4Save = strcat(saveFolder, filename);
end

if nDatasets > 1
    %Save
    filename = [mouseName '_comparativeRealDataAnalysis_' num2str(cDate) '_cRun' num2str(cRun) '_cData.mat' ];
    saveFolder2 = strcat(ANALYSIS_DIR, '/Imaging/', mouseName, '/'); %ignores date
    fullPath4Save = strcat(saveFolder2, filename);
end

disp('Saving everything ...')

save(fullPath4Save, 'cData', '-v7.3')
%save(fullPath4Save, 'cData')
disp('... done!')

% %Information about new file
% h5info(filename, saveFolder)
% h5disp(filename, saveFolder)

toc
disp('All done!')

end