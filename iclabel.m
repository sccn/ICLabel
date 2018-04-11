function EEG = iclabel(EEG)
%ICLABEL Function for EEG IC labeling
%   Label independent components using ICLabel.  Go to 
%   https://sccn.ucsd.edu/wiki/ICLabel for a tutorial on this plug-in. Go 
%   to labeling.ucsd.edu/tutorial/about for more information. This is a 
%   beta version and results may change in the near future.
%
%   Results are stored in EEG.etc.ic_classifications.ICLabel. The matrix of
%   label vectors is stored under "classifications" and the cell array of
%   class names are stored under "classes". The matrix stored under 
%   "classifications" is organized with each column matching to the 
%   equivalent element in "classes" and each row matching to the equivalent
%   IC. For example, if you want to see what percent ICLabel attributes IC
%   7 to the class "eye", you would look at:
%       EEG.etc.ic_classifications.ICLabel.classifications(7, 3)
%   since EEG.etc.ic_classifications.ICLabel.classes{3} is "eye"

% extract features
disp 'ICLabel: extracting features...'
features = ICL_feature_extractor(EEG, 15);

% run ICL
disp 'ICLabel: calculating labels...'
labels = run_ICL(features{:});

% save into EEG
disp 'ICLabel: saving results...'
EEG.etc.ic_classification.ICLabel.classes = ...
    {'Brain', 'Muscle', 'Eye', 'Heart', 'Line Noise', 'Channel Noise', 'Other'};
EEG.etc.ic_classification.ICLabel.classifications = labels;
