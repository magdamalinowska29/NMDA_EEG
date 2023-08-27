% The function sensor_space_fieldtrip performs sensor space analysis on EEG data using the FieldTrip toolbox. 
% It loads preprocessed EEG data for 'rare' and 'standard' conditions from a specified directory. 
% Then, it sets up a design matrix and performs statistical tests using an independent samples T-test with Bonferroni correction. 
% Finally, the function saves the statistical results and the design matrix back into the output directory.

function sensor_space_fieldtrip(output_dir)

% Load the data necessary for statistical analysis
load(fullfile(output_dir, 'data_trial_rare.mat'));
load(fullfile(output_dir, 'data_trial_standard.mat'));
% Prepare the design matrix
num_trials_rare = length(data_trial_rare.trial);
num_trials_standard = length(data_trial_standard.trial);
num_total_trials = num_trials_rare + num_trials_standard;

design = zeros(1, num_total_trials);
design(1:num_trials_rare) = 1;
design((num_trials_rare + 1):end) = 2;

% Configuration for statistical testing in FieldTrip
cfg = [];
cfg.method = 'analytic';  % Use the analytic method for a parametric t-test
cfg.statistic = 'ft_statfun_indepsamplesT'; % Independent samples T-statistic
cfg.correctm = 'bonferroni'; % Bonferroni correction for multiple comparisons
cfg.alpha = 0.05; % Significance level
cfg.design = design;
cfg.ivar = 1;   % The index of the design vector containing the independent variable

% Perform the statistical test
stat = ft_timelockstatistics(cfg, data_trial_rare, data_trial_standard);

% Save the statistical output and design matrix
save(fullfile(output_dir, 'stat_output.mat'), 'stat');
save(fullfile(output_dir, 'design_matrix.mat'), 'design');
end
