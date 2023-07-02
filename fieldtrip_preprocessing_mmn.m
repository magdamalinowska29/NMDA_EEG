%preprocessing and segmenting the data using field trip


%read the data
cfg = [];
cfg.dataset = 'subject1.bdf';
%cfg.continuous  = 'yes';  %force data to be read as continous
data_eeg    = ft_preprocessing(cfg);

%plot data form one channel
chansel = 1; %specify the channel
plot(data_eeg.time{1}, data_eeg.trial{1}(chansel, :))
xlabel('time (s)')
ylabel('channel amplitude (uV)')
legend(data_eeg.label(chansel))

%select channels 
cfg = [];
cfg.channel     = {'A*', 'B*', 'C*', 'D*', 'EXG1', 'EXG2', 'EXG3'};                      % keep channels 1 to 61 and the newly inserted M1 channel
data_eeg        = ft_preprocessing(cfg, data_eeg);

%rereferencing
cfg = [];
cfg.dataset     = 'subject1.bdf';
cfg.reref       = 'yes';
cfg.channel     = {'A*', 'B*', 'C*', 'D*'};
cfg.refmethod   = 'avg';
cfg.refchannel  = 'all';
data_eeg        = ft_preprocessing(cfg);

%EOG
cfg = [];
cfg.dataset    = 'subject1.bdf';
cfg.channel    = {'EXG1', 'EXG2'};
cfg.reref      = 'yes';
cfg.refchannel = 'EXG2';
data_eogh      = ft_preprocessing(cfg);

data_eogh.label{2} = 'HEOG';

cfg = [];
cfg.channel = 'HEOG';
data_eogh   = ft_preprocessing(cfg, data_eogh);

cfg = [];
cfg.dataset    = 'subject1.bdf';
cfg.channel    = {'EXG2', 'EXG3'};
cfg.reref      = 'yes';
cfg.refchannel = 'EXG3'
data_eogv      = ft_preprocessing(cfg);

data_eogv.label{2} = 'VEOG';

cfg = [];
cfg.channel = 'VEOG';
data_eogv   = ft_preprocessing(cfg, data_eogv);

 
cfg = [];
data_all = ft_appenddata(cfg, data_eeg, data_eogh, data_eogv);

elec_pos = ft_read_sens('sensors.pol'); %import sensors position froma file


%filtering, HP

cfg = [];
cfg.hpfilter = 'yes';
cfg.hpfreq = .1; % can't do 0.1 filter bc poles fall out of the unit circle (?), but can do for example 0.5
cfg.hpinstabilityfix = 'reduce';%,'split';%,  %this allows for using .1 filter, but why?
data_hp = ft_preprocessing(cfg, data_all);


%downsample 

cfg=[];
cfg.resamplefs = 200;
data_downsampled = ft_resampledata(cfg, data_hp);

%filtering, LP

cfg = [];
cfg.lpfilter = 'yes';
cfg.lpfreq = 30;
data_lp = ft_preprocessing(cfg, data_downsampled);


%epoch

%see what event types are in the file

cfg = [];
cfg.dataset             = 'subject1.bdf';
cfg.trialdef.eventtype = '?';
dummy                   = ft_definetrial(cfg);

% prepare to segment into epochs around standard trials
cfg                    = [];
cfg.trialdef.prestim   = -0.1;                   % in seconds
cfg.trialdef.poststim  = 0.4;                   % in seconds
cfg.trialdef.eventtype = 'STATUS'; 
cfg.trialdef.eventvalue =65152;
cfg.dataset            = 'subject1.bdf';             % set the name of the dataset
cfg_tr_standard             = ft_definetrial(cfg);   % read the list of the specific stimulus

%prepare to segment into epochs around rare trials

cfg.trialdef.eventtype = 'STATUS';
cfg.trialdef.eventvalue =65216;
cfg_tr_rare             = ft_definetrial(cfg);

% segment data according to the trial definition
data_trial_standard                   = ft_redefinetrial(cfg_tr_standard, data_lp);
data_trial_rare                       = ft_redefinetrial(cfg_tr_rare, data_lp);


%find artifacts- threshold


%ERROR: Index in position 2 exceeds array bounds. Index must not exceed 1.

%Error in ft_artifact_threshold (line 197)
%    dat = ft_fetch_data(data,        'header', hdr, 'begsample', cfg.trl(trlop,1), 'endsample', cfg.trl(trlop,2), 'chanindx', channelindx, 'checkboundary', strcmp(cfg.continuous, 'no'));
 



%cfg=[];
%cfg.dataset    = 'subject1.bdf';

%cfg.trl        = cfg_tr_standard;
%cfg.continuous = 'no';
%cfg.artfctdef.threshold.min       = 80;

%[cfg, artifact]= ft_artifact_threshold(cfg, data_trial_standard);

%averaging

cfg=[];
%cfg.channel            = 'C15';
cfg.keeptrials= 'no';
average_standard = ft_timelockanalysis(cfg, data_trial_standard);


%plot
%figure
%pol = -1;     % correct polarity
%h1 = plot(average_standard.time,average_standard.avg, 'color',[0,0,0.5]);

cfg=[];
%cfg.channel            = 'C15';
cfg.keeptrials= 'no';
average_rare = ft_timelockanalysis(cfg, data_trial_rare);








