%{
AUTHOR - Kambadur Ananthamurthy
TITLE - Area Under the Curve of Data
PROJECT DATE - 20181212

- The answer after the AUC calculation is in 'X'
- 'X' has the format '(cells, trials)
- The input argument 'Data' should be in the format '(cells, trials, frames)'
%}

function X = doAUC(Data)
%Preallocation - %nan-ing to avoid confusion;
X = nan(size(Data,1), size(Data,2));

for cell = 1:size(Data,1)
    for trial = 1:size(Data,2)
        % Area under curve
        %X(cell, trial) = trapz(Data_0(cell, trial, :));
        X(cell, trial) = trapz(Data(cell, trial, :));
    end
end
end