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
bundleDatasets            = 1; %0: save each set of analysis outputs separately. 1: bundle and save as "realData"
saveData                  = 1;
outputVersion             = 1; %0: usual .m or .mat; 1: -v7.3; only for dF/F curves
%% Dataset
make_db_realBatch
nDatasets = length(db0);

for iexp = 1:nDatasets
    fprintf('[INFO] Working on Dataset: %i ...\n', iexp)

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
    if bundleDatasets
        [realData(iexp).dfbf, realData(iexp).baselines, realData(iexp).dfbf_2D] = dodFbyF(db0(iexp), myRawData);
    else
        [dfbf, baselines, dfbf_2D] = dodFbyF(db0(iexp), myRawData);
    end

    if saveData
        saveFolder = '/home/ananth/Desktop/Work/Analysis/Imaging/';

        if curateCalciumEventLibrary
            disp('Curating Library ...')
            if bundleDatasets
                eventLibrary_2D = curateLibrary(realData(iexp).dfbf_2D); %eventLibrary_2D = curateLibrary(DATA_2D);
            else
                eventLibrary_2D = curateLibrary(dfbf_2D); %eventLibrary_2D = curateLibrary(DATA_2D);
            end
            save(strcat(saveFolder, db0(iexp).mouseName, '_', db0(iexp).date, '_eventLibrary_2D.mat'), 'eventLibrary_2D')
            disp('... done!')
        end

        disp('Saving dF/F traces ...')
        if bundleDatasets
            if outputVersion == 0
                save([saveFolder 'realData0.mat' ], 'realData')
            elseif outputVersion == 1
                save([saveFolder 'realData.mat' ], 'realData', '-v7.3')
            end
        else
            save([saveFolder db0(iexp).mouseName '_' db0(iexp).date '.mat' ], 'dfbf', 'baselines', 'dfbf_2D')
        end
        disp('... done!')
    end
    disp('... done!')
end
toc
disp('All done!')
