% TITLE - Custom code to wrap around dodFbyF()
% AUTHOR - Kambadur Ananthamurthy

%profile on
tic
close all
%clear all
clear

workingOnServer = 0;

if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    %saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    %saveDirec = strcat(HOME_DIR2, 'Work/Analysis/Imaging/');
end

%% Addpaths
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions')) % my custom functions
addpath(genpath('/home/ananth/Desktop/Work/Analysis/Imaging')) % analysis output
addpath(genpath('/home/ananth/Documents/rho-matlab/localCopies'))

%% Operations
curateCalciumEventLibrary = 1;
saveData                  = 1;
%% Dataset
make_db_realBatch
nDatasets = length(db0);

for iexp = 1:nDatasets
    %Load Fluorescence Data - This is the ouput after running Suite2P
    try
        load(sprintf('/home/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/F_%s_%s_plane%i.mat', ...
            db0(iexp).mouseName, db0(iexp).date, db0(iexp).expts, ...
            db0(iexp).mouseName, db0(iexp).date, db0(iexp).nplanes))
    catch
        fprintf('File not found: /home/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/F_%s_%s_plane%i.mat\n', ...
            db0(iexp).mouseName, db0(iexp).date, db0(iexp).expts, ...
            db0(iexp).mouseName, db0(iexp).date, db0(iexp).nplanes)
        error('Unable to load Raw Flourescence Traces')
    end

    myRawData = Fcell{1,1};

    fprintf('Total cells: %i\n', size(myRawData,1))
    [dfbf, baselines, dfbf_2D] = dodFbyF(db0(iexp), myRawData);

    if saveData
        saveFolder = '/home/ananth/Desktop/Work/Analysis/Imaging/';

        if curateCalciumEventLibrary
            disp('Curating Library ...')
            eventLibrary_2D = curateLibrary(dfbf_2D); %eventLibrary_2D = curateLibrary(DATA_2D);

            save(strcat(saveFolder, db0(iexp).mouseName, '_', db0(iexp).date, '_eventLibrary_2D.mat'), 'eventLibrary_2D')
            disp('... done!')
        end


        disp('Saving dF/F traces ...')
        save([saveFolder db0(iexp).mouseName '_' db0(iexp).date '.mat' ], 'dfbf', 'baselines', 'dfbf_2D')

        disp('... done!')
    end
end
toc
disp('All done!')
