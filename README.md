# rho-matlab
The code base is to use pre-existing physiology data from calcium imaging to generate synthetic data, and analyse for Time Cells using various analysis algorithms. The analysis algorithms have since been updated to much faster and better performing Python/C++ implementations (see https://github.com/BhallaLab/TimeCellAnalysis). Here, we look at how to synthesize dF/F datasets (as cells, trials, frames).

SYNTHESIS DEMO OPTION 1 (Terminal call)
As a demo one can call the "synthesisDemo.m" script located in "../rho-matlab/demos/", which uses the configuration file (may be edited) "setupSynthDataParams4Demo.m" (same directory). The idea here is to have the most straightforward code run possible, for first time users.

1. Open a terminal window and navigate to the your local directory where the "TimeCellAnalysis" repository was cloned, and step into "rho-matlab/demos".
For example:
$ cd /home/ananth/Documents/TimeCellAnalysis/rho-matlab/demos

2. Run the following command:
$ matlab -nodisplay -nosplash -r "synthesisDemo; quit"

The freshly synthesized dataset "synthData-demo.mat" along with support figures visualizing the various control parameter effects will be generated in the same directory, once the code run finishes.

SYNTHESIS DEMO OPTION 2 (Live Script)
As a demo for the synthetic generation code, run "syntheticData_live.mlx" located as "../rho-matlab/demos/syntheticData_live.mlx", which uses the configuration file (may be edited) "setupSyntheticDataParametersSingle.m", located as "../rho-matlab/localCopies/setupSyntheticDataParametersSingle.m". This demo uses the configuration parameters to generate synthetic data and profile the data with supplementary figures. The idea here is to also get the user familiar with the typical locations for different files used during the run, for users familiar with MATLAB wishing to understand how the synthesis algorithm script works.

USING THE FULL SYNTHESIS AND ANALYSIS REPOSITORY (RHO-MATLAB)

NOTE: The analysis algorithms implemented in MATLAB (found here), have since been updated to faster and better performing Python/C++ implementations (see https://github.com/BhallaLab/TimeCellAnalysis).

Before you begin:
All data used has been processed for cell masks and roi detection using Suite-2p (https://www.suite2p.org).
Any other cell detection system will also work, but with appropriate modifications.
Here, I have provided an example dataset with the repository - "M26_20180514.mat", located in "../rho-matlab/demos/"

--> Create a directory according to:
HOME_DIR/Work/Analysis/Imaging/MouseName/RecordingDate/

e.g. - /home/bhalla/ananthamurthy/Work/Analysis/Imaging/M26/20180514/

--> Copy M26_20180514.mat into the aforementioned directory. Now, the physiology dataset is in place, the code base can be run.


ESSENTIAL STEPS:

1. The first step is to get a reasonable recording of a decent number of cells. I'd recommend N to be at least 100 but any number is fine.

2. Use Suite2P to detect cells as ROIs.

    // If you don't wish to process the automatic roi estimates, you don't have to. All that will happen is that you will have to modify the load path in the next step.

3. Suite2P does not give us dF/F. It gives us raw flourescence estimated for all the detected ROIs. We need to develop the dF/F curves. Use my function "dodFbyF.m". This will generate two important matrices:

        a) dfbf (3D matrix as cells, trials, frames), and

        b) dfbf_2D (same thing as cells, trials*frames).

    // These two are all we need. Any of the above steps may be accordingly bypassed, if necessary.

    // I had used my script "timeCellAnalysis.m" that uses "dodFbyF.m" among other steps. However, none of the other steps are actually crucial for the synthetic data generation and the analyses that follow.

    // In case you are bypassing the other steps, just save dfbf and dfbf_2D as a MATLAB structure in one file, and use this file for the next step.

4. Use "generateSyntheticData.m" to generate synthetic data configured in "setupSyntheticDataParams.m"

     // Depending on the experiment I had 3 different config files in "configSynth.m":

        a) setupSyntheticDataParams %Loads all options for Physiology (N=360)
      
        b) setupSyntheticDataParams2 %Loads all options for PSA (N=297)
      
        c) setupSyntheticDataParams3 %Loads all options for Physiology and PSA (N=417)

      // Use your choice or make a new config file, as required.

      // Library Curation or Load is already built into "generateSyntheticData.m".

5. Once step 4 is complete, just make sure the correct/same experiment config file is considered when running "runBatchAnalysis.m". This function requires

        a) a generation Date or "gDate" which is the date the user decided to make synthetic data,

        b) "gRun" (typically 1), which is the run number (useful if multiple synthetic data generation runs were launched on the same day, and

        c) "nDatasets", which is dependent on the config file (see step 4).

      // One can run batch analysis with all the methods or one method at a time. I like to do one method at a time (this means consolidation is required).

      // With a "gDate", "gRun" and an "nDatasets" as part of the name, there is enough information to find the right batch, in case of any doubt.

6. After this consolidate all the various outputs (all datasets, all methods) using "consolidateBatch.m". Make sure to configure "setupHarvestParams.m" based on how "runBatchAnalysis.m" was run. There are 4 such config files based on the experiment being conducted (see step 4). This consolidation requires

        a) a consolidation Date or "cDate" which is the date the user decided to consolidate the outputs, and,

        b) "cRun" (typically 1), which is the run number (useful if multiple consolidations were launched on the same day).

