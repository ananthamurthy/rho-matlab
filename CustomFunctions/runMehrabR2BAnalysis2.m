function [mehrabOutput] = runMehrabR2BAnalysis2(DATA, mehrabInput, trialDetails)

negList1 = zeros(537, 135);
negList2 = zeros(537, 135);
di = mehrabInput.runi;

cell_list = mehrabInput.cellList;
nCells = length(cell_list);
CS_onset_frame = mehrabInput.onFrame;
US_onset_frame = mehrabInput.offFrame;
ridge_h_width = mehrabInput.ridgeHalfWidth;
r_iters = mehrabInput.nIterations;
non_ov_trials = mehrabInput.selectNonOverlappingTrials;
early_only = mehrabInput.earlyOnly;
pk_behav_trial = mehrabInput.startTrial;

%Preallocation
timeCells1 = nan(nCells, 1); %Includes Time Cells and Other Cells
timeCells2 = nan(nCells, 1);

%Trial specifics
frame_time = 1000/trialDetails.frameRate;
ridge_h_width_f = floor(ridge_h_width/frame_time); %in frames

dff_data_mat = permute(DATA, [3 1 2]);
no_trials = size(dff_data_mat, 3);

%establishing typical response size for each cell
pk_list_t = zeros(length(cell_list), 2);
for cell_noi = 1:length(cell_list)
    cell_no = cell_list(cell_noi);
    traces = squeeze(dff_data_mat(CS_onset_frame:(US_onset_frame-1), cell_no, :));
    pks = max(traces, [], 'omitnan');
    if isnan(pks)
        error('Method A: Nan found in pks')
    end
    pk_list_t(cell_noi, 1) = mean(pks);
    
    if isnan(pk_list_t(cell_noi, 1))
        error('Method A: Nan found in pk_list_t mean for cell: %i', cell_no)
    end
    pk_list_t(cell_noi, 2) = std(pks);
    
    if isnan(pk_list_t(cell_noi, 2))
        error('Method A: Nan found in pk_list_t std for cell: %i', cell_no)
    end
end

if non_ov_trials == 0
    kernels = nanmean(dff_data_mat(:, cell_list, pk_behav_trial:no_trials), 3);
    
elseif non_ov_trials == 1
    k_tr_list = pk_behav_trial:2:no_trials;
    
    kernels = nanmean(dff_data_mat(:, cell_list, k_tr_list), 3); %2D matrix: (values, cells)
    %kernels = mean(dff_data_mat(:, cell_list, k_tr_list), 3); %2D matrix: (values, cells)
    dff_data_mat(:, :, k_tr_list) = nan;    %making sure kernel estimation trials not used for rb ratio calculation
else
end

if ~isempty(find(isnan(kernels), 1))
    error('Method A: Nan found in kernels')
end

kernels_nt = kernels;
%disp(size(kernels_nt))
if ~isempty(find(isnan(kernels_nt), 1))
    error('Method A: Nan found in kernels_nt')
end

kernels_e = nanmean(dff_data_mat(:, cell_list, 1:5), 3);  %for early trials only; 2D matrix: (values, cells)
%kernels_e = mean(dff_data_mat(:, cell_list, 1:5), 3);  %for early trials only; 2D matrix: (values, cells)
%finding indices of the trial-averaged peaks of activity for each cell
if early_only == 0
    %[~, pki] = nanmax(kernels(CS_onset_frame:(US_onset_frame + floor(200./frame_time)), :), [], 1);
    [~, pki] = max(kernels(CS_onset_frame:(US_onset_frame + floor(200./frame_time)), :), [], 1);
elseif early_only == 1
    %[~, pki] = nanmax(kernels_e(CS_onset_frame:(US_onset_frame + floor(200./frame_time)), :), [], 1);
    [~, pki] = max(kernels_e(CS_onset_frame:(US_onset_frame + floor(200./frame_time)), :), [], 1);
else
end

if isnan(pki)
    error('Method A: Nan found in pki')
end
%disp(pki)

%calculating ridge to background ratio for each cell -loops to calculate ridge to background ratios on a per cell basis - with a separate loop for randomised calculations
%disp('Now calculating Ridge to Background Ratios ...')
rb_ratio_vec = zeros(1, length(cell_list));
rrb_ratio_vec_final = zeros(1, length(cell_list));
for cell_noi = 1:length(cell_list)
    cell_no = cell_list(cell_noi); %looking up cell in cell_list
    pk_f = pki(cell_noi) + ridge_h_width_f;
    
    if isnan(pk_f)
        error('Method A: Nan found in pk_f')
    end
    
    poiCell = (CS_onset_frame - ridge_h_width_f):(US_onset_frame + round(200./frame_time) + ridge_h_width_f);
    %disp(poiCell);
    
    %if length(poiCell) == 0
    if isempty(poiCell)
        error('Period of interest for cell: %i is 0', cell_noi)
    end
    
    trace = kernels_nt(poiCell, cell_noi);
    %disp(size(trace))
    %disp(trace)
    
    %     fprintf('CS_onset_frame: %i\n', CS_onset_frame)
    %     fprintf('US_onset_frame: %i\n', US_onset_frame)
    %     fprintf('ridge_h_width_f: %i\n', ridge_h_width_f)
    %     fprintf('frame_time: %i\n', frame_time)
    %     fprintf('ridge_h_width_f: %i\n', ridge_h_width_f)
    
    if nansum(trace) == 0
        %error('nansum(trace) is 0 for cell: %i', cell_noi)
        
        % Set conditions to have the cell scored with a 0
        % This means that this cell bypasses the next section, and is
        % destined to never be considered a Time Cell.
        rb_ratio_vec(1, cell_noi) = 0;
        rrb_ratio_vec_final(1, cell_noi) = 1; %setting this to 0 would result in NaN
    else
        ridge_int = (nansum(trace( (pk_f - ridge_h_width_f):(pk_f + ridge_h_width_f) )));
        ridge_int = ridge_int./(2.*ridge_h_width_f + 1); %normalising by number of points considered
        
        if ridge_int < 0
            %warning('Dataset: %i, Cell: %i has a Negative Ridge', di, cell)
            negList1(di, cell_noi) = 1;
        end

        trace_x = trace;
        trace_x((pk_f - ridge_h_width_f):(pk_f + ridge_h_width_f)) = [];
        
        if ~isempty(find(isnan(trace_x)))
            error('Method A: Nan found in trace_x')
        end
        
        bk_int = nansum(trace_x);
        if isnan(bk_int)
            error('Method A: Nan found in bk_int initialization')
        end
        
        temp = isnan(trace_x); %entirety of the rest of the trace used as background
        
        bk_int = bk_int./(length(trace_x) - sum(temp)); %normalising by number of points considered
        
        if isnan(bk_int)
            error('Method A: Nan found in bk_f after normalization')
        end
        
        if isempty(trace_x) || abs(bk_int) == 0 %|| bk_int == 0
            % Set conditions to have the cell scored with a 0
            % This means that this cell bypasses the next section, and is
            % destined to never be considered a Time Cell.
            rb_ratio_vec(1, cell_noi) = 0;
            rrb_ratio_vec_final(1, cell_noi) = 1; %setting this to 0 would result in NaN
        else
            rb_ratio_vec(1, cell_noi) = ridge_int./abs(bk_int);
            
            if isnan(rb_ratio_vec(1, cell_noi))
                error('Method A: Nan found in rb_ratio_vec for cell: %i', cell_noi)
            end
            
            %loop for randomly shuffled calculation
            rrb_ratio_vec = zeros(1, r_iters);
            no_frames = length(trace);

            surr_iter_problems = 0;
            %loop for multiple random shuffles followed by finding mean value
            for iter_r = 1:r_iters
                s_trace_av_mat = zeros(length(trace), no_trials) + nan;
                
                init_trial = pk_behav_trial;
                
                r_shift_vec = floor(rand(no_trials, 1).*(no_frames - 1) + 1 );
                for trial_no = init_trial:no_trials
                    r_shift = r_shift_vec(trial_no, 1);
                    trace = dff_data_mat((CS_onset_frame - ridge_h_width_f):(US_onset_frame + round(200./frame_time) + ridge_h_width_f), cell_no, trial_no);
                    %trace = dff_data_mat((CS_onset_frame - ridge_h_width_f):(US_onset_frame + ridge_h_width_f), cell_no, trial_no);
                    trace_shifted = zeros(1, length(trace));
                    trace_shifted(1, 1:(no_frames - r_shift) ) = trace((r_shift + 1):no_frames, 1)';
                    trace_shifted(1, (no_frames - r_shift + 1):no_frames) = trace(1:(r_shift), 1);
                    trace_shifted = trace_shifted';
                    s_trace_av_mat(:, trial_no) = trace_shifted;
                end
                s_trace_av = nanmean(s_trace_av_mat, 2);
                clear s_trace_av_mat
                
                %finding peak in shuf-averaged trace and calculating rb ratio
                %[pk, pkf] = nanmax(s_trace_av);
                %pkf = pkf(1, 1); % appears to be unused; commenting out for now
                ridge_int = (nansum(s_trace_av( (pk_f - ridge_h_width_f):(pk_f + ridge_h_width_f) )));
                ridge_int = ridge_int./(2.*ridge_h_width_f + 1);                                    %normalising by number of points considered
                
                if ridge_int < 0
                    surr_iter_problems = surr_iter_problems +1;
                end

                trace_x = s_trace_av;
                trace_x((pk_f - ridge_h_width_f):(pk_f + ridge_h_width_f)) = [];
                bk_int = nansum(trace_x);
                temp = isnan(trace_x);                                  %entirety of the rest of the trace used as background
                bk_int = bk_int./(length(trace_x) - sum(temp));         %normalising by number of points considered
                rrb_ratio_vec(1, iter_r) = ridge_int./abs(bk_int);
                
            end
            negList2(di, cell_noi) = surr_iter_problems;
            rrb_ratio_vec_final(1, cell_noi) = nanmean(rrb_ratio_vec, 2);
            
            if isnan(rrb_ratio_vec_final(1, cell_noi))
                %error('Method A: Nan found in rrb_ratio_vec_final for cell: %i', cell_noi)
                rrb_ratio_vec_final(1, cell_noi) = 1; %insist
            end
        end
    end
    
    if rrb_ratio_vec_final(1, cell_noi) == 0
        %error('Cell: %i randomization results in 0', cell_noi)
        %fprintf('Cell: %i has normal score: %d but random score of 0\n', cell_noi, rb_ratio_vec(1, cell_noi))
        rrb_ratio_vec_final(1, cell_noi) = 1; %assign (to fail time cell classifaction)
    end
    %     if (mod(cell_noi, 50) == 0) && cell_noi ~= size(dff_data_mat,1)
    %         fprintf('... %i cells examined ...\n', cell_noi)
    %     end
    
end
% means = [nanmean(reshape(rb_ratio_vec, [], 1)), nanmean(reshape(rrb_ratio_vec_final, [], 1))];
% ses = [nanstd(reshape(rb_ratio_vec, [], 1)), nanstd(reshape(rrb_ratio_vec_final, [], 1))];
%
% n_list = isnan(rb_ratio_vec);
% n_list = find(n_list == 0);
% ses(1, 1) = ses(1, 1)./sqrt(length(n_list));
%
% n_list = isnan(rrb_ratio_vec_final);
% n_list = find(n_list == 0);
% ses(1, 2) = ses(1, 2)./sqrt(length(n_list));


%saved_scores = [saved_scores; [means(1, 1), means(1, 2), ses(1, 1), ses( 1, 2), p, h] ];

%all_scores = [all_scores, [rb_ratio_vec; rrb_ratio_vec_final] ];        %matrix containing ridge to background ratios

Q1 = rb_ratio_vec'; %Important to transpose.
ratioR2BvR = (rb_ratio_vec./rrb_ratio_vec_final)'; %Important to transpose; Ratio of Ridge/Background Ratios for emperical vs random
timeCells1 = ratioR2BvR > 3;

%Using Otsu's method of finding threshold
thresholdOtsu = graythresh(Q1); %Otsu's method
timeCells2 = Q1 > thresholdOtsu;

mehrabOutput.Q1 = Q1;
mehrabOutput.T1 = pki + CS_onset_frame;
mehrabOutput.timeCells1 = timeCells1;
mehrabOutput.timeCells2 = timeCells2;

%Lookout for NaNs
nanTest_input.nCells = nCells;
nanTest_input.dataDesc = 'Method A scores';
nanTest_input.dimensions = '1D';
nanList1 = lookout4NaNs(mehrabOutput.Q1, nanTest_input);
mehrabOutput.nanList1 = nanList1;
mehrabOutput.negList1 = negList1;
mehrabOutput.negList2 = negList2;

end