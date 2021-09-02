% AUTHOR - Kambadur Ananthmurthy
function [lotoData, trial2remove] = randomLOTO(Data)
    %nTrials = size(Data,2);
    trial2remove = randi(size(Data,2));
    lotoData = Data; %preallocation
    lotoData(:,trial2remove,:) = [];
end