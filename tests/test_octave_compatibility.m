function results = test_octave_compatibility(dataset_path, result_file, reference_file)
% Run with EEGLAB and ICLabel on the path, and Signal loaded in Octave.
% Example: test_octave_compatibility('/path/eeglab_data_epochs_ica.set', 'octave.mat')
% REFERENCE_FILE optionally supplies features saved by the MATLAB run.
% Concatenated epochs below exercise code paths, not physiological continuity.

EEG = pop_loadset(dataset_path);
EEG = eeg_checkset(EEG);
assert(EEG.trials > 1 && ~isempty(EEG.icawinv));
continuous = eeg_epoch2continuous(EEG);
continuous = eeg_checkset(continuous);
short = pop_select(continuous, 'time', [0 4]);
short = eeg_checkset(short);

datasets = {EEG, short, continuous};
names = {'epoched', 'continuous_short', 'continuous_welch'};
results.runtime = version;
results.is_octave = logical(exist('OCTAVE_VERSION', 'builtin'));
results.components = size(EEG.icawinv, 2);
results.cases = struct([]);
for k = 1:numel(datasets)
  started = tic;
  features = ICL_feature_extractor(datasets{k}, true);
  assert(all(cellfun(@isreal, features)), 'Network features must be real');
  assert(all(cellfun(@(x) all(isfinite(x(:))), features)));
  labels = run_ICL('default', features{:});
  validate_labels(labels, results.components);
  results.cases(k).name = names{k};
  results.cases(k).seconds = toc(started);
  results.cases(k).features = features;
  results.cases(k).labels = labels;
  fprintf('%s: PASS (%.3f seconds)\n', names{k}, results.cases(k).seconds);
end

% The graph loading change also affects the models without autocorrelation.
results.other_models = struct([]);
versions = {'lite', 'beta'};
for k = 1:2
  started = tic;
  classified = iclabel(EEG, versions{k});
  labels = classified.etc.ic_classification.ICLabel.classifications;
  validate_labels(labels, results.components);
  results.other_models(k).version = versions{k};
  results.other_models(k).seconds = toc(started);
  results.other_models(k).labels = labels;
  fprintf('%s: PASS (%.3f seconds)\n', versions{k}, results.other_models(k).seconds);
end

% Separate inference agreement from differences in feature extraction.
if nargin >= 3 && ~isempty(reference_file)
  reference = load(reference_file);
  results.same_input = struct([]);
  for k = 1:numel(reference.results.cases)
    labels = run_ICL('default', reference.results.cases(k).features{:});
    validate_labels(labels, results.components);
    difference = max(abs(double(labels(:)) - ...
      double(reference.results.cases(k).labels(:))));
    assert(difference < 1e-5, 'Inference disagrees with MATLAB on identical features');
    results.same_input(k).name = reference.results.cases(k).name;
    results.same_input(k).labels = labels;
    results.same_input(k).maximum_difference = difference;
  end
end
save(result_file, 'results', '-v7');
end

function validate_labels(labels, components)
assert(isequal(size(labels), [components 7]));
assert(isreal(labels) && all(isfinite(labels(:))));
assert(all(labels(:) >= 0 & labels(:) <= 1));
assert(max(abs(sum(labels, 2) - 1)) < 1e-5);
end
