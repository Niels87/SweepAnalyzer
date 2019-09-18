function singleSweep_analyzed = singleSweepAnalyzer(SingleSweep,Config)

singleSweep_analyzed = struct();

% Zero to baseline
baseline = findBaseline(SingleSweep,Config);
SingleSweep = SingleSweep-baseline;

[earlyComp_x, lateComp_x, localMax_x] = findMinMax(SingleSweep,Config);

% Normalize to early component
if strcmp(Config.Normalization,'yes') == 1
    SingleSweep = SingleSweep/abs(SingleSweep(earlyComp_x));
end

singleSweep_analyzed.Sweep = SingleSweep;

%   Find the coordinates of the Minimums and maximums on the (normalized) sweep
    
earlyComp = [earlyComp_x,SingleSweep(earlyComp_x)];
singleSweep_analyzed.earlyComp = earlyComp;

lateComp = [lateComp_x,SingleSweep(lateComp_x)];
singleSweep_analyzed.lateComp = lateComp;

localMax = [localMax_x,SingleSweep(localMax_x)];
singleSweep_analyzed.localMax = localMax;
    
%   Prepare for linear regression

P = abs(lateComp(2)-localMax(2));
    
upperBound = localMax(2)-P*0.1;
lowerBound = lateComp(2)+P*0.1;

%   Linear regression
%   "Cut-out" along the x-axis from local max to late comp
regression_y = SingleSweep(localMax(1):lateComp(1));
singleSweep_analyzed.RegressionVector_uncut = regression_y;

% margin = round(length(regression_y)*0.1);
% 
% regression_y =  regression_y(margin:end-margin);


%   "Cut-out" along the y-axis according to upper/lower bound
regression_y = regression_y(regression_y<upperBound & regression_y>lowerBound);
singleSweep_analyzed.RegressionVector = regression_y;
%   Generate x-values for regression in millisecond
regression_x = [1:length(regression_y)];
regression_x = index2ms(regression_x,Config.SamplingRate);

%   Do linear regression if the "cut-out" contains more than 1 datapoint
if length(regression_y)>1
    regModel = LinearModel.fit(regression_x',regression_y','linear');
    regCoefficients = regModel.Coefficients;
    
    slope = regCoefficients{2,1};
    singleSweep_analyzed.slope = slope;
    
    r_squared = regModel.Rsquared.Ordinary;
    singleSweep_analyzed.r_squared = r_squared;
else
%     disp(['sweep ' ' had an issue']);
end

%   Convert indices to millisecond
singleSweep_analyzed.earlyComp(1) = index2ms(singleSweep_analyzed.earlyComp(1),Config.SamplingRate);

singleSweep_analyzed.lateComp(1) = index2ms(singleSweep_analyzed.lateComp(1),Config.SamplingRate);

singleSweep_analyzed.localMax(1) = index2ms(singleSweep_analyzed.localMax(1),Config.SamplingRate);

end

