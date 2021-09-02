% AUTHOR - Kambadur Ananthmurthy

%Incorporate daisy-chain and identification of stable ROIs
animal = 'M16';
date1 = '20171003';
date2 = '20171004';
regDataset = sprintf('Users/ananth/Desktop/Work/Analysis/Imaging/%s/%s_%s_plane1_%s_%s_plane1_reg.mat', ...
    animal, animal, date1, animal, date2);
disp(regDataset)

%Daisy-chain
[overlaps] = cat_overlap();
%[overlaps] = cat_overlap(regDataset);

secondSet_Indicies = overlaps.rois.idcs(:,2);

%Find consistent ROIs
%[consistent_rois] = find_consistent_rois(roi_cell);