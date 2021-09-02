% AUTHOR - Kambadur Ananthmurthy

function [datasetA, datasetB] = loadChronicData(datasetA, datasetB)
%% Get datasets
disp('Getting datasets ...')

load(sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%s_%s_C.mat', ...
    datasetA.mouse_name, datasetA.date, datasetA.mouse_name, datasetA.date))
datasetA.data = dfbf(datasetA.roiIndices,:,:);
datasetA.data_2D = dfbf_2D(datasetA.roiIndices,:);

datasetB.trialDetails = getTrialDetails(datasetB);
load(sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%s_%s_C.mat', ...
    datasetB.mouse_name, datasetB.date, datasetB.mouse_name, datasetB.date))
datasetB.data = dfbf(datasetB.roiIndices,:,:);
datasetB.data_2D = dfbf_2D(datasetB.roiIndices,:);
disp('... done!')

%Significant-only
datasetA.data_sigOnly = findSigOnly(datasetA.data);
datasetB.data_sigOnly = findSigOnly(datasetB.data);

%Trial Averaged
datasetA.trialAvg = squeeze(mean(datasetA.data,2));
datasetB.trialAvg = squeeze(mean(datasetB.data,2));

end