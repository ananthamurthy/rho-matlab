clear

workingOnServer = 0; %Current
% Directory config
if workingOnServer == 1
    HOME_DIR = '/home/bhalla/ananthamurthy/';
    saveDirec = strcat(HOME_DIR, 'Work/Analysis/Imaging/');
elseif workingOnServer == 2
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/media/ananth/Storage/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/RHO/');
else
    HOME_DIR = '/home/ananth/Documents/';
    HOME_DIR2 = '/home/ananth/Desktop/';
    saveDirec = strcat(HOME_DIR2, 'Work/Analysis/RHO/');
end

gDate = 20220405;
gRun = 1;
nDatasets = 36;
nCells = 135;
nCells2Remove = 68;

load(sprintf('%sWork/Analysis/RHO/M26/20180514/synthDATA_%i_gRun%i_batch_%i.mat', HOME_DIR2, gDate, gRun, nDatasets));
%sdo_batch2 = sdo_batch;
selectedCells4Removal = 68:135;
for dataseti = 1:length(sdo_batch)
    sdo_batch(dataseti).syntheticDATA(selectedCells4Removal, :, :) = [];
    sdo_batch(dataseti).syntheticDATA_2D(selectedCells4Removal) = [];

    fprintf('Dataset: %i - To Remove: %i - Final nCells: %i\n', ...
        dataseti, ...
        length(selectedCells4Removal), ...
        size(sdo_batch(dataseti).syntheticDATA, 1))
end

%save
save(sprintf('%sWork/Analysis/RHO/M26/20180514/synthDATA_%i_gRun%i_batch_%i_halved.mat', HOME_DIR2, gDate, gRun, nDatasets), ...
    'sdo_batch', ...
    '-v7.3')