function [EEG, varargout] = pop_iclabel(EEG)
%POP_ICLABEL Function for EEG IC labeling
%   Label independent components using ICLabel. Go to 
%   https://sccn.ucsd.edu/wiki/ICLabel for a tutorial on this plug-in. Go to
%   labeling.ucsd.edu/tutorial/about for more information. This is a beta
%   version and results may change in the near future. For direct usage
%   of ICLabel, the function "iclabel" is suggested.
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

% run iclabel
EEG = iclabel(EEG);

% return for EEG.history
if nargout == 2
    varargout = {'EEG = pop_iclabel(EEG);'};
end