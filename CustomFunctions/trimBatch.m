% AUTHOR: Kambadur Ananthamurthy
% trimRun: Trim run number

function trimBatch(trimRun)

tic
HOME_DIR = '/home/bhalla/ananthamurthy';
ANALYSIS_DIR = '/home/bhalla/ananthamurthy/Work/Analysis';
addpath(strcat(HOME_DIR, '/MATLAB/ImagingAnalysis/Suite2P-ananth/localCopies'))
addpath(genpath(strcat(HOME_DIR, '/MATLAB/CustomFunctions'))) % my custom functions

disp('Picking up details of the primary/real dataset...')
make_db
disp('... done!')

saveFolder = strcat(ANALYSIS_DIR, '/Imaging/', db.mouseName, '/', db.date, '/');

disp('Picking up details for trim ...')
setupTrimParams
disp('... done!')

for job = 1:length(params)
    fprintf('Parsing output from job: %i ...\n', job)
    holyData = exorciseModel(db, params(job));
    
    if strcmpi(params(job).methodList, 'B') && isfield(holyData.mBOutput_batch, 'Mdl')
        error('The Exorcism has failed')
    end
    
    if strcmpi(params(job).methodList, 'E') && isfield(holyData.mEOutput_batch, 'SVMModel')
        error('The Exorcism has failed')
    end
    
    filename = [db.mouseName '_' db.date '_synthDataAnalysis_method' ...
        params(job).methodList '_batch_' num2str(params(job).sdcpStart) '-' ...
        num2str(params(job).sdcpEnd) '_trimRun' num2str(trimRun) '_trimmed.mat'];
    fullPath4Save = strcat(saveFolder, filename);
    
    disp('Saving trimmed file ...')
    save(fullPath4Save, ...
        'holyData', '-v7.3');
    
    %     %Information about new file
    %     h5info(filename, saveFolder)
    %     h5disp(filename, saveFolder)
    
    disp('... done!')
end
toc
disp('All done!')

end