%this is the main script for running the EEG analysis
%here we specify the paths to our data and tools and call for the steps in
%the analysis



% directories and variables
root_directory='C:/Data_negativity/BIDS_EEG'; %where your main data folder is stored
subjectID = 'sub-01';

fieldtrip_path='C:/spm12/external/fieldtrip';%can be different for everyone

%the results of preparation steps (not sure where those should be saved?)

channelselection= 'C:/Data_negativity/channelselection.mat';
addpath(channelselection);
reference='C:\Data_negativity\avref.mat';
sensors='C:\Data_negativity\sensors.pol';
trialdef='C:\Data_negativity\trialdef.mat';



%get the path to the file with eeg data (.bdf)
eeg_data=fullfile(root_directory,'raw',subjectID,'eeg','sub-01_task-rest_eeg.bdf');


%SPM PIPELINE

% create the directory for the result datasets

results_folder=fullfile(root_directory,'derivatives','spm', subjectID,'eeg');
results_file='sub-01_task-rest_eeg'; % how we want our output files to be named 


%spm script that runs preprocessing and calculates ERPs
%mmnbatch_preprocessing(eeg_data, channelselection,reference, sensors,trialdef, results_folder, results_file); 


%sensors space analysis

%creating an output directory for the statistical inference

output_dir_statinf=fullfile(root_directory, 'sensor_space_analysis','XYTStats');
mkdir(output_dir_statinf);

%running the analysis

sensor_space_analysis(results_folder,output_dir_statinf);

%FIELDTRIP PIPELINE




addpath(fieldtrip_path);

output_dir=fullfile(root_directory, 'derivatives','FieldTrip',subjectID,'eeg');
mkdir(output_dir);
%preprocessing and averaging

preprocessing_fieldtrip(eeg_data,sensors, output_dir);

%sensors space fieldtrip

sensor_space_fieldtrip(output_dir);





