# rho-matlab
The code base is to use pre-existing physiology data from calcium imaging to generate synthetic data, and analyse for Time Cells using 6 methods (8 algorithms).

As a demo for the synthetic generation code, run "syntheticData_live.mlx" located in "../rho-matlab/CustomFunctions/syntheticData_live.mlx", which uses the configuration file (may be edited) "setupSyntheticDataParametersSingle.m", located in "../rho-matlab/localCopies/setupSyntheticDataParametersSingle.m". This demo uses the configuration parameters to generate synthetic data and profile the data with supplementary figures.

Before you begin:
All data used has been processed for cell masks and roi detection using Suite-2p (https://www.suite2p.org).
Any other cell detection system will also work, but with appropriate modifications.
Here, I have provided an example dataset with the repository - "M26_20180514.mat"

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

