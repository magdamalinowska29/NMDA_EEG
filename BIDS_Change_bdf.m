
eeglab;  % Start EEGLAB

%make sure you have the jsonlab master extension downloaded, unszipped and
%added to your matlab path to create json files 
% you can download it from GitHUb https://github.com/fangq/jsonlab as a zip
% folder
%cd /path/to/jsonlab-master  --> Navigate to the JSONlab folder
addpath(pwd); %  -->  Add the current folder to the MATLAB path
%savepath  -->  Save the updated MATLAB path


%set path from where you want to take the raw data (BioSemi in this case)
rawEEGFile = 'C:/Data_negativity/subject1.bdf';  % Input BioSemi EEG file
rootDir = 'C:/Data_negativity/BIDS_EEG';
subjectID = 'sub-01'; % put in subject ID according to that which is given in the Raw data 
rawDir=fullfile(rootDir,'raw'); %folder for raw data


eegDir = fullfile(rawDir, subjectID, 'eeg');
outputFile = fullfile(eegDir, 'sub-01_task-rest_eeg.bdf');  % Output BIDS format


% Create BIDS directories
mkdir(eegDir);

deriv_Dir=fullfile(rootDir, 'derivatives','spm',subjectID,'eeg');

mkdir(deriv_Dir); %make folder for results





%Convert raw eeg data into BIDS format using EEGLAB application 
% Read BioSemi EEG data and save in a different formatout
%EEG = pop_readbdf('C:/Data_negativity/subject1.bdf');  % Read BDF file (pop_biosig() seems to work on only some computers)
%pop_writeeeg(EEG, outputFile, 'TYPE', 'BDF');  % Save in EDF format



%addpath('C:/Data_negativity');
%cd('C:/Data_negativity')

fclose('all');
movefile(rawEEGFile, outputFile);


cd('C:\jsonlab-master');
%create file that contains meta datea about recordig (json file)
metadata = struct();
metadata.SamplingFrequency =  512;  % sampling rate of experiment, taken out of paper, in Hz
metadata.EEGReference = 'T9, T10';      % Example reference electrode
metadataPath = fullfile(eegDir, 'sub-01_eeg.json');
addpath(rootDir);
savejson('', metadata, fullfile(rootDir, subjectID,'sub-01_eeg.json')); %pathway where json file should be saved

% create csv file that contains information about events 
events = [1, 0, 1;  % Sample, Duration, EventID
          500, 0, 2;
          % ... other events
         ];

eventsFile = fullfile(eegDir, 'sub-01_task-rest_events.tsv'); %save csv file in new BIDS subject directory 
dlmwrite(eventsFile, events, 'delimiter', '\t');

% create the Channel description file 
channels = {'EEG001', 'EEG', 'A1';
            'EEG002', 'EEG', 'A2';
            'EEG003', 'EEG', 'A3';
            'EEG004', 'EEG', 'A4';
            'EEG005', 'EEG', 'A5';
            'EEG006', 'EEG', 'A6';
            'EEG007', 'EEG', 'A7';
            'EEG008', 'EEG', 'A8';
            'EEG009', 'EEG', 'A9';
            'EEG0010', 'EEG', 'A10';
            'EEG0011', 'EEG', 'A11';
            'EEG0012', 'EEG', 'A12';
            'EEG0013', 'EEG', 'A13';
            'EEG0014', 'EEG', 'A14';
            'EEG0015', 'EEG', 'A15';
            'EEG0016', 'EEG', 'A16';
            'EEG0017', 'EEG', 'A17';
            'EEG0018', 'EEG', 'A18';
            'EEG0019', 'EEG', 'A19';
            'EEG0020', 'EEG', 'A20';
            'EEG0021', 'EEG', 'A21';
            'EEG0022', 'EEG', 'A22';
            % ... other channels (in total 128 channels, 32xA, 32xB, 32xC,
            % 32xD
           };

channelsFile = fullfile(eegDir, 'sub-01_eeg_channels.tsv'); %save it in same directory as other files 
fid = fopen(channelsFile, 'w');
fprintf(fid, 'name\ttype\tlocation\n');
fprintf(fid, '%s\t%s\t%s\n', channels{:});
fclose(fid);

%create a README 
readmeText = 'Your README text here.';
readmeFile = fullfile(rootDir, 'README');
fid = fopen(readmeFile, 'w');
fprintf(fid, '%s', readmeText);
fclose(fid);

%create a json file containing a description of the data set 
datasetDesc = struct();
datasetDesc.Name = 'EEG Single Subject Mismatch Negativity dataset';
datasetDesc.Authors = {'M.I. Garrido' , 'J.M. Kilner', 'S.J. Kiebel', 'K.E. Stephan', 'K.J. Friston.'};
datasetDesc.Description = 'This is a 128-channel EEG single subject example data set, the analysis of which is described in the SPM Manual. This includes preprocessing, sensor space analysis, source reconstruction and Dynamic Causal Modelling.';
datasetDescPath = fullfile(rootDir, 'dataset_description.json');
savejson('', datasetDesc, datasetDescPath);




