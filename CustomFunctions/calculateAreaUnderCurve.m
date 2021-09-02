function auc = calculateAreaUnderCurve(Data, rectify)

if isvector(Data)
    if rectify
        Data = abs(Data);
    end
    auc = trapz(Data);
else
    warning('Data is not a vector');
end