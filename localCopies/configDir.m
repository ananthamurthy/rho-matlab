%Configure directory
%cd /home/ananth/Documents/rho-matlab/src

if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/Users/ananth/Documents/';
    HOME_DIR2 = '/Users/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end
saveFolder = strcat(saveDirec, dbase.mouseName, '/', dbase.date, '/');

if ops0.diary
    if workingOnServer == 1
        diary (strcat(HOME_DIR, '/logs/dataGenDiary'))
    else
        diary (strcat(HOME_DIR2, '/logs/dataGenDiary_', num2str(gDate), '_', num2str(gRun)))
    end
    diary on
end

%Search paths
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/CustomFunctions'))) % my custom functions
%addpath(genpath(strcat(HOME_DIR, 'rho-matlab/ImagingAnalysis/Suite2P-ananth')))
addpath(genpath(strcat(HOME_DIR, 'rho-matlab/localCopies')))