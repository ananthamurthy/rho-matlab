function result = isTimeLockedCell(Data, nShuffles, identificationPrinciple, comparisonPrinciple, threshold, window)

if ischar(identificationPrinciple) && ischar(comparisonPrinciple)
    shuffledData = zeros(size(Data)); %preallocation
    
    if strcmp(identificationPrinciple, 'AOC')
        ratio = zeros(nShuffles,1);
        %Non-randomized
        avgInWindow_Data = mean(Data(:, window), 1);
        auc_normal = trapz(avgInWindow_Data);
        %     figure(1)
        %     imagesc(avgInWindow_Data)
        %     colorbar
        %disp(auc_normal)
        
        %Random shuffled
        for shuffle = 1:nShuffles
            for trial = 1:size(Data,1)
                shuffledData(trial,:) = Data(trial, randperm(length(Data(trial,:))));
            end
            avgInWindow_ShuffledData = mean(shuffledData(:, window), 1);
            auc_shuffled = trapz(avgInWindow_ShuffledData);
            %         figure(2)
            %         clf
            %         imagesc(avgInWindow_ShuffledData)
            %         colorbar
            %         pause(1)
            ratio(shuffle) = auc_normal/auc_shuffled;
        end
        
        if strcmp(comparisonPrinciple, 'Minima')
            comparison = min(ratio);
        elseif strcmp(comparisonPrinciple, 'Average')
            comparison = mean(ratio);
        else
            warning('Unspecified Comparison Principle; resorting to use Minima')
            comparison = min(ratio);
        end
        if comparison <= threshold
            result = 0;
        else
            %disp('Found a time cell!')
            result = 1;
        end
        
    elseif strcmp(identificationPrinciple, 'Peak')
        %Non-Randomized
        avgInWindow_Data = mean(Data(:, window), 1);
        %[peaks_normal, peakIndices_normal] = findpeaks(avgInWindow_Data);
        [peak_normal, peakIndices_normal] = max(avgInWindow_Data);
        if isempty(peakIndices_normal)
            %disp('No peaks found in Data')
            result = 0;
        else
            peakIndex_shuffled = zeros(nShuffles,1);
            potential = zeros(nShuffles,1);
            %Random shuffled
            for shuffle = 1:nShuffles
                for trial = 1:size(Data,1)
                    shuffledData(trial,:) = Data(trial, randperm(length(Data(trial,:))));
                end
                avgInWindow_ShuffledData = mean(shuffledData(:, window), 1);
                %metric to compare normal vs random
                %[peaks_shuffled, peakIndices_shuffled(shuffle)] = findpeaks(avgInWindow_ShuffledData);
                [peak_shuffled, peakIndex_shuffled(shuffle)] = max(avgInWindow_ShuffledData);
                
                if peakIndex_shuffled(shuffle) == 0
                    %disp('No peaks found in Shuffled Data')
                    potential(shuffle) = 1;
                else
                    if max(peak_normal) > max(peak_shuffled(shuffle))
                        potential(shuffle) = 1;
                    else
                        potential(shuffle) = 0;
                    end
                    
                    if sum(potential) > floor(nShuffles/2)
                        result = 1;
                    else
                        result = 0;
                    end
                end
            end
        end
    elseif strcmp(identificationPrinciple, 'Threshold')
        %Add operations
    else
        error('Unknown Identification Principle')
    end
end