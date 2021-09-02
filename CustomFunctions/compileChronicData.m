% AUTHOR - Kambadur Ananthmurthy

function [datasetA, datasetB] = compileChronicData(mouseName, dateA, dateB, sessionA, sessionB, sessionTypeA, sessionTypeB, nFrames, trialDuration)

datasetA.mouse_name = mouseName;
datasetA.date = dateA;
datasetA.sessionType   = sessionTypeA;
datasetA.session       = sessionA;
datasetA.nFrames       = nFrames;
datasetA.trialDuration = trialDuration; %in seconds
datasetA.trialDetails = getTrialDetails(datasetA);

datasetB.mouse_name = mouseName;
datasetB.date = dateB;
datasetB.sessionType   = sessionTypeB;
datasetB.session       = sessionB;
datasetB.nFrames       = nFrames;
datasetB.trialDuration = trialDuration; %in seconds
datasetB.trialDetails = getTrialDetails(datasetB);

regDataset = sprintf('Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s_%s_plane1_%s_%s_plane1_reg.mat', ...
    mouseName, mouseName, datasetA.date, mouseName, datasetB.date);
%fprintf(regDataset)

%Daisy-chain
[overlaps] = cat_overlap();
%[overlaps] = cat_overlap(regDataset);
datasetA.roiIndices = overlaps.rois.idcs(:,1);
datasetB.roiIndices = overlaps.rois.idcs(:,2);

if length(datasetA.roiIndices) ~= length(datasetB.roiIndices)
    error("Indices do not match")
end
end