function SingleChannel_analyzed = singleChannelAnalyzer(SingleChannelData,Config)

AllSweeps = SingleChannelData.values;

%   Smoothing
AllSweeps = smoothSweeps(AllSweeps,Config);

%   Find the average across sweeps
averageSweep = mean(AllSweeps);
% AllSweeps = cat(1,averageSweep,AllSweeps);

%   Setup arrays for storing outputs from analysis
slopes = zeros(size(AllSweeps,1),1);
r_squared = zeros(size(AllSweeps,1),1);
AllSweeps_analyzed = cell(size(AllSweeps,1),1);
earlyComps = cell(size(AllSweeps,1),1);
lateComps = cell(size(AllSweeps,1),1);
localMaximums = cell(size(AllSweeps,1),1);
regressionvectors = cell(size(AllSweeps,1),1);
regressionvectors_uncut = cell(size(AllSweeps,1),1);

%   Analyze the average sweep

averageSweep_analyzed = singleSweepAnalyzer(averageSweep,Config);

%   Loop over all sweeps

for n=1:size(AllSweeps,1)
    
    SingleSweep = AllSweeps(n,:);
    
    SingleSweep_analyzed = singleSweepAnalyzer(SingleSweep,Config);
    
    if isfield(SingleSweep_analyzed,'slope') == 1
        slopes(n) = SingleSweep_analyzed.slope;
        r_squared(n) = SingleSweep_analyzed.r_squared;
    else
        slopes(n) = NaN;
        r_squared(n) = NaN;
    end
        
    AllSweeps_analyzed{n} = SingleSweep_analyzed.Sweep;
    earlyComps{n} = SingleSweep_analyzed.earlyComp;
    lateComps{n} = SingleSweep_analyzed.lateComp;
    localMaximums{n} = SingleSweep_analyzed.localMax;
    regressionvectors{n} = SingleSweep_analyzed.RegressionVector;
    regressionvectors_uncut{n} = SingleSweep_analyzed.RegressionVector_uncut;
end

SingleChannel_analyzed = struct();

SingleChannel_analyzed.Average = averageSweep_analyzed;
SingleChannel_analyzed.Slopes = slopes;
SingleChannel_analyzed.Slopes_Rsquared = r_squared;
SingleChannel_analyzed.Sweeps = AllSweeps_analyzed;
SingleChannel_analyzed.EarlyComponents = earlyComps;
SingleChannel_analyzed.LateComponents = lateComps;
SingleChannel_analyzed.localMaximums = localMaximums;
SingleChannel_analyzed.RegressionVectors = regressionvectors;
SingleChannel_analyzed.RegressionVectors_uncut = regressionvectors_uncut;

end