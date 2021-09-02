% AUTHOR: Kambadur Ananthamurthy
% Use this function to use "rmfield" to remove any field from a data
% structure
% db has has variables concerning the original, real dataset
% params has variables concerning the exorcism

function holyData = exorciseModel(db, params)
filename = sprintf('%s_%s_synthDataAnalysis_method%s_batch_%i-%i.mat', ...
    db.mouseName, ...
    db.date, ...
    params.methodList, ...
    params.sdcpStart, ...
    params.sdcpEnd);
fullDirec4Read = strcat(params.fileLocation, filename);

fprintf('Loading %s ...\n', filename)
holyData = load(fullDirec4Read);
disp('... done!')
fprintf('Trimming %s ...\n', filename)

if strcmpi(params.methodList, 'B')
    if isfield(holyData.mBOutput_batch, 'Mdl')
        try
            holyData.mBOutput_batch = rmfield(holyData.mBOutput_batch, 'Mdl');
        catch
            fprintf('Method: %s\n', params.methodList)
            fprintf('Dataset: %i\n', dataset)
            fieldnames(holyData(dataset).mBOutput_batch)
            error('Unable to delete "Mdl"')
        end
    else
        disp('Skipping to next dataset ...')
    end
elseif strcmpi(params.methodList, 'E')
    if isfield(holyData.mEOutput_batch, 'SVMModel')
        try
            holyData.mEOutput_batch = rmfield(holyData.mEOutput_batch, 'SVMModel');
        catch
            fprintf('Method: %s\n', params.methodList)
            fprintf('Dataset: %i\n', dataset)
            fieldnames(holyData(dataset).mEOutput_batch)
            error('Unable to delete "SVMModel"')
        end
    else
        disp('Skipping to next dataset ...')
    end
end
disp('... done!')
end