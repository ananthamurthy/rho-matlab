%% fecAnalysis_new
%clear all
clear
close all

mouseName = 'treadmillTest';
session = 1;
protocol = 'An2';

rawDirec = '/Users/ananth/Desktop/Work/Behaviour/DATA/';

dataset = [mouseName '_' num2str(session) '_' protocol];
for trial = 1:5 %%nTrials = 60
    %trial = 1;
    file = [rawDirec mouseName '/' dataset, '/00' num2str(trial) '.tiff'];
    
    for frame = 1:321
        %frame = 1;
        refImage = double(imread(file, frame));
        dataLine = char(refImage(1,:));
        %disp(dataLine)
        commai = strfind(dataLine,',');
        %Treadmill velocity comes after the 12th comma
        velocity(trial,frame) = str2double(sprintf(dataLine(commai(12)+1:commai(13)-1),'%s'));
    end
end

%% Plot velocity
figure(1)
clf
for trial = 1:5
    %plot(velocity(trial,:) - ((trial-1)*10))
    plot(velocity(trial,:))
    hold on
end
title([mouseName ' ' num2str(session) ' ' protocol ' - Velocity (no transformation)']);
xlabel('Frames');
ylabel('Readout');
legend('Trial1', 'Trial2', 'Trial3', 'Trial4', 'Trial5')