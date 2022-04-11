%Select Synthetic Data Configuration Details

if profilerTest
    setupSyntheticDataParametersSingle
else
    %setupSyntheticDataParams %Loads all options for canonical Time Cells [Total N = 360]
    %setupSyntheticDataParams2 %Loads all options for Parameter Sensitivity Ananlysis (PSA) [Total N = 297]
    %setupSyntheticDataParams3 %Loads all options for PSA and canonical Time Cells [Total N = 417]
    %setupSyntheticDataParams4 %Loads all options for Time Cells with Background Activity [Total N = 120]
    %setupSyntheticDataParams5 %Loads all options for studying the dependence of Predictive Performance with Background Activity
    setupSyntheticDataParams6 %Loads all options for PSA, canonical Time Cells, and Time Cells with Background Activity [Total N = 537]
    %setupSyntheticDataParams7 %Loads all options for canonical Time Cells and Time Cells with Background [Total N = 240]
end