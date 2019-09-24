% ---- Sweepanalyzer ---

clc; close all; clear all;


% --- Config area (can edit) ---

% Output folder
outputfolder = 'C:\Users\au258658\Documents\MATLAB\SweepAnalysis\';

MultichannelDataFile = 'PreLTP.mat';

channelmap =    [
                0,32,0;
                10,1,19;
                11,30,17;
                12,3,18;
                9,28,21;
                13,5,20;
                8,26,23;
                14,7,22;
                6,31,25;
                15,2,24;
                4,27,29;
                0,16,0
                ];

% Number of sweeps to average for smoothing. 1  is no smoothing.
SmoothingFactor = 1;

% Normalize to earlycomponent?
Normalization = 'yes';

% Zero to baseline?
Zero2Baseline = 'yes';

BaselineWindow = [0,5];

% MinimumDetectionMode = 'auto';
% window = [0,50];

MinimumDetectionMode = 'interactive';
windowsize = 10; % in number of datapoints

% MinimumDetectionMode = 'window';
% EarlyComponentWindow = [5,8];
% LateComponentWindow = [8,12];

% --- (don't edit) ---

% Import data to datastruct

[MultichannelData, ChannelNames] = getSweepData(MultichannelDataFile);

% --- Setup Config struct ---

Config = struct();

% SamplingRate (uses the samplingrate from the first channel in the list of channelnames)
if isfield(MultichannelData.(ChannelNames{1}),'interval') == 1
    Config.SamplingRate = round(1/MultichannelData.(ChannelNames{1}).interval);
else
    disp('SamplingRate not found in datafile');
end

% Smoothingfactor
Config.SmoothingFactor = SmoothingFactor;

% Normalization
Config.Normalization = Normalization;

% Zero2Baseline
Config.Zero2Baseline = Zero2Baseline;

% Baselinewindow
Config.BaselineWindow = BaselineWindow;

% Datafile and outputfolder
Config.MultichannelDataFile = MultichannelDataFile;
Config.Outputfolder = outputfolder;

% Windowsize
Config.Windowsize = windowsize;

% Channelmap
Config.Channelmap = channelmap;

% MinimumDetection
if strcmp(MinimumDetectionMode,'auto') == 1
    window = ms2index(window,Config.SamplingRate);
    MinimumDetection = {MinimumDetectionMode,window};
elseif strcmp(MinimumDetectionMode,'window') == 1
    EarlyComponentWindow = ms2index(EarlyComponentWindow,Config.SamplingRate);
    LateComponentWindow = ms2index(LateComponentWindow,Config.SamplingRate);
    MinimumDetection = {MinimumDetectionMode,EarlyComponentWindow,LateComponentWindow};
elseif strcmp(MinimumDetectionMode,'interactive') == 1
    [earlyCompWindow,lateCompWindow,localMaxWindow] = generateWindows(MultichannelData,ChannelNames,Config);
    MinimumDetection = {MinimumDetectionMode,earlyCompWindow,lateCompWindow,localMaxWindow};
else
    disp('Error in MinimumDetection');
end

Config.MinimumDetection = MinimumDetection;

% --- Main ---


%   Loop over all channels

MultiChannelData_analyzed = struct();

for n=1:length(ChannelNames)
    
    SingleChannelData = MultichannelData.(ChannelNames{n});
    disp(['Now analyzing: ' ChannelNames{n}]);
    
    if isfield(SingleChannelData,'values') == 1
        
        SingleChannelData_analyzed = singleChannelAnalyzer(SingleChannelData,Config);
        
        SingleChannelData_analyzed.RealChannelNumber = SingleChannelData.title;
        MultiChannelData_analyzed.(ChannelNames{n}) = SingleChannelData_analyzed;
        
    end
    
end

variables2plot = {'Slopes','Average.Sweep'};
plottypes = {'scatter','line'};
plothandles = multiChannelPlotter(MultiChannelData_analyzed,Config,variables2plot,plottypes);

% Saves analyzed data to file
filename = [erase(MultichannelDataFile,'.mat'),'_analyzed.mat'];
filename = [outputfolder,filename];
save(filename,'MultiChannelData_analyzed','Config');

save2csv(MultiChannelData_analyzed,Config);
