
% close all
% clear

% tic
function [Y, X] = developConfusionMatrix(input)
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))

make_db

workingOnServer = 0;

if workingOnServer
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    ANALYSIS_DIR = strcat(HOME_DIR, 'Work/Analysis');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    ANALYSIS_DIR = strcat(HOME_DIR2, 'Work/Analysis');
end

%Automate for reading HOME_DIR and HOME_DIR2
addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis/Suite2P-ananth'))

nCells = input.nCells;
nAlgos = input.nAlgos;

%figureDetails = compileFigureDetails(16, 2, 5, 0.5, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)
%Extra colormap options: inferno/plasma/viridis/magm
%C = distinguishable_colors(nAlgos);

% Load Synthetic Data
disp('Loading synthetic datasets ...')
% gDate = 20210628; %generation date
% gRun = 1; %generation run number
% nDatasets = 80;
gDate = input.gDate; %generation date
gRun = input.gRun; %generation run number
nDatasets = input.nDatasets;
synthDataFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/synthDATA_%i_gRun%i_batch_%i.mat', gDate, gRun, nDatasets);
load(synthDataFilePath)
disp('... done!')

% Load Analysis Results
disp('Loading analysis results ...')
% cDate = 20210629; %consolidation date
% cRun = 1; %consolidation run number
cDate = input.cDate; %consolidation date
cRun = input.cRun; %consolidation run number
analysisFilePath = sprintf('/Users/ananth/Desktop/Work/Analysis/Imaging/M26/20180514/M26_20180514_synthDataAnalysis_%i_cRun%i_cData.mat', cDate, cRun);
load(analysisFilePath)
disp('... done!')

% Prepare Look Up Table (lut)
disp('Creating Look Up Table ...')
preLUT = zeros(nCells*nDatasets, nAlgos+1);

reality = zeros(nDatasets, nCells);

count = 0;
for dnum = 1:nDatasets
    count = count + 1;
    start = ((count-1)*nCells + 1);
    finish = count*nCells;
    %fprintf('Start = %i, Finish = %i\n', start, finish)
    
    reality = zeros(nCells, 1); %Preallocate
    reality(sdo_batch(dnum).ptcList) = 1; %Ground Truth
    
    for algo = 1:nAlgos+1
        if algo == 1
            preLUT(start:finish, algo) = reality;
        elseif algo == 2
            preLUT(start:finish, algo) = squeeze(cData.methodA.mAOutput_batch(dnum).timeCells);
        elseif algo == 3
            preLUT(start:finish, algo) = squeeze(cData.methodB.mBOutput_batch(dnum).timeCells);
        elseif algo == 4
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells2);
        elseif algo == 5
            preLUT(start:finish, algo) = squeeze(cData.methodC.mCOutput_batch(dnum).timeCells4);
        elseif algo == 6
            preLUT(start:finish, algo) = squeeze(cData.methodD.mDOutput_batch(dnum).timeCells);
        elseif algo == 7
            preLUT(start:finish, algo) = squeeze(cData.methodE.mEOutput_batch(dnum).timeCells);
        elseif algo == 8
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells2);
        elseif algo == 9
            preLUT(start:finish, algo) = squeeze(cData.methodF.mFOutput_batch(dnum).timeCells4);
        end
    end
end
if input.removeNaNs
    %Edit out NaNs as O
    reshapedLUT = reshape(preLUT, [], 1);
    reshapedLUT(isnan(reshapedLUT)) = 0;
    LUT = reshape(reshapedLUT, size(preLUT));
else
    LUT = preLUT;
end

Y = LUT(:, 1); %Truth
X = LUT(:, 2:input.nAlgos+1);

disp('... done!')

end
% toc
