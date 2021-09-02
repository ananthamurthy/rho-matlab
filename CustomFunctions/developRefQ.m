function Q = developRefQ(params4Q)

Q = zeros(params4Q.nCells, 1);

for cell = 1:params4Q.nCells
    
    HTR = params4Q.hitTrialPercent(cell)/100;
    
    a = params4Q.alpha;
    n = params4Q.noisePercent/100;
    eaf = params4Q.eventAmplificationFactor;
    NbyS = n/eaf;
    %fprintf('Cell: %i - n = %d, NbyS = %d\n', cell, n, NbyS)
    
    b = params4Q.beta;
    aew = params4Q.allEventWidths(cell, :);
    ht = find(params4Q.hitTrials(cell, :));
    sdAEW = nanstd(aew(ht)); %Only Hit Trials
    mAEW = nanmean(aew(ht)); %Only Hit Trials
    SDbyMEW = sdAEW/mAEW;
    
    g = params4Q.gamma;
    p = params4Q.pad(cell, :);
    sdp = std(p);
    sw = params4Q.stimulusWindow;
    SDPbySW = sdp/sw;
    
    Q(cell) = HTR * exp(-1 * ((a * NbyS) + (b * SDbyMEW) + (g * SDPbySW)));
    
    %fprintf('All event widths for cell %i :\n', cell)
    %disp(aew)
    %disp(length(aew))
    %fprintf('Std Dev: %d\n', sdAEW)
    %fprintf('Mean: %d\n', mAEW)
    %fprintf('Fano Factor: %d\n', sdAEW/mAEW)
    
end