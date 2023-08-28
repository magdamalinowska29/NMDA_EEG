% Initialize SPM Job Manager
spm_jobman('initcfg');

% Clear any existing matlabbatch variables to avoid conflicts
clear matlabbatch;

input_mat_file = 'C:\data\eegdata\aefdfMspmeeg_subject1.mat';

% Configure the 'Convert to Images' job parameters
matlabbatch{1}.spm.meeg.images.convert2images.D = {input_mat_file};
matlabbatch{1}.spm.meeg.images.convert2images.mode = 'scalp x time';
matlabbatch{1}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';

% Define the paths to the 4D NIFTI files and convert them to 3D
standard_nii_path = 'C:\data\eegdata\aefdfMspmeeg_subject1\condition_standard.nii,1';
rare_nii_path = 'C:\data\eegdata\aefdfMspmeeg_subject1\condition_rare.nii,1';

% Convert the standard condition 4D NIFTI to 3D
matlabbatch{2}.spm.util.split.vol = {standard_nii_path};
matlabbatch{2}.spm.util.split.outdir = {''}; % Output to the same directory

% Convert the rare condition 4D NIFTI to 3D
matlabbatch{3}.spm.util.split.vol = {rare_nii_path};
matlabbatch{3}.spm.util.split.outdir = {''}; % Output to the same directory

% Execute the batch job
spm_jobman('run', matlabbatch);
