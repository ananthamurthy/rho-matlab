function sensitivity = summarize(Z, cellType, nMethods, nParams)

%Summarize
for method = 1:nMethods
    %deltaX = str2double(labels.xtickscell{end}) - str2double(labels.xtickscell{1});
    deltaX = nParams;
    e = Z(end, method);
    if ~isenum(e)
        warning('e is not a number')
    end
    s = Z(1, method);
    if ~isenum(s)
        warning('s is not a number')
    end
    deltaY = e - s;
    if ~isenum(deltaY)
        warning('Delta Y is not a number')
    end
    sensitivity(method, cellType) = abs((deltaY/deltaX)); %Putative Time Cells
end

end