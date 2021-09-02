% AUTHOR: Kambadur Ananthamurthy
% Run this function to collect outputs from independent jobs and
% consolidate them into one file.
% cDate: Harvest Date
% cRun: Harvest Number

function consolidateBatch(cDate, cRun, workingOnServer)

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
make_db
disp('... done!')

saveFolder = strcat(ANALYSIS_DIR, '/Imaging/', db.mouseName, '/', db.date, '/');

disp('Setting up parameters for harvest ...')
%setupHarvestParams %Loads all options for Parameter Sensitivity Analysis (PSA); "Unphysiological"
%setupHarvestParams2 %Loads all options for specific Synthetic Datasets (N=1*33); "BoS"
setupHarvestParams3 %Loads all options for specific Synthetic Datasets (N=8*12); "Physiological"
%setupHarvestParams4 %Loads all options for specific Synthetic Datasets (N=3*111); all out; "PSA+Physiology"
disp('... done!')

for job = 1:length(params)
    fprintf('Parsing output from job: %i\n', job)
    jobData = harvestAnalyzedData(db, params(job));
    if strcmpi(params(job).methodList, 'A')
        if ~params(job).trim
            cData.methodA.mAInput = jobData.mAInput;
            cData.methodA.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodA.holyData.mAInput = jobData.holyData.mAInput;
            cData.methodA.holyData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mAOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'B')
        if ~params(job).trim
            cData.methodB.mBInput = jobData.mBInput;
            cData.methodB.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodB.holyData.mBInput = jobData.holyData.mBInput;
            cData.methodB.holyData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mBOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'C')
        if ~params(job).trim
            cData.methodC.mCInput = jobData.mCInput;
            cData.methodC.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodC.holyData.mCInput = jobData.holyData.mCInput;
            cData.methodC.holyData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mCOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'D')
        if ~params(job).trim
            cData.methodD.mDInput = jobData.mDInput;
            cData.methodD.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodD.holyData.mDInput = jobData.holyData.mDInput;
            cData.methodD.holyData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mDOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'E')
        if ~params(job).trim
            cData.methodE.mEInput = jobData.mEInput;
            cData.methodE.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodE.holyData.mEInput = jobData.holyData.mEInput;
            cData.methodE.holyData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mEOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    elseif strcmpi(params(job).methodList, 'F')
        if ~params(job).trim
            cData.methodF.mFInput = jobData.mFInput;
            cData.methodF.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        else
            cData.methodF.holyData.mFInput = jobData.holyData.mFInput;
            cData.methodF.holyData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd) = jobData.holyData.mFOutput_batch(params(job).sdcpStart:params(job).sdcpEnd);
        end
    else
    end
end

filename = [db.mouseName '_' db.date '_synthDataAnalysis_' num2str(cDate) '_cRun' num2str(cRun) '_cData.mat' ];
fullPath4Save = strcat(saveFolder, filename);

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