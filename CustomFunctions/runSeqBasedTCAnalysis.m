function [seqAnalysisOutput] = runSeqBasedTCAnalysis(DATA, seqAnalysisInput)

nCells = size(DATA, 1);
nTrials = size(DATA, 2);
nFrames = size(DATA, 3);

%Gaussian Smoothing
if seqAnalysisInput.gaussianSmoothing
    [smoothedData, ~] = doGaussianSmoothing(DATA, seqAnalysisInput.nSamples);
    %[smoothedDATA, gaussianKernel] = doGaussianSmoothing2D(DATA_2D, nSamples);
end

%Convert Data to 2D
DATA_2D = zeros(nCells, nTrials*nFrames);
for cell = 1:nCells
    for trial = 1:nTrials
        count = trial - 1;
        % All trials
        if seqAnalysisInput.gaussianSmoothing
            DATA_2D(cell,(((count*nFrames)+1):(count*nFrames)+nFrames)) = smoothedData(cell, trial, :);
        else
            DATA_2D(cell,(((count*nFrames)+1):(count*nFrames)+nFrames)) = DATA(cell, trial, :);
        end
    end
end

%Remember to transpose the 2D data to: rows - allFrames (observations), and columns - Cells (variables)
X = DATA_2D';

% PCA
%[coeff, score, ~, ~, explained, mu] = pca(X); %reconstructedDATA = (score * coeff') + mu;

% Offset PCA
%Develop the centered and standardized matrix from the 2D Data.
mu = mean(X); %column means as a row vector
Z = X - repmat(mu, nTrials*nFrames, 1); %centered and standardized matrix

%Covariance matrix - alternative estimator
% First set up the two (n-1) x p "versions" of Z
% Removing first row
Zr1 = Z;
Zr1(1,:) = [];

%Removing last row
Zrend = Z;
Zrend(size(Z, 1), :) = [];

%Now, the covariance matrix is
Ccap = (1/(2*(size(Z, 1)-1))) * ((Zrend'*Zr1) + (Zr1'*Zrend));

%Finally, we perform the PCA on this new covariance matrix
[coeff, ~, explained] = pcacov(Ccap);

score = Z * coeff;

if seqAnalysisInput.automatic
    %Add condition to exclude tsquared values >1? Skipping
    %Add condition to only include eigenvalues >1? Skipping
    
    %Select the index of the PC that explains the highest percentage of the total variance
    if seqAnalysisInput.use1PC
        [~, selectedIndex] = max(explained);
    end
    
else %Manual mode
    %Make a gui? Keeping things simple
    selectedIndex = 1;
    finish = 'n';
    while strcmpi(finish, 'n')
        reconstructedDATA = (score(:, selectedIndex) * coeff(:, selectedIndex)' + mu);
        figure
        set(gcf,'Visible','on')
        clf
        imagesc(reconstructedDATA'*100)
        title(sprintf('Data | PC: %i', selectedIndex), ...
            'FontSize', 15, ...
            'FontWeight','bold')
        xlabel('Observations', ...
            'FontSize', 15, ...
            'FontWeight', 'bold')
        ylabel('Cells', ...
            'FontSize', 15, ...
            'FontWeight', 'bold')
        z = colorbar;
        colormap('jet')
        ylabel(z,'dF/F (%)', ...
            'FontSize', 15, ...
            'FontWeight', 'bold')
        set(gca, 'FontSize', 15)
        
        finish = input('Finish? y/n: ', 's');
        
        if ~strcmpi(finish, 'y')
            selectedIndex = input('Enter a PC option: ');
        end
    end
    set(gcf,'Visible','off')
end

%Not necessary; commenting out
% seqAnalysisOutput.coeff = coeff;
% seqAnalysisOutput.score = score;
% seqAnalysisOutput.explained = explained;
% seqAnalysisOutput.mu = mu;

%seqAnalysisOutput.recDATA = ((score(:, selectedIndex) * coeff(selectedIndex, :)) + mu)';

if seqAnalysisInput.use1PC
    %Take the first derivative of Selected Principal Component
    seqAnalysisOutput.selectedPC = squeeze(score(:, selectedIndex));
else
    %Take the first derivative of the first 3 principal componenets
    seqAnalysisOutput.selectedPC = squeeze(score(:, 1:3));
end

%size(seqAnalysisOutput.selectedPC);
dx = seqAnalysisOutput.selectedPC(2:end) - seqAnalysisOutput.selectedPC(1:end-1);
dt = (seqAnalysisInput.timeVector(2:end) - seqAnalysisInput.timeVector(1:end-1))'; %Transpose
seqAnalysisOutput.d1 = dx ./ dt;

seqAnalysisOutput.dx = dx;
seqAnalysisOutput.dt = dt;

%Generate ETH
if seqAnalysisInput.getT
    [ETH, ~, ~] = getETH(DATA, seqAnalysisInput.delta, seqAnalysisInput.skipFrames);
end

% Quality (Q) and Time Vector (T)
peakTimeBin = zeros(nCells, 1);

for cell = 1:nCells
    %disp(cell)
    %Cross-correlate with the activity of each cell to get Quality (Q)
    R_2x2 = corrcoef(seqAnalysisOutput.d1, DATA_2D(cell, 2:end)'); %pads smaller vector with 0s

    if isnan(R_2x2(1, 2))
        %error('corrcoef is Nan for cell: %i by Method C', cell)
        seqAnalysisOutput.Q1(cell, 1) = 0;
    else
        seqAnalysisOutput.Q1(cell, 1) = R_2x2(1, 2);
    end
    
    %Get Peak Time bin from ETH
    if seqAnalysisInput.getT
        %Time Vector
        [~, peakTimeBin(cell)] = max(squeeze(ETH(cell, :)));
    end
end
seqAnalysisOutput.T1 = peakTimeBin;

threshold = graythresh(seqAnalysisOutput.Q1); %Otsu's method
seqAnalysisOutput.timeCells1 = seqAnalysisOutput.Q1 > threshold;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method D scores';
nanTest_input.dimensions = '1D';
nanList1 = lookout4NaNs(seqAnalysisOutput.Q1, nanTest_input);
seqAnalysisOutput.nanList1 = nanList1;

end