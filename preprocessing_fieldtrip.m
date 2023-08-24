function results=preprocessing_fieldtrip(raw_data, sensors, output_dir)

ft_defaults


% Preprocessing and segmenting the data using FieldTrip



% Read the data
cfg = [];
cfg.dataset = raw_data;
data_eeg    = ft_preprocessing(cfg);

% Plot data from one channel
chansel = 1; % Specify the channel
plot(data_eeg.time{1}, data_eeg.trial{1}(chansel, :))
xlabel('time (s)')
ylabel('channel amplitude (uV)')
legend(data_eeg.label(chansel))

% Select channels 
cfg = [];
cfg.channel     = {'A*', 'B*', 'C*', 'D*', 'EXG1', 'EXG2', 'EXG3'};                      
data_eeg        = ft_preprocessing(cfg, data_eeg);

% Rereferencing
cfg = [];
cfg.dataset     = raw_data;
cfg.reref       = 'yes';
cfg.channel     = {'A*', 'B*', 'C*', 'D*'};
cfg.refmethod   = 'avg';
cfg.refchannel  = 'all';
data_eeg        = ft_preprocessing(cfg);

% Process HEOG
cfg = [];
cfg.dataset    = raw_data;
cfg.channel    = {'EXG1', 'EXG2'};
cfg.reref      = 'yes';
cfg.refchannel = 'EXG2';
data_eogh      = ft_preprocessing(cfg);
data_eogh.label{2} = 'HEOG';
cfg = [];
cfg.channel = 'HEOG';
data_eogh   = ft_preprocessing(cfg, data_eogh);

% Process VEOG
cfg = [];
cfg.dataset    = raw_data;
cfg.channel    = {'EXG2', 'EXG3'};
cfg.reref      = 'yes';
cfg.refchannel = 'EXG3';
data_eogv      = ft_preprocessing(cfg);
data_eogv.label{2} = 'VEOG';
cfg = [];
cfg.channel = 'VEOG';
data_eogv   = ft_preprocessing(cfg, data_eogv);

% Append all data
cfg = [];
data_all = ft_appenddata(cfg, data_eeg, data_eogh, data_eogv);

save(fullfile(output_dir,'data_all'), "data_all")

% Import sensors position from file
elec_pos = ft_read_sens(sensors);


% High-pass filter
cfg = [];
cfg.hpfilter = 'yes';
cfg.hpfreq = .1;
cfg.hpinstabilityfix = 'reduce';
data_hp = ft_preprocessing(cfg, data_all);

% Downsample 
cfg=[];
cfg.resamplefs = 200;
data_downsampled = ft_resampledata(cfg, data_hp);

% Low-pass filter
cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 30;
data_lp = ft_preprocessing(cfg, data_downsampled);

save(fullfile(output_dir,'data_lp'),"data_lp");

% Epoching
cfg = [];
cfg.dataset             = raw_data;
cfg.trialdef.eventtype = '?';
dummy                   = ft_definetrial(cfg);

% Prepare to segment into epochs around standard trials
cfg                    = [];
cfg.trialdef.prestim   = -0.1;                  
cfg.trialdef.poststim  = 0.4;                  
cfg.trialdef.eventtype = 'STATUS'; 
cfg.trialdef.eventvalue = 65152;
cfg.dataset            = raw_data;            
cfg_tr_standard        = ft_definetrial(cfg);

% Prepare to segment into epochs around rare trials
cfg.trialdef.eventvalue = 65216;
cfg_tr_rare             = ft_definetrial(cfg);

% Segment data according to the trial definition
data_trial_standard    = ft_redefinetrial(cfg_tr_standard, data_lp);
data_trial_rare        = ft_redefinetrial(cfg_tr_rare, data_lp);

save(fullfile(output_dir,'data_trial_rare'), "data_trial_rare");
save(fullfile(output_dir,'data_trial_standard'), "data_trial_standard");

%find artifacts- threshold

cfg = [];
cfg.artfctdef.threshold.min = 80;
cfg.artfctdef.threshold.max = 100;  
cfg.channel = 'all';  % Select channels for artifact rejection
cfg.method = 'threshold';
data_clean = ft_rejectartifact(cfg, data_trial_standard);

save(output_dir, "data_clean");
% Averaging
cfg=[];
cfg.keeptrials = 'no';
average_standard = ft_timelockanalysis(cfg, data_trial_standard);

save(fullfile(output_dir,'average_standard'), "average_standard");

% Plot
figure
pol = -1;
h1 = plot(average_standard.time, average_standard.avg, 'color', [0,0,0.5]);

cfg=[];
cfg.keeptrials= 'no';
average_rare = ft_timelockanalysis(cfg, data_trial_rare);

save(fullfile(output_dir,'average_rare'), "average_rare");


