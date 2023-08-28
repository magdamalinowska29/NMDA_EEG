%this function runs the sensor space analysis

function [] = sensor_space_analysis(eeg_data, XYTStats);

%Please provide:

%eeg_data- the file containing the preprocessed EEG data
%XYTStats- the output directory for the statistical inference

spm('defaults', 'EEG');
spm_jobman('initcfg');

clear matlabbatch

%Converting EEG preprocessed data to images

matlabbatch{1}.spm.meeg.images.convert2images.D = {eeg_data};
matlabbatch{1}.spm.meeg.images.convert2images.mode = 'scalp x time';
matlabbatch{1}.spm.meeg.images.convert2images.conditions = {};
matlabbatch{1}.spm.meeg.images.convert2images.channels{1}.type = 'EEG';
matlabbatch{1}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
matlabbatch{1}.spm.meeg.images.convert2images.freqwin = [-Inf Inf];
matlabbatch{1}.spm.meeg.images.convert2images.prefix = '';

% Use SPM's file selection utility to identify relevant NIFTI files
condition_standard = spm_select('FPList', eeg_data, '^condition_standard.*\.nii$');
condition_rare = spm_select('FPList', eeg_data, '^condition_rare.*\.nii$');

%Setting up the factorial design specification

matlabbatch{2}.spm.stats.factorial_design.dir = {XYTStats};
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

%Setting up the model estimation
% Model Estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat = {fullfile(XYTStats, 'SPM.mat')};
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

% Contrast Manager
matlabbatch{3}.spm.stats.con.spmmat = {fullfile(XYTStats, 'SPM.mat')};
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 's_r';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

%% Execute the Batch
spm_jobman('run', matlabbatch);
