# ICLabel
An automatic EEG independent component classifer plugin for EEGLAB.
For more information, see [the ICLabel website tutorial](https://labeling.ucsd.edu/tutorial/about).

## Installation
The easiest way to get the ICLabel plugin is through the EEGLAB plugin manager. 

If you plan to install the plugin through GitHub rather than the EEGLAB plugin manager, be aware that matconvnet is included as submodule. This means that it will no be included in the zip-file download. You will have to download [my fork (version) of matconvnet](https://github.com/lucapton/matconvnet) and extract that zip into the ICLabel folder. Alternatively, if you are cloning this repository through the command line, be sure to include the "--recusive" flag to clone submodules as well. Once you are in the desired directory, the correct command is:
~~~~
git clone --recursive https://github.com/lucapton/ICLabel.git
~~~~
