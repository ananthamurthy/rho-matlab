% TITLE - Custom code to wrap around dodFbyF()
% AUTHOR - Kambadur Ananthamurthy


%profile on
tic
close all
%clear all
clear

%% Addpaths
addpath(genpath('/home/ananth/Documents/rho-matlab/CustomFunctions')) % my custom functions
addpath(genpath('/home/ananth/Desktop/Work/Analysis/Imaging')) % analysis output
%% Operations
curateCalciumEventLibrary = 1;
saveData                  = 1;
%% Dataset
make_db_realBatch
nDatasets = length(db);

for iexp = 1:nDatasets
    %Load Fluorescence Data - This is the ouput after running Suite2P's
    %master_file.m
    try
        load(sprintf('/home/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/F_%s_%s_plane%i.mat', ...
            db(iexp).mouseName, db(iexp).date, db(iexp).expts, ...
            db(iexp).mouseName, db(iexp).date, db(iexp).nplanes))
    catch
        load(sprintf('/home/ananth/Desktop/Work/Analysis/Imaging/%s/%s/%i/F_%s_%s_plane%i.mat', ...
            db(iexp).mouse_name, db(iexp).date, db(iexp).expts, ...
            db(iexp).mouse_name, db(iexp).date, db(iexp).nplanes))
    end

    myRawData = Fcell{1,1};

    fprintf('Total cells: %i\n', size(myRawData,1))
    [dfbf, baselines, dfbf_2D] = dodFbyF(db(iexp), myRawData);

    if curateCalciumEventLibrary
        disp('Curating Library ...')
        eventLibrary_2D = curateLibrary(DATA_2D);
        save(strcat(saveFolder, db.mouseName, '_', db.date, '_eventLibrary_2D.mat'), 'eventLibrary_2D')
        disp('... done!')
    end

    if saveData
        save([saveFolder db(iexp).mouseName '_' db(iexp).date '.mat' ], ...
            'dfbf', 'baselines', 'dfbf_2D')
    end
end
toc
disp('All done!')