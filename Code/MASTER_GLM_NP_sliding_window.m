warning('error', 'stats:glmfit:IterationLimit')
%% time window to analyze
for iRound = 1:5
for iEpoch = 1:2%3
    for iTime = -.5:.1:.5

NP_epoch = iEpoch; %which epoch to look at, 1 = np delay, 2 = outcome receipt, 3 = cue-offset
time_window_start = iTime; %starting time window for analysis, 0 = time zero

switch NP_epoch
    case 1
%         time_window_start = time_window_start;
        time_window_end = time_window_start + .5;
        epoch_start = 0;
        Epoch = 'NP';
    case 2
        time_window_start = time_window_start + 1;
        time_window_end = time_window_start + .5;
        epoch_start = 1;
        Epoch = 'outcome';
    case 3
        time_window_start = time_window_start + 2;
        time_window_end = time_window_start + .5;
        epoch_start = 2;
        Epoch = 'cueoff';
end

%%
mat_files = dir('*.mat');
for kk = 1:length(dir('*.mat'))
    load(mat_files(kk).name);
    mat_overview.fname{kk} = mat_files(kk).name;
    disp(cat(2,num2str(kk),'/',num2str(length(dir('*.mat')))));
    new_v_old = strcmp(mat_overview.fname{kk}(1:4),'R060');
    
    if RANK.two.Trial > 975 || RANK.two.Trial < 26
        if TESTS.WSR.Task.Trial_b4_vs_Trial < .01
            
            clear dataset ds %mdl
            switch new_v_old
                case 0
                    %% old rats (R053,R056,R057)                   
                    trials_count = 1;
                    b1_length = length(FRATE.Cue.Trial_firing_rate_block1);
                    for jj = 1:b1_length
%                         if metadata.TrialInfo_block1.summary(jj,2) == metadata.TrialInfo_block1.summary(jj,3) % if correct response
 if metadata.TrialInfo_block1.nosepoke_length(jj) > epoch_start
                 if metadata.TrialInfo_block1.nosepoke_length(jj) < time_window_end
            nosepoke_to_click(trials_count) = metadata.TrialInfo_block1.nosepoke_length(jj);
             else
            nosepoke_to_click(trials_count) = time_window_end;
                 end
        end_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + nosepoke_to_click(trials_count);
        start_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + time_window_start;
        
        % now, count spikes between start and end
        these_spk = spk_t(spk_t > start_time(trials_count) & spk_t < end_time(trials_count));
               
        % convert to firing rate and store
        firing_rate_np(trials_count) = length(these_spk) / (end_time(trials_count) - start_time(trials_count)) ;
if jj == 1
                                dataset(trials_count,1) = NaN; %prev trial
                            elseif jj == 2
                                switch metadata.TrialInfo_block1.rewarded(1)
                                    case 0
                                        dataset(trials_count,1) = 1;
                                    case 1
                                        dataset(trials_count,1) = 2;
                                end
                            else
                                switch metadata.TrialInfo_block1.rewarded(jj-1) + metadata.TrialInfo_block1.rewarded(jj-2)
                                    case 0
                                        dataset(trials_count,1) = 0;
                                    case 1
                                        switch metadata.TrialInfo_block1.rewarded(jj-1)
                                            case 0
                                                dataset(trials_count,1) = 1;
                                            case 1
                                                dataset(trials_count,1) = 2;
                                        end
                                    case 2
                                        dataset(trials_count,1) = 3;
                                end
                            end
                            
                            dataset(trials_count,2) = metadata.TrialInfo_block1.rewarded(jj); %outcome
                            switch sesh.block_order %modality
                                case 1
                                    dataset(trials_count,3) = 1;
                                case 2
                                    dataset(trials_count,3) = 2;
                            end
                            dataset(trials_count,4) = metadata.TrialInfo_block1.summary(jj,5); %arm
%                                                         dataset(trials_count,5) = metadata.TrialInfo_block1.approached(jj); %behav - app
                            dataset(trials_count,5) = metadata.TrialInfo_block1.summary(jj,15); %behav - trial length
                            dataset(trials_count,6) = jj;
                            dataset(trials_count,7) = firing_rate_np(trials_count); %FR
                            
                            trials_count = trials_count + 1;
 end
%                         end
                    end
                    
                    b2_start = b1_length + 1;
                    b2_length = length(FRATE.Cue.Trial_firing_rate_block2);
                    total = b1_length + b2_length;
                    
                    for jj = 1:b2_length
%                         if metadata.TrialInfo_block2.summary(jj,2) == metadata.TrialInfo_block2.summary(jj,3)
if metadata.TrialInfo_block2.nosepoke_length(jj) > epoch_start
        if metadata.TrialInfo_block2.nosepoke_length(jj) < time_window_end
            nosepoke_to_click(trials_count) = metadata.TrialInfo_block2.nosepoke_length(jj);
        else
            nosepoke_to_click(trials_count) = time_window_end;
        end
        end_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + nosepoke_to_click(trials_count);
        start_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + time_window_start;
        
        % now, count spikes between start and end
        these_spk = spk_t(spk_t > start_time(trials_count) & spk_t < end_time(trials_count));
        
        % convert to firing rate and store
        firing_rate_np(trials_count) = length(these_spk) / (end_time(trials_count) - start_time(trials_count));
                                   
if jj == 1
                                dataset(trials_count,1) = NaN; %prev trial
                            elseif jj == 2
                                switch metadata.TrialInfo_block2.rewarded(1)
                                    case 0
                                        dataset(trials_count,1) = 1;
                                    case 1
                                        dataset(trials_count,1) = 2;
                                end
                            else
                                switch metadata.TrialInfo_block2.rewarded(jj-1) + metadata.TrialInfo_block2.rewarded(jj-2)
                                    case 0
                                        dataset(trials_count,1) = 0;
                                    case 1
                                        switch metadata.TrialInfo_block2.rewarded(jj-1)
                                            case 0
                                                dataset(trials_count,1) = 1;
                                            case 1
                                                dataset(trials_count,1) = 2;
                                        end
                                    case 2
                                        dataset(trials_count,1) = 3;
                                end
                            end
                            
                            dataset(trials_count,2) = metadata.TrialInfo_block2.rewarded(jj);
                            switch sesh.block_order
                                case 1
                                    dataset(trials_count,3) = 2;
                                case 2
                                    dataset(trials_count,3) = 1;
                            end
                            dataset(trials_count,4) = metadata.TrialInfo_block2.summary(jj,5);
%                                                         dataset(trials_count,5) = metadata.TrialInfo_block2.approached(jj);
                            dataset(trials_count,5) = metadata.TrialInfo_block2.summary(jj,15);
                            dataset(trials_count,6) = b1_length+jj;
                            dataset(trials_count,7) = firing_rate_np(trials_count);
                            
                            trials_count = trials_count + 1;
%                         end
                    end
                    end
                    
                case 1
                    %% new rats (R060)
                    trials_count = 1;
                    b1_length = length(FRATE.Cue.Trial_firing_rate_block1);
                    for jj = 1:b1_length
%                         if metadata.TrialInfo{1,1}.summary(jj,2) == metadata.TrialInfo{1,1}.summary(jj,3)
 if metadata.TrialInfo{1,1}.nosepoke_length(jj) > epoch_start
             if metadata.TrialInfo{1,1}.nosepoke_length(jj) < time_window_end
            nosepoke_to_click(trials_count) = metadata.TrialInfo{1,1}.nosepoke_length(jj);
        else
            nosepoke_to_click(trials_count) = time_window_end;
        end
        end_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + nosepoke_to_click(trials_count);
        start_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + time_window_start;
        
        % now, count spikes between start and end
        these_spk = spk_t(spk_t > start_time(trials_count) & spk_t < end_time(trials_count));
               
        % convert to firing rate and store
        firing_rate_np(trials_count) = length(these_spk) / (end_time(trials_count) - start_time(trials_count));                            
if jj == 1
                                dataset(trials_count,1) = NaN; %prev trial
                            elseif jj == 2
                                switch metadata.TrialInfo{1,1}.rewarded(1)
                                    case 0
                                        dataset(trials_count,1) = 1;
                                    case 1
                                        dataset(trials_count,1) = 2;
                                end
                            else
                                switch metadata.TrialInfo{1,1}.rewarded(jj-1) + metadata.TrialInfo{1,1}.rewarded(jj-2)
                                    case 0
                                        dataset(trials_count,1) = 0;
                                    case 1
                                        switch metadata.TrialInfo{1,1}.rewarded(jj-1)
                                            case 0
                                                dataset(trials_count,1) = 1;
                                            case 1
                                                dataset(trials_count,1) = 2;
                                        end
                                    case 2
                                        dataset(trials_count,1) = 3;
                                end
                            end
                            
                            dataset(trials_count,2) = metadata.TrialInfo{1,1}.rewarded(jj); %outcome
                            switch sesh.block_order %modality
                                case 1
                                    dataset(trials_count,3) = 1;
                                case 2
                                    dataset(trials_count,3) = 2;
                            end
                            dataset(trials_count,4) = metadata.TrialInfo{1,1}.summary(jj,5); %arm
%                                                          dataset(trials_count,5) = metadata.TrialInfo{1,1}.approached(jj); %behav - app
                            dataset(trials_count,5) = metadata.TrialInfo{1,1}.summary(jj,15); %behav - trial length
                            dataset(trials_count,6) = jj;
                            dataset(trials_count,7) = firing_rate_np(trials_count); %FR
                            
                            trials_count = trials_count + 1;
 end
%                         end
                    end
                    
                    b2_start = b1_length + 1;
                    b2_length = length(FRATE.Cue.Trial_firing_rate_block2);
                    total = b1_length + b2_length;
                    
                    for jj = 1:b2_length
%                         if metadata.TrialInfo{1,2}.summary(jj,2) == metadata.TrialInfo{1,2}.summary(jj,3)
if metadata.TrialInfo{1,2}.nosepoke_length(jj) > epoch_start
        if metadata.TrialInfo{1,2}.nosepoke_length(jj) < time_window_end
            nosepoke_to_click(trials_count) = metadata.TrialInfo{1,2}.nosepoke_length(jj);
        else
            nosepoke_to_click(trials_count) = time_window_end;
        end
        end_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + nosepoke_to_click(trials_count);
        start_time(trials_count) = dataPoint.Nosepokes(trials_count)/1000 + time_window_start;
        
        % now, count spikes between start and end
        these_spk = spk_t(spk_t > start_time(trials_count) & spk_t < end_time(trials_count));
        
        % convert to firing rate and store
        firing_rate_np(trials_count) = length(these_spk) / (end_time(trials_count) - start_time(trials_count));                            
if jj == 1
                                dataset(trials_count,1) = NaN; %prev trial
                            elseif jj == 2
                                switch metadata.TrialInfo{1,2}.rewarded(1)
                                    case 0
                                        dataset(trials_count,1) = 1;
                                    case 1
                                        dataset(trials_count,1) = 2;
                                end
                            else
                                switch metadata.TrialInfo{1,2}.rewarded(jj-1) + metadata.TrialInfo{1,2}.rewarded(jj-2)
                                    case 0
                                        dataset(trials_count,1) = 0;
                                    case 1
                                        switch metadata.TrialInfo{1,2}.rewarded(jj-1)
                                            case 0
                                                dataset(trials_count,1) = 1;
                                            case 1
                                                dataset(trials_count,1) = 2;
                                        end
                                    case 2
                                        dataset(trials_count,1) = 3;
                                end
                            end
                            
                            dataset(trials_count,2) = metadata.TrialInfo{1,2}.rewarded(jj);
                            switch sesh.block_order
                                case 1
                                    dataset(trials_count,3) = 2;
                                case 2
                                    dataset(trials_count,3) = 1;
                            end
                            dataset(trials_count,4) = metadata.TrialInfo{1,2}.summary(jj,5);
%                                                          dataset(trials_count,5) = metadata.TrialInfo{1,2}.approached(jj);
                            dataset(trials_count,5) = metadata.TrialInfo{1,2}.summary(jj,15);
                            dataset(trials_count,6) = b1_length+jj;
                            dataset(trials_count,7) = firing_rate_np(trials_count);
                            
                            trials_count = trials_count + 1;
end
%                         end
                    end
                    
            end
            if sum(dataset(:,7)) < 10
                mdl{kk} = [];
            else
                %% 
                ds = mat2dataset(dataset,'VarNames',{'Previous','Outcome','Modality','Location','Latency','Trial','FiringRate'});
                
                %             mdl{kk}= stepwiseglm(ds,'constant','upper','linear','Distribution','poisson');
               try
                mdl{kk} = stepwiseglm(ds,'constant','upper','interactions','Distribution','poisson','PEnter',.01);
  catch %err
%     switch err.identifier
%         case 'stats:glmfit:IterationLimit'
      mdl{kk} = [];
%       continue
% %     elseif strcmp(err.identifier, 'Warning: Weights are ill-conditioned.   Data may be badly scaled, or the link function may be inappropriate.')
% %       mdl{kk} = [];
% %       continue
%         otherwise
%       rethrow(err); %some other unexpected error. Better stop
%     end
               end
            end
        else
            mdl{kk} = [];
        end
    else
        mdl{kk} = [];
    end
end

% save(cat(2,'E:\Jimmie\Jimmie\Analysis\2018-03-16-GLM_',Epoch,'_',num2str(iTime)),'mdl')
% clearvars -except iEpoch iTime
%     end
% end
%%
mat_files = dir('*.mat');

GLM_matrices.count.combined = [];
GLM_matrices.count.HFN_Inc = [];
GLM_matrices.count.SPN_Inc = [];
GLM_matrices.count.HFN_Dec = [];
GLM_matrices.count.SPN_Dec = [];
ALL_matrix = [];

count = 1;
count_HFN_Inc = 1;
count_SPN_Inc = 1;
count_HFN_Dec = 1;
count_SPN_Dec = 1;

summary_var.All.Cue = 0;
summary_var.HFN.Cue = 0;
summary_var.SPN.Cue = 0;
summary_var.Inc.Cue = 0;
summary_var.Dec.Cue = 0;
summary_var.HFN_Inc.Cue = 0;
summary_var.HFN_Dec.Cue = 0;
summary_var.SPN_Inc.Cue = 0;
summary_var.SPN_Dec.Cue = 0;

summary_var.All.Modality = 0;
summary_var.HFN.Modality = 0;
summary_var.SPN.Modality = 0;
summary_var.Inc.Modality = 0;
summary_var.Dec.Modality = 0;
summary_var.HFN_Inc.Modality = 0;
summary_var.HFN_Dec.Modality = 0;
summary_var.SPN_Inc.Modality = 0;
summary_var.SPN_Dec.Modality = 0;

summary_var.All.Location = 0;
summary_var.HFN.Location = 0;
summary_var.SPN.Location = 0;
summary_var.Inc.Location = 0;
summary_var.Dec.Location = 0;
summary_var.HFN_Inc.Location = 0;
summary_var.HFN_Dec.Location = 0;
summary_var.SPN_Inc.Location = 0;
summary_var.SPN_Dec.Location = 0;

summary_var.All.Outcome = 0;
summary_var.HFN.Outcome = 0;
summary_var.SPN.Outcome = 0;
summary_var.Inc.Outcome = 0;
summary_var.Dec.Outcome = 0;
summary_var.HFN_Inc.Outcome = 0;
summary_var.HFN_Dec.Outcome = 0;
summary_var.SPN_Inc.Outcome = 0;
summary_var.SPN_Dec.Outcome = 0;

summary_var.All.Latency = 0;
summary_var.HFN.Latency = 0;
summary_var.SPN.Latency = 0;
summary_var.Inc.Latency = 0;
summary_var.Dec.Latency = 0;
summary_var.HFN_Inc.Latency = 0;
summary_var.HFN_Dec.Latency = 0;
summary_var.SPN_Inc.Latency = 0;
summary_var.SPN_Dec.Latency = 0;

summary_var.All.Trial = 0;
summary_var.HFN.Trial = 0;
summary_var.SPN.Trial = 0;
summary_var.Inc.Trial = 0;
summary_var.Dec.Trial = 0;
summary_var.HFN_Inc.Trial = 0;
summary_var.HFN_Dec.Trial = 0;
summary_var.SPN_Inc.Trial = 0;
summary_var.SPN_Dec.Trial = 0;

summary_var.All.Previous = 0;
summary_var.HFN.Previous = 0;
summary_var.SPN.Previous = 0;
summary_var.Inc.Previous = 0;
summary_var.Dec.Previous = 0;
summary_var.HFN_Inc.Previous = 0;
summary_var.HFN_Dec.Previous = 0;
summary_var.SPN_Inc.Previous = 0;
summary_var.SPN_Dec.Previous = 0;

summary_var.All.ModxLoc = 0;
summary_var.HFN.ModxLoc = 0;
summary_var.SPN.ModxLoc = 0;
summary_var.Inc.ModxLoc = 0;
summary_var.Dec.ModxLoc = 0;
summary_var.HFN_Inc.ModxLoc = 0;
summary_var.HFN_Dec.ModxLoc = 0;
summary_var.SPN_Inc.ModxLoc = 0;
summary_var.SPN_Dec.ModxLoc = 0;

summary_var.All.ModxOut = 0;
summary_var.HFN.ModxOut = 0;
summary_var.SPN.ModxOut = 0;
summary_var.Inc.ModxOut = 0;
summary_var.Dec.ModxOut = 0;
summary_var.HFN_Inc.ModxOut = 0;
summary_var.HFN_Dec.ModxOut = 0;
summary_var.SPN_Inc.ModxOut = 0;
summary_var.SPN_Dec.ModxOut = 0;

summary_var.All.LocxOut = 0;
summary_var.HFN.LocxOut = 0;
summary_var.SPN.LocxOut = 0;
summary_var.Inc.LocxOut = 0;
summary_var.Dec.LocxOut = 0;
summary_var.HFN_Inc.LocxOut = 0;
summary_var.HFN_Dec.LocxOut = 0;
summary_var.SPN_Inc.LocxOut = 0;
summary_var.SPN_Dec.LocxOut = 0;

summary_var.All.ModxLocxOut = 0;
summary_var.HFN.ModxLocxOut = 0;
summary_var.SPN.ModxLocxOut = 0;
summary_var.Inc.ModxLocxOut = 0;
summary_var.Dec.ModxLocxOut = 0;
summary_var.HFN_Inc.ModxLocxOut = 0;
summary_var.HFN_Dec.ModxLocxOut = 0;
summary_var.SPN_Inc.ModxLocxOut = 0;
summary_var.SPN_Dec.ModxLocxOut = 0;

for kk = 1:length(dir('*.mat'))
    load(mat_files(kk).name);
    mat_overview.fname{kk} = mat_files(kk).name;
    disp(cat(2,num2str(kk),'/',num2str(length(dir('*.mat')))));
    
    block_drift.block1_length(kk) = length(FRATE.Cue.Trial_firing_rate_block1);
    block_drift.block1_half(kk) = round(block_drift.block1_length(kk) / 2);
    block_drift.b1_1st_avg(kk) = mean(FRATE.Cue.Trial_firing_rate_block1(1:block_drift.block1_half(kk)));
    block_drift.b1_2nd_avg(kk) = mean(FRATE.Cue.Trial_firing_rate_block1(block_drift.block1_half(kk)+1:end));
    block_drift.MWU_b1(kk) = ranksum(FRATE.Cue.Trial_firing_rate_block1(1:block_drift.block1_half(kk)),FRATE.Cue.Trial_firing_rate_block1(block_drift.block1_half(kk)+1:end));
    
    block_drift.block2_length(kk) = length(FRATE.Cue.Trial_firing_rate_block2);
    block_drift.block2_half(kk) = round(block_drift.block2_length(kk) / 2);
    block_drift.b2_1st_avg(kk) = mean(FRATE.Cue.Trial_firing_rate_block2(1:block_drift.block2_half(kk)));
    block_drift.b2_2nd_avg(kk) = mean(FRATE.Cue.Trial_firing_rate_block2(block_drift.block2_half(kk)+1:end));
    block_drift.MWU_b2(kk) = ranksum(FRATE.Cue.Trial_firing_rate_block2(1:block_drift.block2_half(kk)),FRATE.Cue.Trial_firing_rate_block2(block_drift.block2_half(kk)+1:end));
    
    class.all.isi{kk} = diff(spk_t);
    class.all.median_isi(kk) = median(class.all.isi{kk});
    class.all.frate(kk) = FRATE.Overall.firing_rate_total;
    class.all.sorted_isi{kk} = sort(class.all.isi{kk},'descend');
    
    switch isempty(mdl{kk})
        case 0
            switch block_drift.MWU_b1(kk) < .01 || block_drift.MWU_b2(kk) < .01
                case 0
                    if RANK.two.Trial > 975 || RANK.two.Trial < 26
                        if TESTS.WSR.Task.Trial_b4_vs_Trial < .01
                            summary_var.All.Cue = summary_var.All.Cue + 1;
                            switch class.all.sorted_isi{kk}(5) < 2
                                case 1
                                    summary_var.HFN.Cue = summary_var.HFN.Cue + 1;
                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                        case 1
                                            summary_var.HFN_Inc.Cue = summary_var.HFN_Inc.Cue + 1;
                                            summary_var.Inc.Cue = summary_var.Inc.Cue + 1;
                                        case 0
                                            summary_var.HFN_Dec.Cue = summary_var.HFN_Dec.Cue + 1;
                                            summary_var.Dec.Cue = summary_var.Dec.Cue + 1;
                                    end
                                case 0
                                    summary_var.SPN.Cue = summary_var.SPN.Cue + 1;
                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                        case 1
                                            summary_var.SPN_Inc.Cue = summary_var.SPN_Inc.Cue + 1;
                                            summary_var.Inc.Cue = summary_var.Inc.Cue + 1;
                                        case 0
                                            summary_var.SPN_Dec.Cue = summary_var.SPN_Dec.Cue + 1;
                                            summary_var.Dec.Cue = summary_var.Dec.Cue + 1;
                                    end
                            end
                            
                            for ll = 2:length(mdl{1,kk}.CoefficientNames)
                                if mdl{1,kk}.Coefficients{ll,4} < .01 %&& mdl{1,kk}.Coefficients{ll,4} ~= 0
                                    idx = [];
                                    dev_location = [];
                                    dev_raw = [];
                                    dev_percent = [];
                                    switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Modality');
                                        case 1
                                            summary_var.All.Modality = summary_var.All.Modality + 1;
                                            GLM_matrices.count.combined(count,1) = 1;
                                            ALL_matrix(kk,1) = 1;
                                            GLM_matrices.Comparison.Modality{kk} = removeTerms(mdl{kk},'Modality');
                                            GLM_matrices.Rsquared.ALL(kk,1) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Modality{kk}.Rsquared.Adjusted) * 100;                                           
                                            idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Modality');
                                            dev_location = find(idx == 1);
                                            dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                            dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                            GLM_matrices.dev_raw.combined(count,1) = dev_raw;
                                            GLM_matrices.dev_percent.combined(count,1) = dev_percent;
                                            switch class.all.sorted_isi{kk}(5) < 2
                                                case 1
                                                    summary_var.HFN.Modality = summary_var.HFN.Modality + 1;
                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                        case 1
                                                            summary_var.HFN_Inc.Modality = summary_var.HFN_Inc.Modality + 1;
                                                            summary_var.Inc.Modality = summary_var.Inc.Modality + 1;
                                                            GLM_matrices.count.HFN_Inc(count_HFN_Inc,1) = 1;
                                                            GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,1) = dev_raw;
                                                            GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,1) = dev_percent;
                                                            GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,1) = GLM_matrices.Rsquared.ALL(kk,1);
                                                        case 0
                                                            summary_var.HFN_Dec.Modality = summary_var.HFN_Dec.Modality + 1;
                                                            summary_var.Dec.Modality = summary_var.Dec.Modality + 1;
                                                            GLM_matrices.count.HFN_Dec(count_HFN_Dec,1) = 1;
                                                            GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,1) = dev_raw;
                                                            GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,1) = dev_percent;
                                                            GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,1) = GLM_matrices.Rsquared.ALL(kk,1);
                                                    end
                                                case 0
                                                    summary_var.SPN.Modality = summary_var.SPN.Modality + 1;
                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                        case 1
                                                            summary_var.SPN_Inc.Modality = summary_var.SPN_Inc.Modality + 1;
                                                            summary_var.Inc.Modality = summary_var.Inc.Modality + 1;
                                                            GLM_matrices.count.SPN_Inc(count_SPN_Inc,1) = 1;
                                                            GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,1) = dev_raw;
                                                            GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,1) = dev_percent;
                                                            GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,1) = GLM_matrices.Rsquared.ALL(kk,1);
                                                        case 0
                                                            summary_var.SPN_Dec.Modality = summary_var.SPN_Dec.Modality + 1;
                                                            summary_var.Dec.Modality = summary_var.Dec.Modality + 1;
                                                            GLM_matrices.count.SPN_Dec(count_SPN_Dec,1) = 1;
                                                            GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,1) = dev_raw;
                                                            GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,1) = dev_percent;
                                                            GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,1) = GLM_matrices.Rsquared.ALL(kk,1);
                                                    end
                                            end
                                        case 0
                                            switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Location');
                                                case 1
                                                    summary_var.All.Location = summary_var.All.Location + 1;
                                                    GLM_matrices.count.combined(count,2) = 1;
                                                    ALL_matrix(kk,2) = 1;
                                                    GLM_matrices.Comparison.Location{kk} = removeTerms(mdl{kk},'Location');
                                            GLM_matrices.Rsquared.ALL(kk,2) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Location{kk}.Rsquared.Adjusted) * 100;                                                    
                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Location');
                                                    dev_location = find(idx == 1);
                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                    GLM_matrices.dev_raw.combined(count,2) = dev_raw;
                                                    GLM_matrices.dev_percent.combined(count,2) = dev_percent;
                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                        case 1
                                                            summary_var.HFN.Location = summary_var.HFN.Location + 1;
                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                case 1
                                                                    summary_var.HFN_Inc.Location = summary_var.HFN_Inc.Location + 1;
                                                                    summary_var.Inc.Location = summary_var.Inc.Location + 1;
                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,2) = 1;
                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,2) = dev_raw;
                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,2) = dev_percent;
                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,2) = GLM_matrices.Rsquared.ALL(kk,2);
                                                                case 0
                                                                    summary_var.HFN_Dec.Location = summary_var.HFN_Dec.Location + 1;
                                                                    summary_var.Dec.Location = summary_var.Dec.Location + 1;
                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,2) = 1;
                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,2) = dev_raw;
                                                            GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,2) = dev_percent;
                                                            GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,2) = GLM_matrices.Rsquared.ALL(kk,2);
                                                            end
                                                        case 0
                                                            summary_var.SPN.Location = summary_var.SPN.Location + 1;
                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                case 1
                                                                    summary_var.SPN_Inc.Location = summary_var.SPN_Inc.Location + 1;
                                                                    summary_var.Inc.Location = summary_var.Inc.Location + 1;
                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,2) = 1;
                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,2) = dev_raw;
                                                            GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,2) = dev_percent;
                                                            GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,2) = GLM_matrices.Rsquared.ALL(kk,2);
                                                                case 0
                                                                    summary_var.SPN_Dec.Location = summary_var.SPN_Dec.Location + 1;
                                                                    summary_var.Dec.Location = summary_var.Dec.Location + 1;
                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,2) = 1;
                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,2) = dev_raw;
                                                            GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,2) = dev_percent;
                                                            GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,2) = GLM_matrices.Rsquared.ALL(kk,2);
                                                            end
                                                    end
                                                case 0
                                                    switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Outcome');
                                                        case 1
                                                                    summary_var.All.Outcome = summary_var.All.Outcome + 1;
                                                                    GLM_matrices.count.combined(count,3) = 1;
                                                                    ALL_matrix(kk,3) = 1;
                                                                    GLM_matrices.Comparison.Outcome{kk} = removeTerms(mdl{kk},'Outcome');
                                                                    GLM_matrices.Rsquared.ALL(kk,3) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Outcome{kk}.Rsquared.Adjusted) * 100;
                                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Outcome');
                                                                    dev_location = find(idx == 1);
                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                    GLM_matrices.dev_raw.combined(count,3) = dev_raw;
                                                                    GLM_matrices.dev_percent.combined(count,3) = dev_percent;
                                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                                        case 1
                                                                            summary_var.HFN.Outcome = summary_var.HFN.Outcome + 1;
                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                case 1
                                                                                    summary_var.HFN_Inc.Outcome = summary_var.HFN_Inc.Outcome + 1;
                                                                                    summary_var.Inc.Outcome = summary_var.Inc.Outcome + 1;
                                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,3) = 1;
                                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,3) = dev_raw;
                                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,3) = dev_percent;
                                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,3) = GLM_matrices.Rsquared.ALL(kk,3);
                                                                                case 0
                                                                                    summary_var.HFN_Dec.Outcome = summary_var.HFN_Dec.Outcome + 1;
                                                                                    summary_var.Dec.Outcome = summary_var.Dec.Outcome + 1;
                                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,3) = 1;
                                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,3) = dev_raw;
                                                                                    GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,3) = dev_percent;
                                                                                    GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,3) = GLM_matrices.Rsquared.ALL(kk,3);
                                                                            end
                                                                        case 0
                                                                            summary_var.SPN.Outcome = summary_var.SPN.Outcome + 1;
                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                case 1
                                                                                    summary_var.SPN_Inc.Outcome = summary_var.SPN_Inc.Outcome + 1;
                                                                                    summary_var.Inc.Outcome = summary_var.Inc.Outcome + 1;
                                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,3) = 1;
                                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,3) = dev_raw;
                                                                                    GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,3) = dev_percent;
                                                                                    GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,3) = GLM_matrices.Rsquared.ALL(kk,3);
                                                                                case 0
                                                                                    summary_var.SPN_Dec.Outcome = summary_var.SPN_Dec.Outcome + 1;
                                                                                    summary_var.Dec.Outcome = summary_var.Dec.Outcome + 1;
                                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,3) = 1;
                                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,3) = dev_raw;
                                                                                    GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,3) = dev_percent;
                                                                                    GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,3) = GLM_matrices.Rsquared.ALL(kk,3);
                                                                            end
                                                                    end
                                                                case 0                                                           
                                                        case 0
                                                            switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Latency');
                                                                case 1
                                                                    summary_var.All.Latency = summary_var.All.Latency + 1;
                                                                    GLM_matrices.count.combined(count,4) = 1;
                                                                    ALL_matrix(kk,4) = 1;
                                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Latency');
                                                                    GLM_matrices.Comparison.Latency{kk} = removeTerms(mdl{kk},'Latency');
                                                                    GLM_matrices.Rsquared.ALL(kk,4) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Latency{kk}.Rsquared.Adjusted) * 100;
                                                                    dev_location = find(idx == 1);
                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                    GLM_matrices.dev_raw.combined(count,4) = dev_raw;
                                                                    GLM_matrices.dev_percent.combined(count,4) = dev_percent;
                                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                                        case 1
                                                                            summary_var.HFN.Latency = summary_var.HFN.Latency + 1;
                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                case 1
                                                                                    summary_var.HFN_Inc.Latency = summary_var.HFN_Inc.Latency + 1;
                                                                                    summary_var.Inc.Latency = summary_var.Inc.Latency + 1;
                                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,4) = 1;
                                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,4) = dev_raw;
                                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,4) = dev_percent;
                                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,4) = GLM_matrices.Rsquared.ALL(kk,4);
                                                                                case 0
                                                                                    summary_var.HFN_Dec.Latency = summary_var.HFN_Dec.Latency + 1;
                                                                                    summary_var.Dec.Latency = summary_var.Dec.Latency + 1;
                                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,4) = 1;
                                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,4) = dev_raw;
                                                                                    GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,4) = dev_percent;
                                                                                    GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,4) = GLM_matrices.Rsquared.ALL(kk,4);
                                                                            end
                                                                        case 0
                                                                            summary_var.SPN.Latency = summary_var.SPN.Latency + 1;
                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                case 1
                                                                                    summary_var.SPN_Inc.Latency = summary_var.SPN_Inc.Latency + 1;
                                                                                    summary_var.Inc.Latency = summary_var.Inc.Latency + 1;
                                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,4) = 1;
                                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,4) = dev_raw;
                                                                                    GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,4) = dev_percent;
                                                                                    GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,4) = GLM_matrices.Rsquared.ALL(kk,4);
                                                                                case 0
                                                                                    summary_var.SPN_Dec.Latency = summary_var.SPN_Dec.Latency + 1;
                                                                                    summary_var.Dec.Latency = summary_var.Dec.Latency + 1;
                                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,4) = 1;
                                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,4) = dev_raw;
                                                                                    GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,4) = dev_percent;
                                                                                    GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,4) = GLM_matrices.Rsquared.ALL(kk,4);
                                                                            end
                                                                    end
                                                                case 0
                                                                    switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Trial');
                                                                        case 1
                                                                            summary_var.All.Trial = summary_var.All.Trial + 1;
                                                                            GLM_matrices.count.combined(count,5) = 1;
                                                                            ALL_matrix(kk,5) = 1;
                                                                            GLM_matrices.Comparison.Trial{kk} = removeTerms(mdl{kk},'Trial');
                                                                    GLM_matrices.Rsquared.ALL(kk,5) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Trial{kk}.Rsquared.Adjusted) * 100;
                                                                            idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Trial');
                                                                            dev_location = find(idx == 1);
                                                                            dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                            dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                            GLM_matrices.dev_raw.combined(count,5) = dev_raw;
                                                                            GLM_matrices.dev_percent.combined(count,5) = dev_percent;
                                                                            switch class.all.sorted_isi{kk}(5) < 2
                                                                                case 1
                                                                                    summary_var.HFN.Trial = summary_var.HFN.Trial + 1;
                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                        case 1
                                                                                            summary_var.HFN_Inc.Trial = summary_var.HFN_Inc.Trial + 1;
                                                                                            summary_var.Inc.Trial = summary_var.Inc.Trial + 1;
                                                                                            GLM_matrices.count.HFN_Inc(count_HFN_Inc,5) = 1;
                                                                                            GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,5) = dev_raw;
                                                                                            GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,5) = dev_percent;
                                                                                            GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,5) = GLM_matrices.Rsquared.ALL(kk,5);
                                                                                        case 0
                                                                                            summary_var.HFN_Dec.Trial = summary_var.HFN_Dec.Trial + 1;
                                                                                            summary_var.Dec.Trial = summary_var.Dec.Trial + 1;
                                                                                            GLM_matrices.count.HFN_Dec(count_HFN_Dec,5) = 1;
                                                                                            GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,5) = dev_raw;
                                                                                            GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,5) = dev_percent;
                                                                                            GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,5) = GLM_matrices.Rsquared.ALL(kk,5);
                                                                                    end
                                                                                case 0
                                                                                    summary_var.SPN.Trial = summary_var.SPN.Trial + 1;
                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                        case 1
                                                                                            summary_var.SPN_Inc.Trial = summary_var.SPN_Inc.Trial + 1;
                                                                                            summary_var.Inc.Trial = summary_var.Inc.Trial + 1;
                                                                                            GLM_matrices.count.SPN_Inc(count_SPN_Inc,5) = 1;
                                                                                            GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,5) = dev_raw;
                                                                                            GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,5) = dev_percent;
                                                                                            GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,5) = GLM_matrices.Rsquared.ALL(kk,5);
                                                                                        case 0
                                                                                            summary_var.SPN_Dec.Trial = summary_var.SPN_Dec.Trial + 1;
                                                                                            summary_var.Dec.Trial = summary_var.Dec.Trial + 1;
                                                                                            GLM_matrices.count.SPN_Dec(count_SPN_Dec,5) = 1;
                                                                                            GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,5) = dev_raw;
                                                                                            GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,5) = dev_percent;
                                                                                            GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,5) = GLM_matrices.Rsquared.ALL(kk,5);
                                                                                    end
                                                                            end
                                                                        case 0
                                                                            switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Previous');
                                                                                case 1
                                                                                    summary_var.All.Previous = summary_var.All.Previous + 1;
                                                                                    GLM_matrices.count.combined(count,6) = 1;
                                                                                    ALL_matrix(kk,6) = 1;
                                                                                    GLM_matrices.Comparison.Previous{kk} = removeTerms(mdl{kk},'Previous');
                                                                    GLM_matrices.Rsquared.ALL(kk,6) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.Previous{kk}.Rsquared.Adjusted) * 100;
                                                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Previous');
                                                                                    dev_location = find(idx == 1);
                                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                                    GLM_matrices.dev_raw.combined(count,6) = dev_raw;
                                                                                    GLM_matrices.dev_percent.combined(count,6) = dev_percent;
                                                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                                                        case 1
                                                                                            summary_var.HFN.Previous = summary_var.HFN.Previous + 1;
                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                case 1
                                                                                                    summary_var.HFN_Inc.Previous = summary_var.HFN_Inc.Previous + 1;
                                                                                                    summary_var.Inc.Previous = summary_var.Inc.Previous + 1;
                                                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,6) = 1;
                                                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,6) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,6) = dev_percent;
                                                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,6) = GLM_matrices.Rsquared.ALL(kk,6);
                                                                                                case 0
                                                                                                    summary_var.HFN_Dec.Previous = summary_var.HFN_Dec.Previous + 1;
                                                                                                    summary_var.Dec.Previous = summary_var.Dec.Previous + 1;
                                                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,6) = 1;
                                                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,6) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,6) = dev_percent;
                                                                                                    GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,6) = GLM_matrices.Rsquared.ALL(kk,6);
                                                                                            end
                                                                                        case 0
                                                                                            summary_var.SPN.Previous = summary_var.SPN.Previous + 1;
                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                case 1
                                                                                                    summary_var.SPN_Inc.Previous = summary_var.SPN_Inc.Previous + 1;
                                                                                                    summary_var.Inc.Previous = summary_var.Inc.Previous + 1;
                                                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,6) = 1;
                                                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,6) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,6) = dev_percent;
                                                                                                    GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,6) = GLM_matrices.Rsquared.ALL(kk,6);
                                                                                                case 0
                                                                                                    summary_var.SPN_Dec.Previous = summary_var.SPN_Dec.Previous + 1;
                                                                                                    summary_var.Dec.Previous = summary_var.Dec.Previous + 1;
                                                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,6) = 1;
                                                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,6) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,6) = dev_percent;
                                                                                                    GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,6) = GLM_matrices.Rsquared.ALL(kk,6);
                                                                                            end
                                                                                    end
                                                                                case 0
                                                                                    switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Modality:Location');
                                                                                        case 1
                                                                                            summary_var.All.ModxLoc = summary_var.All.ModxLoc + 1;
                                                                                            GLM_matrices.count.combined(count,7) = 1;
                                                                                            ALL_matrix(kk,7) = 1;
                                                                                            GLM_matrices.Comparison.ModxLoc{kk} = removeTerms(mdl{kk},'Modality:Location');
                                                                    GLM_matrices.Rsquared.ALL(kk,7) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.ModxLoc{kk}.Rsquared.Adjusted) * 100;
                                                                                            idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Modality:Location');
                                                                                            dev_location = find(idx == 1);
                                                                                            dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                                            dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                                            GLM_matrices.dev_raw.combined(count,7) = dev_raw;
                                                                                            GLM_matrices.dev_percent.combined(count,7) = dev_percent;
                                                                                            switch class.all.sorted_isi{kk}(5) < 2
                                                                                                case 1
                                                                                                    summary_var.HFN.ModxLoc = summary_var.HFN.ModxLoc + 1;
                                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                        case 1
                                                                                                            summary_var.HFN_Inc.ModxLoc = summary_var.HFN_Inc.ModxLoc + 1;
                                                                                                            summary_var.Inc.ModxLoc = summary_var.Inc.ModxLoc + 1;
                                                                                                            GLM_matrices.count.HFN_Inc(count_HFN_Inc,7) = 1;
                                                                                                            GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,7) = dev_raw;
                                                                                                            GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,7) = dev_percent;
                                                                                                            GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,7) = GLM_matrices.Rsquared.ALL(kk,7);
                                                                                                        case 0
                                                                                                            summary_var.HFN_Dec.ModxLoc = summary_var.HFN_Dec.ModxLoc + 1;
                                                                                                            summary_var.Dec.ModxLoc = summary_var.Dec.ModxLoc + 1;
                                                                                                            GLM_matrices.count.HFN_Dec(count_HFN_Dec,7) = 1;
                                                                                                            GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,7) = dev_raw;
                                                                                                            GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,7) = dev_percent;
                                                                                                            GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,7) = GLM_matrices.Rsquared.ALL(kk,7);
                                                                                                    end
                                                                                                case 0
                                                                                                    summary_var.SPN.ModxLoc = summary_var.SPN.ModxLoc + 1;
                                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                        case 1
                                                                                                            summary_var.SPN_Inc.ModxLoc = summary_var.SPN_Inc.ModxLoc + 1;
                                                                                                            summary_var.Inc.ModxLoc = summary_var.Inc.ModxLoc + 1;
                                                                                                            GLM_matrices.count.SPN_Inc(count_SPN_Inc,7) = 1;
                                                                                                            GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,7) = dev_raw;
                                                                                                            GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,7) = dev_percent;
                                                                                                            GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,7) = GLM_matrices.Rsquared.ALL(kk,7);
                                                                                                        case 0
                                                                                                            summary_var.SPN_Dec.ModxLoc = summary_var.SPN_Dec.ModxLoc + 1;
                                                                                                            summary_var.Dec.ModxLoc = summary_var.Dec.ModxLoc + 1;
                                                                                                            GLM_matrices.count.SPN_Dec(count_SPN_Dec,7) = 1;
                                                                                                            GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,7) = dev_raw;
                                                                                                            GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,7) = dev_percent;
                                                                                                            GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,7) = GLM_matrices.Rsquared.ALL(kk,7);
                                                                                                    end
                                                                                            end
                                                                                        case 0
                                                                                            switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Outcome:Modality');
                                                                                                case 1
                                                                                                    summary_var.All.ModxOut = summary_var.All.ModxOut + 1;
                                                                                                    GLM_matrices.count.combined(count,8) = 1;
                                                                                                    ALL_matrix(kk,8) = 1;
                                                                                                    GLM_matrices.Comparison.ModxOut{kk} = removeTerms(mdl{kk},'Outcome:Modality');
                                                                    GLM_matrices.Rsquared.ALL(kk,8) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.ModxOut{kk}.Rsquared.Adjusted) * 100;
                                                                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Outcome:Modality');
                                                                                                    dev_location = find(idx == 1);
                                                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                                                    GLM_matrices.dev_raw.combined(count,8) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.combined(count,8) = dev_percent;
                                                                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                                                                        case 1
                                                                                                            summary_var.HFN.ModxOut = summary_var.HFN.ModxOut + 1;
                                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                case 1
                                                                                                                    summary_var.HFN_Inc.ModxOut = summary_var.HFN_Inc.ModxOut + 1;
                                                                                                                    summary_var.Inc.ModxOut = summary_var.Inc.ModxOut + 1;
                                                                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,8) = 1;
                                                                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,8) = dev_raw;
                                                                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,8) = dev_percent;
                                                                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,8) = GLM_matrices.Rsquared.ALL(kk,8);
                                                                                                                case 0
                                                                                                                    summary_var.HFN_Dec.ModxOut = summary_var.HFN_Dec.ModxOut + 1;
                                                                                                                    summary_var.Dec.ModxOut = summary_var.Dec.ModxOut + 1;
                                                                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,8) = 1;
                                                                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,8) = dev_raw;
                                                                                                                    GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,8) = dev_percent;
                                                                                                                    GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,8) = GLM_matrices.Rsquared.ALL(kk,8);
                                                                                                            end
                                                                                                        case 0
                                                                                                            summary_var.SPN.ModxOut = summary_var.SPN.ModxOut + 1;
                                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                case 1
                                                                                                                    summary_var.SPN_Inc.ModxOut = summary_var.SPN_Inc.ModxOut + 1;
                                                                                                                    summary_var.Inc.ModxOut = summary_var.Inc.ModxOut + 1;
                                                                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,8) = 1;
                                                                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,8) = dev_raw;
                                                                                                                    GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,8) = dev_percent;
                                                                                                                    GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,8) = GLM_matrices.Rsquared.ALL(kk,8);
                                                                                                                case 0
                                                                                                                    summary_var.SPN_Dec.ModxOut = summary_var.SPN_Dec.ModxOut + 1;
                                                                                                                    summary_var.Dec.ModxOut = summary_var.Dec.ModxOut + 1;
                                                                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,8) = 1;
                                                                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,8) = dev_raw;
                                                                                                                    GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,8) = dev_percent;
                                                                                                                    GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,8) = GLM_matrices.Rsquared.ALL(kk,8);
                                                                                                            end
                                                                                                    end
                                                                                                case 0
                                                                                                    switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Outcome:Location');
                                                                                                        case 1
                                                                                                            summary_var.All.LocxOut = summary_var.All.LocxOut + 1;
                                                                                                            GLM_matrices.count.combined(count,9) = 1;
                                                                                                            ALL_matrix(kk,9) = 1;
                                                                                                            GLM_matrices.Comparison.LocxOut{kk} = removeTerms(mdl{kk},'Outcome:Location');
                                                                    GLM_matrices.Rsquared.ALL(kk,9) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.LocxOut{kk}.Rsquared.Adjusted) * 100;
                                                                                                            idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Outcome:Location');
                                                                                                    dev_location = find(idx == 1);
                                                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                                                    GLM_matrices.dev_raw.combined(count,9) = dev_raw;
                                                                                                    GLM_matrices.dev_percent.combined(count,9) = dev_percent;
                                                                                                            switch class.all.sorted_isi{kk}(5) < 2
                                                                                                                case 1
                                                                                                                    summary_var.HFN.LocxOut = summary_var.HFN.LocxOut + 1;
                                                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                        case 1
                                                                                                                            summary_var.HFN_Inc.LocxOut = summary_var.HFN_Inc.LocxOut + 1;
                                                                                                                            summary_var.Inc.LocxOut = summary_var.Inc.LocxOut + 1;
                                                                                                                            GLM_matrices.count.HFN_Inc(count_HFN_Inc,9) = 1;
                                                                                                                            GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,9) = dev_raw;
                                                                                                                            GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,9) = dev_percent;
                                                                                                                            GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,9) = GLM_matrices.Rsquared.ALL(kk,9);
                                                                                                                        case 0
                                                                                                                            summary_var.HFN_Dec.LocxOut = summary_var.HFN_Dec.LocxOut + 1;
                                                                                                                            summary_var.Dec.LocxOut = summary_var.Dec.LocxOut + 1;
                                                                                                                            GLM_matrices.count.HFN_Dec(count_HFN_Dec,9) = 1;
                                                                                                                            GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,9) = dev_raw;
                                                                                                                            GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,9) = dev_percent;
                                                                                                                            GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,9) = GLM_matrices.Rsquared.ALL(kk,9);
                                                                                                                    end
                                                                                                                case 0
                                                                                                                    summary_var.SPN.LocxOut = summary_var.SPN.LocxOut + 1;
                                                                                                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                        case 1
                                                                                                                            summary_var.SPN_Inc.LocxOut = summary_var.SPN_Inc.LocxOut + 1;
                                                                                                                            summary_var.Inc.LocxOut = summary_var.Inc.LocxOut + 1;
                                                                                                                            GLM_matrices.count.SPN_Inc(count_SPN_Inc,9) = 1;
                                                                                                                            GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,9) = dev_raw;
                                                                                                                            GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,9) = dev_percent;
                                                                                                                            GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,9) = GLM_matrices.Rsquared.ALL(kk,9);
                                                                                                                        case 0
                                                                                                                            summary_var.SPN_Dec.LocxOut = summary_var.SPN_Dec.LocxOut + 1;
                                                                                                                            summary_var.Dec.LocxOut = summary_var.Dec.LocxOut + 1;
                                                                                                                            GLM_matrices.count.SPN_Dec(count_SPN_Dec,9) = 1;
                                                                                                                            GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,9) = dev_raw;
                                                                                                                            GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,9) = dev_percent;
                                                                                                                            GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,9) = GLM_matrices.Rsquared.ALL(kk,9);
                                                                                                                    end
                                                                                                            end
                                                                                                        case 0                                                                                                          
                                                                                                            switch strcmp(mdl{1,kk}.CoefficientNames(ll),'Outcome:Modality:Location');
                                                                                                                case 1
                                                                                                                    summary_var.All.ModxLocxOut = summary_var.All.ModxLocxOut + 1;
                                                                                                                    GLM_matrices.count.combined(count,10) = 1;
                                                                                                                    ALL_matrix(kk,10) = 1;
                                                                                                                    GLM_matrices.Comparison.ModxLocxOut{kk} = removeTerms(mdl{kk},'Outcome:Modality:Location');
                                                                    GLM_matrices.Rsquared.ALL(kk,10) = (mdl{kk}.Rsquared.Adjusted - GLM_matrices.Comparison.ModxLocxOut{kk}.Rsquared.Adjusted) * 100;
                                                                                                                    idx = strcmp(mdl{1,kk}.Steps.History.TermName,'Outcome:Modality:Location');
                                                                                                                    dev_location = find(idx == 1);
                                                                                                                    dev_raw = mdl{1,kk}.Steps.History.Deviance(dev_location-1) - mdl{1,kk}.Steps.History.Deviance(dev_location);
                                                                                                                    dev_percent = (dev_raw / mdl{1,kk}.Steps.History.Deviance(dev_location-1)) * 100;
                                                                                                                    GLM_matrices.dev_raw.combined(count,10) = dev_raw;
                                                                                                                    GLM_matrices.dev_percent.combined(count,10) = dev_percent;
                                                                                                                    switch class.all.sorted_isi{kk}(5) < 2
                                                                                                                        case 1
                                                                                                                            summary_var.HFN.ModxLocxOut = summary_var.HFN.ModxLocxOut + 1;
                                                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                                case 1
                                                                                                                                    summary_var.HFN_Inc.ModxLocxOut = summary_var.HFN_Inc.ModxLocxOut + 1;
                                                                                                                                    summary_var.Inc.ModxLocxOut = summary_var.Inc.ModxLocxOut + 1;
                                                                                                                                    GLM_matrices.count.HFN_Inc(count_HFN_Inc,10) = 1;
                                                                                                                                    GLM_matrices.dev_raw.HFN_Inc(count_HFN_Inc,10) = dev_raw;
                                                                                                                                    GLM_matrices.dev_percent.HFN_Inc(count_HFN_Inc,10) = dev_percent;
                                                                                                                                    GLM_matrices.Rsquared.HFN_Inc(count_HFN_Inc,10) = GLM_matrices.Rsquared.ALL(kk,10);
                                                                                                                                case 0
                                                                                                                                    summary_var.HFN_Dec.ModxLocxOut = summary_var.HFN_Dec.ModxLocxOut + 1;
                                                                                                                                    summary_var.Dec.ModxLocxOut = summary_var.Dec.ModxLocxOut + 1;
                                                                                                                                    GLM_matrices.count.HFN_Dec(count_HFN_Dec,10) = 1;
                                                                                                                                    GLM_matrices.dev_raw.HFN_Dec(count_HFN_Dec,10) = dev_raw;
                                                                                                                                    GLM_matrices.dev_percent.HFN_Dec(count_HFN_Dec,10) = dev_percent;
                                                                                                                                    GLM_matrices.Rsquared.HFN_Dec(count_HFN_Dec,10) = GLM_matrices.Rsquared.ALL(kk,10);
                                                                                                                            end
                                                                                                                        case 0
                                                                                                                            summary_var.SPN.ModxLocxOut = summary_var.SPN.ModxLocxOut + 1;
                                                                                                                            switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                                                                                                                case 1
                                                                                                                                    summary_var.SPN_Inc.ModxLocxOut = summary_var.SPN_Inc.ModxLocxOut + 1;
                                                                                                                                    summary_var.Inc.ModxLocxOut = summary_var.Inc.ModxLocxOut + 1;
                                                                                                                                    GLM_matrices.count.SPN_Inc(count_SPN_Inc,10) = 1;
                                                                                                                                    GLM_matrices.dev_raw.SPN_Inc(count_SPN_Inc,10) = dev_raw;
                                                                                                                                    GLM_matrices.dev_percent.SPN_Inc(count_SPN_Inc,10) = dev_percent;
                                                                                                                                    GLM_matrices.Rsquared.SPN_Inc(count_SPN_Inc,10) = GLM_matrices.Rsquared.ALL(kk,10);
                                                                                                                                case 0
                                                                                                                                    summary_var.SPN_Dec.ModxLocxOut = summary_var.SPN_Dec.ModxLocxOut + 1;
                                                                                                                                    summary_var.Dec.ModxLocxOut = summary_var.Dec.ModxLocxOut + 1;
                                                                                                                                    GLM_matrices.count.SPN_Dec(count_SPN_Dec,10) = 1;
                                                                                                                                    GLM_matrices.dev_raw.SPN_Dec(count_SPN_Dec,10) = dev_raw;
                                                                                                                                    GLM_matrices.dev_percent.SPN_Dec(count_SPN_Dec,10) = dev_percent;
                                                                                                                                    GLM_matrices.Rsquared.SPN_Dec(count_SPN_Dec,10) = GLM_matrices.Rsquared.ALL(kk,10);
                                                                                                                            end
                                                                                                                    end
                                                                                                                case 0
                                                                                                            end
                                                                                                    end
                                                                                            end
                                                                                    end
                                                                            end
                                                                    end
                                                            end
                                                    end
                                            end
                                    end
                                end
                            end
                            count = count + 1;
                            switch class.all.sorted_isi{kk}(5) < 2
                                case 1
                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                        case 1
                                            count_HFN_Inc = count_HFN_Inc + 1;
                                        case 0
                                            count_HFN_Dec = count_HFN_Dec + 1;
                                    end
                                case 0
                                    switch mean(FRATE.Task.Trial_firing_rate) > mean(FRATE.Task.Trial_B4_firing_rate)
                                        case 1
                                            count_SPN_Inc = count_SPN_Inc + 1;
                                        case 0
                                            count_SPN_Dec = count_SPN_Dec + 1;
                                    end
                            end
                        end
                    end
            end
    end
end

save(cat(2,'E:\Jimmie\Jimmie\Analysis\2018-03-26-GLM_',Epoch,'_',num2str(iTime),'-round',num2str(iRound),'.mat'),'mdl','ALL_matrix','block_drift','GLM_matrices','summary_var')
clearvars -except iEpoch iTime iRound
    end
end
end
%%
summary_table{1,1} = 'Category';
summary_table{2,1} = 'Cue-evoked';
summary_table{3,1} = 'Modality';
summary_table{4,1} = 'Location';
summary_table{5,1} = 'Outcome';
summary_table{6,1} = 'Latency';
summary_table{7,1} = 'Trial';
summary_table{8,1} = 'Previous trial';
summary_table{9,1} = 'Modality x Location';
summary_table{10,1} = 'Modality x Outcome';
summary_table{11,1} = 'Location x Outcome';
summary_table{12,1} = 'Modality x Location x Outcome';

summary_table{1,2} = 'All';
summary_table{2,2} = summary_var.All.Cue;
summary_table{3,2} = summary_var.All.Modality;
summary_table{4,2} = summary_var.All.Location;
summary_table{5,2} = summary_var.All.Outcome;
summary_table{6,2} = summary_var.All.Latency;
summary_table{7,2} = summary_var.All.Trial;
summary_table{8,2} = summary_var.All.Previous;
summary_table{9,2} = summary_var.All.ModxLoc;
summary_table{10,2} = summary_var.All.ModxOut;
summary_table{11,2} = summary_var.All.LocxOut;
summary_table{12,2} = summary_var.All.ModxLocxOut;

summary_table{1,3} = 'SPN';
summary_table{2,3} = summary_var.SPN.Cue;
summary_table{3,3} = summary_var.SPN.Modality;
summary_table{4,3} = summary_var.SPN.Location;
summary_table{5,3} = summary_var.SPN.Outcome;
summary_table{6,3} = summary_var.SPN.Latency;
summary_table{7,3} = summary_var.SPN.Trial;
summary_table{8,3} = summary_var.SPN.Previous;
summary_table{9,3} = summary_var.SPN.ModxLoc;
summary_table{10,3} = summary_var.SPN.ModxOut;
summary_table{11,3} = summary_var.SPN.LocxOut;
summary_table{12,3} = summary_var.SPN.ModxLocxOut;

summary_table{1,4} = 'HFN';
summary_table{2,4} = summary_var.HFN.Cue;
summary_table{3,4} = summary_var.HFN.Modality;
summary_table{4,4} = summary_var.HFN.Location;
summary_table{5,4} = summary_var.HFN.Outcome;
summary_table{6,4} = summary_var.HFN.Latency;
summary_table{7,4} = summary_var.HFN.Trial;
summary_table{8,4} = summary_var.HFN.Previous;
summary_table{9,4} = summary_var.HFN.ModxLoc;
summary_table{10,4} = summary_var.HFN.ModxOut;
summary_table{11,4} = summary_var.HFN.LocxOut;
summary_table{12,4} = summary_var.HFN.ModxLocxOut;

summary_table{1,5} = 'Exc';
summary_table{2,5} = summary_var.Inc.Cue;
summary_table{3,5} = summary_var.Inc.Modality;
summary_table{4,5} = summary_var.Inc.Location;
summary_table{5,5} = summary_var.Inc.Outcome;
summary_table{6,5} = summary_var.Inc.Latency;
summary_table{7,5} = summary_var.Inc.Trial;
summary_table{8,5} = summary_var.Inc.Previous;
summary_table{9,5} = summary_var.Inc.ModxLoc;
summary_table{10,5} = summary_var.Inc.ModxOut;
summary_table{11,5} = summary_var.Inc.LocxOut;
summary_table{12,5} = summary_var.Inc.ModxLocxOut;

summary_table{1,6} = 'Inh';
summary_table{2,6} = summary_var.Dec.Cue;
summary_table{3,6} = summary_var.Dec.Modality;
summary_table{4,6} = summary_var.Dec.Location;
summary_table{5,6} = summary_var.Dec.Outcome;
summary_table{6,6} = summary_var.Dec.Latency;
summary_table{7,6} = summary_var.Dec.Trial;
summary_table{8,6} = summary_var.Dec.Previous;
summary_table{9,6} = summary_var.Dec.ModxLoc;
summary_table{10,6} = summary_var.Dec.ModxOut;
summary_table{11,6} = summary_var.Dec.LocxOut;
summary_table{12,6} = summary_var.Dec.ModxLocxOut;

save(cat(2,'E:\Jimmie\Jimmie\Analysis\2018-03-12-GLM_',Epoch,'_',num2str(iTime),'-200bin25step.mat'),'mdl','ALL_matrix','block_drift','GLM_matrices','summary_var')
clearvars -except iEpoch iTime
    end
end

%% consistency check
consistency_check{1,1} = 'Category';
consistency_check{2,1} = 'Cue-evoked';
consistency_check{3,1} = 'Modality';
consistency_check{4,1} = 'Location';
consistency_check{5,1} = 'Outcome';
consistency_check{6,1} = 'Latency';
consistency_check{7,1} = 'Trial';
consistency_check{8,1} = 'Previous trial';
consistency_check{9,1} = 'Modality x Location';
consistency_check{10,1} = 'Modality x Outcome';
consistency_check{11,1} = 'Location x Outcome';
consistency_check{12,1} = 'Modality x Location x Outcome';

consistency_check{1,2} = 'mat_overview';
consistency_check{2,2} = summary_var.All.Cue;
consistency_check{3,2} = summary_var.All.Modality;
consistency_check{4,2} = summary_var.All.Location;
consistency_check{5,2} = summary_var.All.Outcome;
consistency_check{6,2} = summary_var.All.Latency;
consistency_check{7,2} = summary_var.All.Trial;
consistency_check{8,2} = summary_var.All.Previous;
consistency_check{9,2} = summary_var.All.ModxLoc;
consistency_check{10,2} = summary_var.All.ModxOut;
consistency_check{11,2} = summary_var.All.LocxOut;
consistency_check{12,2} = summary_var.All.ModxLocxOut;

consistency_check{1,3} = 'GLM_matrices.count.combined';
consistency_check{2,3} = [];
consistency_check{3,3} = sum(GLM_matrices.count.combined(:,1));
consistency_check{4,3} = sum(GLM_matrices.count.combined(:,2));
consistency_check{5,3} = sum(GLM_matrices.count.combined(:,3));
consistency_check{6,3} = sum(GLM_matrices.count.combined(:,4));
consistency_check{7,3} = sum(GLM_matrices.count.combined(:,5));
consistency_check{8,3} = sum(GLM_matrices.count.combined(:,6));
consistency_check{9,3} = sum(GLM_matrices.count.combined(:,7));
consistency_check{10,3} = sum(GLM_matrices.count.combined(:,8));
consistency_check{11,3} = sum(GLM_matrices.count.combined(:,9));
consistency_check{12,3} = sum(GLM_matrices.count.combined(:,10));

%%
GLM_matrices.count.combined_transposed = GLM_matrices.count.combined';

figure
imagesc(GLM_matrices.count.combined_transposed);
map = [229/255,245/255,249/255
    44/255,162/255,95/255];
colormap(map);
set(gca,'YTickLabel','')

%%

SPN_Dec_inverse = GLM_matrices.dev_percent.SPN_Dec * -1;
HFN_Dec_inverse = GLM_matrices.dev_percent.HFN_Dec * -1;
GLM_matrices.dev_percent.cat_combined = cat(1,GLM_matrices.dev_percent.SPN_Inc,SPN_Dec_inverse,GLM_matrices.dev_percent.HFN_Inc,HFN_Dec_inverse)';
% cell 84 acts weird (unusually high values)
map = [233/255,163/255,201/255
    247/255,247/255,247/255
    161/255,215/255,106/255];

rColorMap = [linspace(233/255, 255/255, 125),linspace(255/255, 161/255, 131)];
    gColorMap = [linspace(163/255, 255/255, 125),linspace(255/255, 215/255, 131)];
    bColorMap = [linspace(201/255, 255/255, 125),linspace(255/255, 106/255, 131)];
colorMap = [rColorMap; gColorMap; bColorMap]';

% figure
% heatmap(GLM_matrices.dev_percent.cat_combined, [], [], '%0.0f', 'Colormap',colorMap, ...
%         'FontSize', 0, 'Colorbar', true);

figure
heatmap(GLM_matrices.dev_percent.cat_combined, 'RowLabels', {'Cue modality','Cue location','Cue outcome'},... 
'%0.0f', 'Colormap',colorMap,'FontSize', 0, 'Colorbar', true);
xlabel('Unit number');
% xlabel('MSNs increasing                                            MSNs decreasing                        FSIs increasing   FSIs decreasing')
title('GLM matrix for cue-modulated units aligned to nosepoke');           
%% find average % of variance explained for each predictor
GLM_matrices.Rsquared.MEAN.ALL_NaN = GLM_matrices.Rsquared.ALL;
GLM_matrices.Rsquared.MEAN.ALL_NaN(GLM_matrices.Rsquared.MEAN.ALL_NaN == 0) = NaN;
GLM_matrices.Rsquared.MEAN.ALL_NaN(GLM_matrices.Rsquared.MEAN.ALL_NaN > 50) = NaN;
GLM_matrices.Rsquared.MEAN.ALL_NaN(GLM_matrices.Rsquared.MEAN.ALL_NaN < -50) = NaN;
GLM_matrices.Rsquared.MEAN.Modality = nanmean(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,1));
GLM_matrices.Rsquared.SEM.Modality = nanstd(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,1))/sqrt(numel(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,1))-sum(isnan(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,1))));
GLM_matrices.Rsquared.MEAN.Location = nanmean(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,2));
GLM_matrices.Rsquared.SEM.Location = nanstd(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,2))/sqrt(numel(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,2))-sum(isnan(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,2))));
GLM_matrices.Rsquared.MEAN.Outcome = nanmean(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,3));
GLM_matrices.Rsquared.SEM.Outcome = nanstd(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,3))/sqrt(numel(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,3))-sum(isnan(GLM_matrices.Rsquared.MEAN.ALL_NaN(:,3))));

GLM_matrices.Rsquared.MEAN.Summary = cat(2,GLM_matrices.Rsquared.MEAN.Modality,GLM_matrices.Rsquared.MEAN.Location,GLM_matrices.Rsquared.MEAN.Outcome);

GLM_matrices.Rsquared.SEM.Summary = cat(2,GLM_matrices.Rsquared.SEM.Modality,GLM_matrices.Rsquared.SEM.Location,GLM_matrices.Rsquared.SEM.Outcome);

%%
figure;
bar(GLM_matrices.Rsquared.MEAN.Summary)
hold on
errorbar(GLM_matrices.Rsquared.MEAN.Summary,GLM_matrices.Rsquared.SEM.Summary,'.') 
set(gca,'XTickLabel',{'Mod','Loc','Out'})
ylim([0 12]);
ylabel('Percent improvement to R-Squared')

%% violin plot
figure;
violin(GLM_matrices.Rsquared.MEAN.ALL_NaN);
set(gca,'XTickLabel',{'','Cue modality','','Cue location','','Cue outcome'})
% ylim([0 12]);
ylabel('Percent improvement to R-Squared')

%% plot for paper
%add row for HFN_inc
%add (6) spaces between SPN and HFNs
GLM_matrices.Rsquared.cat_combined = cat(1,abs(GLM_matrices.Rsquared.SPN_Inc),abs(GLM_matrices.Rsquared.SPN_Dec)*-1,abs(GLM_matrices.Rsquared.HFN_Inc),abs(GLM_matrices.Rsquared.HFN_Dec)*-1)';
for iCell = length(GLM_matrices.Rsquared.cat_combined):-1:1
    for iFeature = 1:length(GLM_matrices.Rsquared.cat_combined(:,iCell))
    if GLM_matrices.Rsquared.cat_combined(iFeature,iCell) > 100 || GLM_matrices.Rsquared.cat_combined(iFeature,iCell) < -100
        GLM_matrices.Rsquared.cat_combined(:,iCell) = [];
        break
    end
    end
end

%%
rColorMap = [linspace(233/255, 255/255, 123),linspace(255/255, 161/255, 133)];
    gColorMap = [linspace(163/255, 255/255, 123),linspace(255/255, 215/255, 133)];
    bColorMap = [linspace(201/255, 255/255, 123),linspace(255/255, 106/255, 133)];
colorMap = [rColorMap; gColorMap; bColorMap]';

figure
subplot(3,12,[2 3 4 5 6 14 15 16 17 18])
heatmap(GLM_matrices.Rsquared.cat_combined,  'RowLabels', {'Cue identity','Cue location','Cue outcome'},... 
'%0.0f', 'Colormap',colorMap, ...
        'FontSize', 0); %,'Colorbar', true);   
xlabel('Unit number');
title('GLM matrix for cue-modulated units aligned to nosepoke');  
set(gca,'FontSize',18);
hold on; plot(110,.75:.001:3.25,'.k');

subplot(3,12,[8 9 10 11 12 20 21 22 23 24])
violin(GLM_matrices.Rsquared.MEAN.ALL_NaN);
set(gca,'XTickLabel',{'','Cue modality','','Cue location','','Cue outcome'})
ylabel('Percent improvement to R-Squared')
title('Summary of changes to model fit')
set(gca,'FontSize',18);