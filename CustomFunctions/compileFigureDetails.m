% AUTHOR - Kambadur Ananthmurthy

function figureDetails = compileFigureDetails(fontSize, lineWidth, markerSize, transparency, colorMap)

figureDetails.fontSize       = fontSize;
figureDetails.lineWidth      = lineWidth;
figureDetails.markerSize     = markerSize;
figureDetails.transparency   = transparency;

if strcmpi(colorMap, 'magma')
    %magma=magma();
    figureDetails.colorMap = magma();
elseif strcmpi(colorMap, 'inferno')
    %inferno=inferno();
    figureDetails.colorMap = inferno();
elseif strcmpi(colorMap, 'plasma')
    %plasma=plasma();
    figureDetails.colorMap = plasma();
elseif strcmpi(colorMap, 'viridis')
    %viridis=viridis();
    figureDetails.colorMap = viridis();
elseif strcmpi(colorMap, 'hot')
    figureDetails.colorMap = hot();
elseif strcmpi(colorMap, 'jet')
    figureDetails.colorMap = jet();
else
    figureDetails.colorMap    = colorMap;
end