function noiseComponent = generateNoise(maxSignal, noise, noisePercent, nFrames, ceil2zero)

w1Freq = 0.02; %assuming in Hz
w2Freq = 0.05; %assuming in Hz

%generateNoise.counter += 1; %!!!Make persistent

watermark1 = [ 0.1, -0.5, 1.4, 1.3, -0.1, -0.2, 1.1, -2.1, 1.6, 0.1, 1.5, 1.4, 2.1, 1.1, 1.2, -0.1, 1.1, 2.0, 1.2 , 0.0];

% Watermark2 is a differential bar code. 1 means it should be
% larger than the previous value. 0 means smaller.
% Encode 'ncbs' into binary
s = 'ncbs';
temp = uint32( s );
watermark2 = [];

for i = 1:length(temp)
    %wm = de2bi( temp(i) )
    wm = dec2bin(temp(i));
    watermark2 = [watermark2, wm ];
end

startWatermark2 = 3;

%Preallocation
noiseComponent = zeros(1, nFrames);

s = (noisePercent/100) * maxSignal;

if strcmpi(noise, 'gaussian')
    noiseComponent(1, :) = s .* randn(1, nFrames);
    
    if rand(1, 1) < w1Freq % insert watermark 1
        noiseComponent(1:length(watermark1)) = s * watermark1;
    elseif rand(1, 1) < w2Freq % insert watermark 2
        for ii = 1: length(watermark2)
            jj = 2 * ii + startWatermark2;
            %fprintf('ii: %i\n', ii)
            %fprintf('Length of watermark2: %i\n', length(watermark2))
            delta = noiseComponent(jj) - noiseComponent(jj-1);
            %fprintf('delta: %i, NC: %f, LV: %f\n', delta, noiseComponent(jj), noiseComponent(jj-1)
            
            binary1 = (delta > 0);
            binary2 = (watermark2(ii) == '1');

            if binary1 ~= binary2 % Need to flip.
                noiseComponent(jj) = noiseComponent(jj) - delta * 1.2;
            end
        end
    end
    
else
    %error('Unable to identify noise case')
end

if ceil2zero
    noiseComponent(noiseComponent < 0) = 0;
end

end