1. Open a terminal window and type the following command after the system prompt (replacing $PATH with your local directory path to "TimeCellAnalysis"):
$ matlab -nodisplay -nosplash -sd "$PATH/rho-matlab/demos" -r "try synthesisDemo; quit"

For example:
$ matlab -nodisplay -nosplash -sd "/home/ananth/Documents/TimeCellAnalysis/rho-matlab/demos" -r "try synthesisDemo;  quit"

2. Navigate to the "TimeCellAnalysis" folder, and then to "rho-matlab/demos" to find the freshly synthesized dataset "synthData-demo.mat", along with support figures visualizing the various control parameter effects.

For example:
$ cd /home/ananth/Documents/TimeCellAnalysis/rho-matlab/demos
$ ls
