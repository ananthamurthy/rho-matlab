function Data_sigOnly = findSigOnly(Data)
    %Preallocation
    Data_sigOnly = Data;
    Data_mean = zeros(size(Data,1),size(Data,2));
    Data_std = zeros(size(Data,1),size(Data,2));
    
    for cell = 1:size(Data,1)
        for trial = 1:size(Data,2)
            Data_mean(cell,trial) = mean(squeeze(squeeze(Data(cell,trial,:))));
            Data_std(cell,trial) = std(squeeze(squeeze(Data(cell,trial,:))));
            %floor any value less than mean + 2*stddev to 0
            A = squeeze(squeeze(Data(cell,trial,:)));
            A(A<(Data_mean(cell,trial) + 2*(Data_std(cell,trial)))) = 0;
            Data_sigOnly(cell,trial,:) = A;
        end
    end
end