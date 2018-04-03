function [EEG, varargout] = pop_iclabel(EEG)
%POP_ICLABEL Function for EEG IC labeling
%   Label independent components using ICLabel. Go to
%   labeling.ucsd.edu/tutorial/about for more information. This is a beta
%   version and results may change in the near future. For direct usage
%   of ICLabel, the function "iclabel" is suggested.

% run iclabel
EEG = iclabel(EEG);

% return for EEG.history
if nargout == 2
    varargout = {'EEG = pop_iclabel(EEG);'};
end