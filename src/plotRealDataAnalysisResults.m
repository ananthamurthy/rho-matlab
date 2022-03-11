% Load the Consolidated Analysis Details and look for patterns in the plots

close all
%clear

tic

datasetCatalog = 1;

if datasetCatalog == 1
    cDate = 20220311;
    cRun = 1;
%else
end

workingOnServer = 0;
% Directory config
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

addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions'))

make_db_realBatch %in localCopies

%Load analysis output
fullFilePath = sprintf('%srealDATA_Analysis_%i_cRun%i_cData.mat', saveDirec, cDate, cRun);
load(fullFilePath)

%PLOTS

figureDetails = compileFigureDetails(11, 2, 5, 0.2, 'inferno'); %(fontSize, lineWidth, markerSize, transparency, colorMap)

fig1 = figure(1);
set(fig1, 'Position', [100, 100, 1200, 600])

set(gca, 'FontSize', figureDetails.fontSize)

elapsedTime3 = toc;
fprintf('Elapsed Time: %.4f seconds\n', elapsedTime3)
disp('... All Done!')
