# rho-matlab
The code base uses pre-existing physiology data from calcium imaging to generate ground-truth labelled, categorically defined synthetic data, and analyse for Time Cells using various implemented analysis algorithms. The idea is to identify the best use cases for each of the analysis algorithms.
The synthetic datasets are a resource in themselves, and can be generated quickly. Large batch sizes can be preconfigured and saved limited only by system RAM.

The analysis algorithms have since been updated to much faster and better performing [Python/C++ implementations](https://github.com/BhallaLab/TimeCellAnalysis). Here, we look at how to synthesize dF/F datasets (as cells, trials, frames). The last section will look at legacy MATLAB based implementations for Time Cell Analysis.

[Ananthamurthy & Bhalla, 2023. "Synthetic Data Resource and Benchmarks for Time Cell Analysis and Detection Algorithms". _eNeuro_ DOI: https://doi.org/10.1523/ENEURO.0007-22.2023](https://doi.org/10.1523/ENEURO.0007-22.2023).

The signal considered for each of the cells is calcium activity, though the synthesis algorithm should work with any time-varying signal profile.

<br>

### Software Compatibility
The code base has been tested and verified (Mac or Linux) for
- MATLAB 2017
- MATLAB 2020
- MATLAB 2021
- MATLAB 2022

<br>

### Hardware Compatibility
The synthesis of the main benchmarking datasets (N = 567 datasets or 76545 total cells; setupSyntheticDataParams9) required a powerful analysis machine, running a 
- 6 core AMD Ryzen 5 3600, with
- 32 GB of DDR4 RAM
- Software: MATLAB R2021a | OS: Ubuntu 20.04.

*Benchmarks - Analysis Machine (Server ID: 2)*
- Memory usage: ~30 MB/dataset
- Run Time: ~1 sec/dataset

Dataset batches up to ~30 datasets (N = 40500 cells @ 135 cells/dataset) can be easily handled by a less powerful laptop.

We also ran the memory usage and runtime experiments on a gaming laptop (Lenovo Ideapad 3 Gaming) with a
- 6 core AMD Ryzen 5 4600H, and
- 16 GB DDR4 RAM (3200 MHz)
- Software: MATLAB R2021a | OS: Ubuntu 20.04.

Note, however, that we have implemented all the time-cell algorithms in serial and these do not use the additional cores.

*Benchmarks (cont.) - Laptop (Server ID: 0)*
- Memory usage: ~15 MB/dataset
- Run Time: ~1-4 sec/dataset (135 cells/dataset).

> NOTE: @ 67 cells/dataset, the memory requirement and runtimes are approximately halved ([_BioRxiv version_](https://www.biorxiv.org/content/10.1101/2022.01.01.474717v2)), suggesting that computational costs in memory and time were roughly linear with dataset size. The analysis algorithms work independently for each cell. Thus in principle the analysis could be run in an embarrassingly parallel manner and should scale well on multi-core architectures.

<br>

## **Demos**

Open a terminal window, navigate to the your local directory where the "TimeCellAnalysis" repository was cloned, and step into "rho-matlab/demos".

`$ cd ~/path/to/repository/TimeCellAnalysis/rho-matlab/demos`

For example:

`$ cd /home/ananth/Documents/TimeCellAnalysis/rho-matlab/demos`

## > Synthesis Demo Option 1 (Terminal call)
As a demo one can call the "synthesisDemo.m" script located in "../rho-matlab/demos/", which uses the configuration file (may be edited) "setupSynthDataParams4Demo.m" (same directory). The idea here is to have the most straightforward code run possible, for first time users.

Next, run the following command in Terminal:

`$ matlab -nodisplay -nosplash -r "synthesisDemo; quit"`

The freshly synthesized dataset "synthData-demo.mat" along with support figures visualizing the various control parameter effects will be generated in the same directory, once the code run finishes.

## > Synthesis Demo Option 2 (Live Script)
As a demo for the synthetic generation code, run "syntheticData_live.mlx" located as "../rho-matlab/demos/syntheticData_live.mlx", which uses the configuration file (may be edited) "setupSyntheticDataParametersSingle.m", located as "../rho-matlab/localCopies/setupSyntheticDataParametersSingle.m". This demo uses the configuration parameters to generate synthetic data and profile the data with supplementary figures. The idea here is to also get the user familiar with the typical locations for different files used during the run, for users familiar with MATLAB wishing to understand how the synthesis algorithm script works.

## **Using the full synthesis and analysis repository (rho-matlab) - in Steps**
1. Generate Synthetic Data Batch (ground-truth labelled)
2. Analyze for Time Cells using different algorithms
3. Comparative Analysis and paper figures.

NOTE: The analysis algorithms implemented in MATLAB (found here), have since been updated to faster and better performing [Python/C++ implementations](https://github.com/BhallaLab/TimeCellAnalysis).

## 1) Synthesis
The first step is the get a good quality recording ([_BioRxiv version_](https://www.biorxiv.org/content/10.1101/2022.01.01.474717v2)) or generate realistic time series waveforms. Next, these waveforms (real or synthesized) will be carefuly curated and used to create synthetic cells and datasets, as cells, trials and frames, by rearranging events based on pre-configured parameters (see below). A batch of such test standard datsets is then used to compare the various analysis algorithms.

For Figure 1 in the paper ([_BioRxiv version_](https://www.biorxiv.org/content/10.1101/2022.01.01.474717v2)) we generate the following example datasets (see "generateSyntheticDataExample.m"):
<br>
**Paper Figure 1: Example Synthetic Datasets**<br>

![Figure 1: Example synthetic datasets](https://github.com/ananthamurthy/rho-matlab/blob/master/1-Examples.png)

### **Table of Important Synthesis-related Scripts**
[Original lab note on this.](https://labnotes.ncbs.res.in/bhalla/key-table-important-function-and-configuration-scripts-rho-matlab)

|**Name**|**Description**|**File Location**|
|---|--------------------------|-------------------------|
|make_db_real2synth.m |Reference (real physiology) dataset load options. <br>Once run, the workspace is populated by a MATLAB structure "db", which contains the lookup for any and all reference datasets.|rho-matlab/localCopies|
|configSynth.m|Wrapper script for synthesis configuration options.<br>Several template options can be configured within this, and invoked or waived using comment or uncomment, respectively.|rho-matlab/localCopies|
|setupSyntheticDataParamsX.m|Example template options.<br>Here X = 1, 2, 3, ..., 9.(e.g.-  setupSyntheticDataParams9.m, which was used for the paper).<br>May be called directly or via a wrapper function.<br>Each synthetic dataset in a batch is indexed and configured.<br>Once run, the workspace is populated with a MATLAB structure "sdcp", which will contain a lookup for all parameters, indexed as datasets in a batch.|rho-matlab/localCopies|
|curateLibrary.m|Main event library curating function.<br>INPUT: DATA_2D ... [2D matrix of real physiology data].<br>OUTPUT: eventLibrary_2D.<br>Needs to run on each new reference physiology dataset.|rho-matlab/CustomFunctions|
|syntheticDataMaker.m|Main synthesis function.<br>INPUT:<br>1. db    ... [see make_db_real2synth]<br>2. DATA_2D    ... [2D matrix of real physiology data]<br>3. eventLibrary_2D    ... [Structure; stores indexed information for all cellwise calcium events detected in DATA_2D]<br>4. sdcp(runi)    ... [see configSynth or setupSyntheticDataParams9. Here i is the dataset index in a configured batch of synthetic datasets]<br>OUTPUT:<br> sdo    ... [Freshly generated synthetic dataset. Typically collated in a for loop as a structure sdo_batch]<br>|rho-matlab/CustomFunctions|
|generateSyntheticData.m |Wrapper function for synthesis.<br>INPUT:<br>1. gDate    ... [date in yyyymmdd for generation]<br>2. gRun    ... [code run number]<br>3. workingOnServer    ... [number to specify analysis machine dependent relative paths for file load/save]<br>4. diaryOn    ... [boolean switch to invoke MATLAB's diary feature for code run]<br>5. profilerTest    ... [boolean switch to invoke MATLAB's profiler for code run]<br>OUTPUT:<br>1. memoryUsage    ... [structure; stores size and type information for all variables in workspace. Usually an output of MATLAB's "whos()" function]<br>2. totalMem    ... [sum of all memory size values for all variables in memoryUsage]<br>3. sdo_batch    ... [structure; stores all the synthetic datasets in a batch with indices and meta-data]<br>4. elapsedTime    ... [total time taken for synthesis of full batch]|rho-matlab/src|
|synthesisDemo.m|Wrapper script with pre-configured options to showcase the synthesis algorithm, generating one example dataset. See "Synthesis Demo Option 1".<br>This function calls syntheticDataMaker() and uses the configuration options specified in setupSynthDataParams4Demo.m|rho-matlab/demos|
|syntheticData_live.mlx|MATLAB Live Script to showcase the synthesis algorithm, generating one example dataset, in a Jupyter Notebook style interface. See "Synthesis Demo Option 2".<br>This function calls syntheticDataMaker() and uses the configuration options specified in setupSynthDataParams4Demo.m|rho-matlab/demos|
|setupSynthDataParams4Demo.m|Configuration options used by synthesisDemo.m or syntheticData_live.mlx|rho-matlab/demos|
|generateSyntheticDataExample.m|Script to generate example schematics for Figure 1|rho-matlab/src|

**Paper Figure 1-1: All modulations**<br>

For the paper, here is the full list of modulations tested (see setupSyntheticDataParams9.m):
![Paper Figure 1-1 (Sup.)](https://github.com/ananthamurthy/rho-matlab/blob/master/Figure%201-1.png)
<br>

## 2) Independent Algorithm-wise Analysis (using Python/C++)
Once the batch of synthetic data is configured, generated, and saved (see generateSyntheticData.m), the batch is analyzed using the [Python/C++ implementations](https://github.com/BhallaLab/TimeCellAnalysis), instead of the legacy MATLAB implementations. This results in the analysis output as .csv files for each of the main algorithm blocks: _r2b_, _ti_, and _peq_. These .csv files are then easily parsed and used for subsequent analysis and paper figure generation.

**Paper Figure 3: Python/C++ based Algorithms**<br>

![Figure 3: Python/C++ based implementations](https://github.com/ananthamurthy/rho-matlab/blob/master/algoSchematic-Resub-min.png)

<br>
<br>

## 3) Subsequent Comparative Analysis and Paper Figures
### **Table of Important Paper Figure Scripts**
[Original lab note on this.](https://labnotes.ncbs.res.in/bhalla/key-table-important-function-and-configuration-scripts-rho-matlab)

|**Name**|**Description**|**File Location**|
|---|--------------------------|-------------------------|
|paperFiguresSplits.m|For diagnostics.<br>Plots all figures estimating algorithm performance over all the regimes (Unphysiological, Canonical, and Physiological).|rho-matlab/src|
|paperFiguresSynth.m|Plots all figures estimating algorithm performance for Synthetic Data analysis (Paper Fig. 4, Fig. 5, Fig. 6, and Fig. 8).|rho-matlab/paperFigures|
|paperFiguresReal.m|Plots all figures estimating algorithm performance for Real Physiology Data analysis (Paper Fig. 7).|rho-matlab/paperFigures|

**Figure 4: Scores (Synthetic Data)**<br>

![Figure 4](https://github.com/ananthamurthy/rho-matlab/blob/master/4-SynthScores.png)

**Figure 5: Predictions (Synthetic Data)**<br>

![Figure 5](https://github.com/ananthamurthy/rho-matlab/blob/master/5-SynthPredictions.png)

**Figure 6: Physiological Regime (Synthetic Data)**<br>

![Figure 6](https://github.com/ananthamurthy/rho-matlab/blob/master/6-SynthPhysiology.png)

**Supplementary to Figure 6: Mean + SEM**<br>

![Figure 6-1](https://github.com/ananthamurthy/rho-matlab/blob/master/Figure%206-1.png)

**Supplementary to Figure 6: Linear Fits**<br>

![Figure 6-2](https://github.com/ananthamurthy/rho-matlab/blob/master/Figure%206-2.png)

**Figure 7: Real/Recorded Physiology**<br>
![Figure 7](https://github.com/ananthamurthy/rho-matlab/blob/master/7-RealPhysiology.png)

**Figure 8: Spider Plot Summary**<br>
![Figure 8](https://github.com/ananthamurthy/rho-matlab/blob/master/8-Summary-cropped.png)
<br>

## [Legacy] Analysis (using MATLAB implementations)
**Legacy: Paper Figure 3 - MATLAB based algorithm implementations**<br>

![Legacy | Figure 3 - MATLAB based implementations](https://github.com/ananthamurthy/rho-matlab/blob/master/algoSchematic-1stSub.png)

### **Table of Legacy Analysis-related Scripts**
[Original lab note on this.](https://labnotes.ncbs.res.in/bhalla/key-table-important-function-and-configuration-scripts-rho-matlab)

|**Name**|**Description**|**File Location**|
|---|--------------------------|-------------------------|
|runMehrabR2BAnalysis2.m|Function that runs the Ridge-to-Background Analysis on a dataset based on Modi et al., 2014.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mAInput    ... [structure; stores configuration parameters of analysis]<br>3. trialDetails   ... [structure; stores meta-data concerning behaviour and/or imaging trials]<br>OUTPUT:<br>1. mAOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..]|rho-matlab/CustomFunctions|
|runWilliamTIAnalysis.m|Wrapper function that runs the Temporal Information Analysis on a dataset based on Mau et al., 2018.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mBInput    ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. mBOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..].<br>This function calls William Mau's tempInfoOneNeuron() function, received with acknowledgement|rho-matlab/CustomFunctions|
|tempInfoOneNeuron.m|William Mau's temporal information calculation function, received with acknowledgement.<br>To be run over all cells in a dataset.<br>INPUT:<br>1. rastor ... [Activity raster]<br>OUTPUT:<br>1. MI    ... [Mutual Information]<br>2. Isec    ... [bits/sec]<br>3. Ispk    ... [bits/spike]<br>4. Itime    .. [peak time bin]|rho-matlab/CustomFunctions|
|runSimpleTCAnalysis.m|Wrapper Function to run Simple Time Cell Analysis based on Tuning Curves (Event Time Histograms).<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mCInput    ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. mCOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..]<br>This function calls simpleAnalysisFast()|rho-matlab/CustomFunctions|
|simpleAnalysisFast.m|Function that runs the Simple Time Cell Analysis on a dataset.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. simpleInput  aka mCInput  ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. peakTimeBin    ... [peak time bin for each cell]<br>2. Q   ... [Quality score for each cell]|rho-matlab/CustomFunctions|
|runSeqBasedTCAnalysis.m|Wrapper function to run the Offset PCA analysis on a dataset, based on Villette et al., 2015.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. seqAnalysisInput  aka mDInput ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. seqAnalysisOutput aka mDOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..]|rho-matlab/CustomFunctions|
|runSVMClassification.m|Wrapper function to run the Support Vector Machine based analysis on a dataset.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mEInput ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. mEOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..]|rho-matlab/CustomFunctions|
|runDerivedQAnalysis.m|Wrapper function to run the Parametric Equation based analysis on a dataset.<br>INPUT:<br>1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mFInput ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. mFOutput   ... [structure; stores all output for analysis including quality values, classification results, etc..].<br>This function calls derivedQAnalysisFast()|rho-matlab/CustomFunctions|
|derivedQAnalysisFast.m|Function that runs the Simple Time Cell Analysis on a dataset.<br>INPUT:1. DATA   ... [dataset to be analyzed as a 3D matrix - cells, trials, frames]<br>2. mFInput  ... [structure; stores configuration parameters of analysis]<br>OUTPUT:<br>1. peakTimeBin    ... [peak time bin for each cell]<br>2. Q   ... [Quality score for each cell]|rho-matlab/CustomFunctions|
|runBatchAnalysisOnSyntheticData.m|Wrapper function to run MATLAB based time cell analysis algorithms on Synthetic Dataset batches.<br>INPUT:<br>1. starti    ... [dataset start index]<br>2. endi   ... [dataset end index]<br>3. runA   ... [boolean switch to run Method A (Ridge-to-Background based on Modi et al., 2014)]<br>4. runB   ... [boolean switch to run Method B (Temporal Information based on Mau et al., 2018)]<br>3. runC   ... [boolean switch to run Method C (Simple Tuning Curve method)]<br>4. runD   ... [boolean switch to run Method D (Offset Principal Component Analysis based on Villette et al., 2015)]<br>5. runE   ... [boolean switch to run Method E (Support Vector Machine]<br>6. runF   ... [boolean switch to run Method F (Parametric Equations)]<br>OUTPUT:<br>1. memoryUsage    ... [structure; stores size and type information for all variables in workspace. Usually an output of MATLAB's "whos()" function]<br>2. totalMem   ... [sum of all memory size values for all variables in memoryUsage]<br>3. elapsedTime ... [total time for script run, based on boolean switch profile for methods]|rho-matlab/src|
|runBatchAnalysisOnRealData.m|Wrapper function to run MATLAB based time cell analysis algorithms on Real Dataset batches.<br>INPUT:<br>1. starti    ... [dataset start index]<br>2. endi   ... [dataset end index]<br>3. runA   ... [boolean switch to run Method A (Ridge-to-Background based on Modi et al., 2014)]<br>4. runB   ... [boolean switch to run Method B (Temporal Information based on Mau et al., 2018)]<br>3. runC   ... [boolean switch to run Method C (Simple Tuning Curve method)]<br>4. runD   ... [boolean switch to run Method D (Offset Principal Compo|rho-matlab/localCopies|
|setupHarvestParamsforRealDataX.m|Configured based on the make_db|rho-matlab/localCopies|
|doRHO.m|Wrapper function to do the full experiment involving synthesis of a ground-truth labeled synthetic dataset batch and analyse using the MATLAB based Time Cell Analysis algorithms (legacy).<br>INPUT:<br>1. gDate   ... [generation date as yyyymmdd for synthetic dataset batch]<br>2. gRun   ... [generation code run number for synthetic dataset batch]<br>3. cDate   ... [consolidation date as yyyymmdd for analysis outputs]<br>4. cRun   ... [consolidation code run number for analysis outputs]<br>5. nTotalDatasets    ... [total number of datasets in the current synthetic dataset batch]<br>6. workingOnServer    ... [number to specify analysis machine dependent relative paths for file load/save]<br>7. diaryOn    ... [boolean switch to invoke MATLAB's diary feature for code run]<br>8. profilerTest    ... [boolean switch to invoke MATLAB's profiler for code run].<br>OUTPUT:<br>1. inUse    ... [structure; stores total memory usage across workspace variables for any given procedure, viz., synthesis, analysis method 1, analysis method 2, etc.]<br>2. runTime    ...  [structure; stores code run times for any given procedure, viz., synthesis, analysis method 1, analysis method 2, etc.]|rho-matlab/src|
<br>

## MISCELLANEOUS NOTES:<br>
All data used has been processed for cell masks and roi detection using [Suite-2p](https://www.suite2p.org).
Any other cell detection system will also work, but with appropriate modifications.
Here, I have provided an example dataset with the repository - "M26_20180514.mat", located in "../rho-matlab/demos/"

--> Create a directory according to:
~/Work/Analysis/Imaging/MouseName/RecordingDate/ e.g. - "/home/bhalla/ananthamurthy/Work/Analysis/Imaging/M26/20180514/"

--> Copy M26_20180514.mat into the aforementioned directory. Now, the physiology dataset is in place, the code base can be run.

ESSENTIAL STEPS (Steps 5 & 6 are legacy):

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

      // Depending on the experiment I had many different config files in "configSynth.m":

        a) setupSyntheticDataParams %Loads all options for canonical Time Cells [Total N = 360]

        b) setupSyntheticDataParams2 %Loads all options for Parameter Sensitivity Ananlysis (PSA) [Total N = 297]

        c) setupSyntheticDataParams3 %Loads all options for PSA and canonical Time Cells [Total N = 417]

        d) setupSyntheticDataParams4 %Loads all options for Time Cells with Background Activity [Total N = 120]

        e) setupSyntheticDataParams5 %Loads all options for studying the dependence of Predictive Performance with Background Activity

        f) setupSyntheticDataParams6 %Loads all options for PSA, canonical Time Cells, and Time Cells with Background Activity [Total N = 537]

        g) setupSyntheticDataParams7 %Loads all options for canonical Time Cells and Time Cells with Background [Total N = N*12]

        h) setupSyntheticDataParams8 %Loads all options for PSA, canonical Time Cells, and Time Cells with Background Activity [Total N = 537]

        i) setupSyntheticDataParams9 %Loads all options for PSA, canonical Time Cells, and Time cells with Background Activity [Total N = 567]

        // Use your choice or make a new config file, as required. To replicate the experiments for the paper, use "setupSyntheticDataParams9.m" (comment out the rest).<br>
        // Library Curation or Load is already built into "generateSyntheticData.m".

5. [Legacy] Once step 4 is complete, just make sure the correct/same experiment config file is considered when running "runBatchAnalysis.m". This function requires

        a) a generation Date or "gDate" which is the date the user decided to make synthetic data,

        b) "gRun" (typically 1), which is the run number (useful if multiple synthetic data generation runs were launched on the same day, and

        c) "nDatasets", which is dependent on the config file (see step 4).<br>// One can run batch analysis with all the methods or one method at a time. I like to do one method at a time (this means consolidation is required).<br>// With a "gDate", "gRun" and an "nDatasets" as part of the name, there is enough information to find the right batch, in case of any doubt.

6. [Legacy] After this consolidate all the various outputs (all datasets, all methods) using "consolidateBatch.m". Make sure to configure "setupHarvestParams.m" based on how "runBatchAnalysis.m" was run. There are many such config files based on the experiment being conducted (see step 4). This consolidation requires

        a) a consolidation Date or "cDate" which is the date the user decided to consolidate the outputs, and,

        b) "cRun" (typically 1), which is the run number (useful if multiple consolidations were launched on the same day).

7. Run the Python/C++ analysis implementations to generate the first pass analysis outputs as .csv

8. Run any and all of the Paper Figures related scripts which use the .csvs in step 7, perform additional comparative analysis, and plot the various figure panels.
