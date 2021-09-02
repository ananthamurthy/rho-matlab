function nanList = lookout4NaNs(myList, input)
nCells = input.nCells;
dataDesc = input.dataDesc;
nanList = zeros(nCells, 1);

if strcmpi(input.dimensions, '2D') %dfbf_2D (2D list)
    for cell = 1:nCells
        if ~isempty(find(isnan(myList(cell, :)), 1)) %stops search if even 1 NaN is found; for efficiency
            nanList(cell, 1) = 1;
            fprintf('Cell: %i got NaN in %s\n', cell, dataDesc)
        else
            %disp('--> Good news: No "NaN" found')
        end
    end
else %1D list
    for cell = 1:nCells
        if ~isempty(find(isnan(myList(cell)), 1)) %stops search if even 1 NaN is found; for efficiency
            nanList(cell, 1) = 1;
            fprintf('Cell: %i got NaN in %s\n', cell, dataDesc)
        else
            %disp('--> Good news: No "NaN" found')
        end
    end
end