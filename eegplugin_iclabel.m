function vers = eegplugin_iclabel( fig, try_strings, catch_strings )
%EEGLABPLUGIN_ICLABEL EEGLAB plugin for EEG IC labeling
%   Label independent components using ICLabel. Go to 
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

vers = 'ICLabel0.3';
if nargin < 3
    error('eegplugin_iclabel requires 3 arguments');
end

plotmenu = findobj(fig, 'tag', 'tools');
uimenu( plotmenu, 'label', 'ICLabel', ...
    'callback', [try_strings.no_check ...
        '[EEG, LASTCOM] = pop_iclabel(EEG);' ...
        catch_strings.store_and_hist ...
        ' try, pop_viewprops(EEG, 0); catch, disp(''ICLabel: Install the viewprops eeglab plugin to see IC label visualizations.''), end']);
end

