function vers = eegplugin_iclabel( fig, try_strings, catch_strings )
%EEGLABPLUGIN_ICLABEL EEGLAB plugin for EEG IC labeling
%   Label independent components using ICLabel. Go to
%   labeling.ucsd.edu/tutorial/about for more information. This is a beta
%   version and results may change in the near future.
vers = 'ICLabel0.1';
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

