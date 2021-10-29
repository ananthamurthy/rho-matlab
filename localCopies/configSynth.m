%Select Synthetic Data Configuration Details

if profilerTest
    setupSyntheticDataParametersSingle
else
    %setupSyntheticDataParams %Loads all options for Parameter Sensitivity Analysis (N = 199); "PSA1" or "Unphysiological"
    %setupSyntheticDataParams2 %Loads all options for specific Synthetic Datasets (N=1*33); "BoS"
    %setupSyntheticDataParams3 %Loads all options for specific Synthetic Datasets (N=8*12); "Physiological"
    setupSyntheticDataParams4 %Loads all options for specific Synthetic Datasets (N=3*111); all out; "PSA2 + Physiology"
end
