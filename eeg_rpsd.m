function psdmed = eeg_rpsd(EEG, nfreqs, pct_data)


% Validate EEG input
if ~isstruct(EEG) || ~isfield(EEG, 'icaweights') || ~isfield(EEG, 'icaact') || ...
   ~isfield(EEG, 'srate') || ~isfield(EEG, 'pnts') || ~isfield(EEG, 'trials')
    error('EEG must be a struct with fields: icaweights, icaact, srate, pnts, trials');
end

% clean input cutoff freq
nyquist = floor(EEG.srate / 2);
if ~exist('nfreqs', 'var') || isempty(nfreqs)
    nfreqs = nyquist;
elseif ~isnumeric(nfreqs) || nfreqs <= 0 || floor(nfreqs) ~= nfreqs
    error('nfreqs must be a positive integer');
    
elseif nfreqs > nyquist
    nfreqs = nyquist;
end
if ~exist('pct_data', 'var') || isempty(pct_data)
    pct_data = 100;
elseif ~isnumeric(pct_data) || pct_data <= 0 || pct_data > 100
    error('pct_data must be a number between 0 and 100');
end

% setup constants
ncomp = size(EEG.icaweights, 1);
n_points = floor(min(EEG.pnts, EEG.srate));
try
    window = windows('hamming', double(n_points), 0.54)';
catch
    lasterr
    error('The windows function is in the firfilt plugin, make sure it is in the path')
end
cutoff = floor(EEG.pnts / n_points) * n_points;
index = bsxfun(@plus, ceil(0:n_points / 2:cutoff - n_points), (1:n_points)');
if ~exist('OCTAVE_VERSION', 'builtin')
    rng('shuffle')
else
    rand('seed', sum(100 * clock));
end
n_seg = size(index, 2) * EEG.trials;
subset = randperm(n_seg, ceil(n_seg * pct_data / 100)); % need to improve this


% calculate windowed spectrums
psdmed = zeros(ncomp, nfreqs);
for it = 1:ncomp
    temp = reshape(EEG.icaact(it, index, :), [1 size(index) .* [1 EEG.trials]]);
    temp = bsxfun(@times, temp(:, :, subset), window);
    temp = fft(temp, n_points, 2);
    temp = temp .* conj(temp);
    temp = temp(:, 2:nfreqs + 1, :) * 2 / (EEG.srate*sum(window.^2));
    if nfreqs == nyquist
        temp(:, end, :) = temp(:, end, :) / 2; end

    psdmed(it, :) = 20 * log10(median(temp, 3));
end
end
