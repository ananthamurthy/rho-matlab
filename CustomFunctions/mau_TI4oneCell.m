%Wrapper by Kambadur Ananthamurthy
%tempInfoOneNeuron.m written by Willaim Mau (Eichenbaum Lab)

addpath(genpath('/Users/ananth/Documents/MATLAB/CustomFunctions')) % my custom functions
addpath(genpath('/Users/ananth/Documents/MATLAB/ImagingAnalysis')) % Additional functions

nCells = size(dfbf_sigOnly,1);
%Preallocations
MI = zeros(nCells,1);
Isec = zeros(nCells,1);
Ispk = zeros(nCells,1);
Itime = zeros(nCells,size(dfbf_sigOnly,3),1);

for cell = 1:size(dfbf_sigOnly,1)
    [MI(cell),Isec(cell),Ispk(cell),Itime(cell, :)] = tempInfoOneNeuron(squeeze(dfbf_sigOnly(cell,:,:)));
end

%% Plots
%Information content
figure(1)
plot(Ispk, 'b*')
hold on
plot(Isec, 'ro')
title(['Temporal Information | ', ...
    db(iexp).mouse_name ' ST' num2str(db(iexp).sessionType) ' S' num2str(db(iexp).session) ' | '...
    num2str(trialDetails.frameRate) ' Hz | '...
    '3 frames/bin'] , ...
    'FontSize', figureDetails.fontSize, ...
    'FontWeight', 'bold')
xlabel('Cells', ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
%set(gca,'YTick',[10, 20, 30, 40, 50, 60])
%set(gca,'YTickLabel',({10; 20; 30; 40; 50; 60}))
ylabel('Information - blue: bits/spike | red: bits/sec)', ...
    'FontSize', figureDetails.fontSize,...
    'FontWeight', 'bold')
set(gca,'FontSize', figureDetails.fontSize-3)