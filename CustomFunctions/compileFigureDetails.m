% AUTHOR - Kambadur Ananthmurthy

function figureDetails = compileFigureDetails(fontSize, lineWidth, markerSize, capSize, transparency, colorMap)
disp('Compiling figures related parameters ...')
figureDetails.fontSize       = fontSize;
figureDetails.lineWidth      = lineWidth;
figureDetails.markerSize     = markerSize;
figureDetails.capSize        = capSize;
figureDetails.transparency   = transparency;

if strcmpi(colorMap, 'magma')
    figureDetails.colorMap = magma();
elseif strcmpi(colorMap, 'inferno')
    figureDetails.colorMap = inferno();
elseif strcmpi(colorMap, 'plasma')
    figureDetails.colorMap = plasma();
elseif strcmpi(colorMap, 'viridis')
    figureDetails.colorMap = viridis();
elseif strcmpi(colorMap, 'hot')
    figureDetails.colorMap = hot();
elseif strcmpi(colorMap, 'jet')
    figureDetails.colorMap = jet();
elseif strcmpi(colorMap, 'pmkmp')
    figureDetails.colorMap = pmkmp(256);
elseif strcmpi(colorMap, 'cividis')
    figureDetails.colorMap = cividis();
elseif strcmpi(colorMap, 'linspecer')
    figureDetails.colorMap = linspecer();
else
    figureDetails.colorMap    = colorMap;
end
disp('... done!')