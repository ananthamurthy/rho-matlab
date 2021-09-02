%Written by Kambadur Ananthamurthy
function [DATA_trialWithNoise, noiseComponent] = addNoise(DATA_trial, noise, noisePercent)

s = (noisePercent/100) * max(DATA_trial);

if strcmpi(noise, 'gaussian')
    noiseComponent = (s .* randn(1, length(DATA_trial)));
else
    %error('Unable to identify noise case')
end
DATA_trialWithNoise = DATA_trial + noiseComponent;
end


%{
figure(1)
hist(DATA_trial, 'black')
hold on
hist(DATA_trialWithNoise, 'blue')
hold off
title('Histograms')
set(gca, 'FontSize', 20)


figure(2)
clf
plot(DATA_trial, 'black', 'LineWidth', 3)
hold on
plot(DATA_trialWithNoise, 'blue', 'LineWidth', 3)
hold on
plot(noiseComponent, 'red', 'LineWidth', 3)
hold off
title('Testing with Noise')
xlabel('Frames')
ylabel('A.U.')
legend('Trial Without Noise', 'Trial With Noise', 'Noise')
set(gca, 'FontSize', 20)
%}