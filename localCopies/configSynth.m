%Select Synthetic Data Configuration Details

if profilerTest
    setupSyntheticDataParametersSingle
else
    %setupSyntheticDataParams %Loads all options for Physiology (N=360)
    %setupSyntheticDataParams2 %Loads all options for PSA (N=297)
    setupSyntheticDataParams3 %Loads all options for Physiology and PSA (N=417)
end