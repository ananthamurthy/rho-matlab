function jobData = harvestAnalyzedRealData(mouseName, date, params, saveFolder)

filename = sprintf('%s_%s_realDataAnalysis_method%s_batch.mat', ...
        mouseName, ...
        date, ...
        params.methodList);
% disp(filename)

fullDirec4Read = strcat(saveFolder, filename);

fprintf('Harvesting %s ...\n', filename)
jobData = load(fullDirec4Read);
disp(' ... done!')

end