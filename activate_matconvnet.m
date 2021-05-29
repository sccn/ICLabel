function pluginpath = activate_matconvnet()

% get path information
pluginpath = fileparts(which('pop_iclabel'));

% activate matconvnet
if ~exist(['vl_nnconv.', mexext()], 'file')
    addpath(fullfile(pluginpath, 'matconvnet', 'matlab'));
    vl_setupnn();
end
