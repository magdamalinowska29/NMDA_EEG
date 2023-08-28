% Initialize Script Parameters
spmPath = 'C:\Users\Marida\Documents\MATLAB\spm12';
data_path = 'C:\data\eegdata\aefdfMspmeeg_subject1';
spmmat_path = 'C:\data\eegdata\XYTstats';
input_mat_file = 'C:\data\eegdata\aefdfMspmeeg_subject1.mat';

% Add SPM12 to MATLAB's search path
addpath(spmPath);

% Set SPM Defaults for EEG
spm('Defaults', 'EEG');

% Initialize SPM Job Manager
spm_jobman('initcfg');

% Clear any existing matlabbatch variables
clear matlabbatch;

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
%% File Selection
% Use SPM's file selection utility to identify relevant NIFTI files
condition_standard = spm_select('FPList', data_path, '^condition_standard.*\.nii$');
condition_rare = spm_select('FPList', data_path, '^condition_rare.*\.nii$');

%% Sensor Space analysis
%% Batch Configuration
% Factorial Design Specification
matlabbatch{1}.spm.stats.factorial_design.dir = {spmmat_path};
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(condition_standard);
matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(condition_rare);
matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

% Model Estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(spmmat_path, 'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% Contrast Manager
matlabbatch{3}.spm.stats.con.spmmat = {fullfile(spmmat_path, 'SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 's_r';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%% Execute the Batch
spm_jobman('run', matlabbatch);
