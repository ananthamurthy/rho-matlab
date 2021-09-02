% AUTHOR - Kambadur Ananthmurthy
% NOTE: avgPSTH_3D is trial averaged
function TI = findTI(avgPSTH_3D)
%Temporal Information (TI) = 1/lambda * sigmai(lambdai*log2(lambdai/lambda)*Pti)
lambda = mean(avgPSTH_3D);
x = zeros(length(avgPSTH_3D),1) ; %preallocation
lambdai = zeros(size(avgPSTH_3D,1),1);
for bin = 1:length(avgPSTH_3D)
    if avgPSTH_3D(bin) == 0
        %fprintf('0 observed in bin %i while finding TI\n',bin)
        %lambdai(bin) = 0;
        x(bin) = 0;
    elseif avgPSTH_3D(bin) < 0
        fprintf('Negative value observed in bin %i while finding TI\n',bin)
        %x(bin) = 0; %assertion
    else
        lambdai(bin) = avgPSTH_3D(bin);
        x(bin) = lambdai(bin)*(log2(lambdai(bin)/lambda))*(1/length(avgPSTH_3D));
    end
end
TI = sum(x)/lambda;
end