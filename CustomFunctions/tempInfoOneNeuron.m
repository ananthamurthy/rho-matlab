function [MI,Isec,Ispk,Itime] = tempInfoOneNeuron(raster)
    [nLaps,nBins,~] = size(raster);
    
    P_t = 1/nBins;                          %Probability occupancy in time (uniform).
    P_1t = mean(raster);                    %Mean rate at this time bin.
    P_0t = 1-P_1t;
    
    %Probability of spiking and not spiking.
    P_k1 = sum(sum(raster))/(nLaps*nBins);
    P_k0 = 1-P_k1;                  
    
    %Mutual information.
    I_k1 = P_1t.*log(P_1t./P_k1);
    I_k0 = P_0t.*log(P_0t./P_k0);
    Itime = I_k1 + I_k0; 
    MI = nansum(P_t.*Itime);
    
    %Information content.
    Isec = nansum(P_t.*P_1t.*log2(P_1t./P_k1));      %bits/sec
    
    if P_k1 == 0
        Ispk = 0; %Asserting 0 for cells without any activity
    else
        Ispk = Isec/P_k1;                              %bits/spk
    end
    
    if isnan(Ispk)
        error('Score of NaN by Method B using Ispk')
    elseif isnan(Isec)
        error('Score of NaN by Method B using Isec')
    elseif isnan(MI)
        error('Score of NaN by Method B using MI')
    end
end