clc;clear all;close all;

% NOTE: excludes last datapoint


% Can edit
datafile_preLTP = 'PreLTP_analyzed.mat';
datafile_postLTP = 'PostLTP_analyzed.mat';

OutputName = 'PreAndPost';

datapoints2use = 10;



% variables = {'EarlyComponents_x','LateComponents_x','LocalMaximums_x','EarlyComponents_y','LateComponents_y','LocalMaximums_y','Slopes','Slopes_Rsquared'};


% Dont edit

data_preLTP = load(datafile_preLTP);
data_postLTP = load(datafile_postLTP);

ChannelNames_pre = fieldnames(data_preLTP.MultiChannelData_analyzed);
ChannelNames_post = fieldnames(data_postLTP.MultiChannelData_analyzed);

PreAndPost = struct();

% Vector of channelnumbers
realchannelnumber = zeros(1,length(ChannelNames_pre));
for n = 1:length(ChannelNames_pre)
    
       realchannelnumber(n) = str2double(data_preLTP.MultiChannelData_analyzed.(ChannelNames_pre{n}).RealChannelNumber);
       
end

realchannelnumber = realchannelnumber';

pre = zeros(datapoints2use,length(ChannelNames_pre));
post = zeros(datapoints2use,length(ChannelNames_pre));

% Slopes
Slopes_pre = pre;
Slopes_post = post;

for n=1:length(ChannelNames_pre)
    
    Slopes_pre(:,n) = data_preLTP.MultiChannelData_analyzed.(ChannelNames_pre{n}).Slopes(end-datapoints2use:end-1);
    Slopes_post(:,n) = data_postLTP.MultiChannelData_analyzed.(ChannelNames_post{n}).Slopes(end-datapoints2use:end-1);
    
    baseline = mean(Slopes_pre);
    
    Slopes_pre = Slopes_pre-baseline;
    Slopes_post = Slopes_post-baseline;
    
end

Slopes_pre = [realchannelnumber,Slopes_pre'];
Slopes_post = [realchannelnumber,Slopes_post'];
PreAndPost.Slopes = [Slopes_pre;Slopes_post];




% Early

EarlyX_pre = pre;
EarlyX_post = post;
EarlyY_pre = pre;
EarlyY_post = post;


for n=1:length(ChannelNames_pre)
    
    
    Early_pre = cell2mat(data_preLTP.MultiChannelData_analyzed.(ChannelNames_pre{n}).EarlyComponents(end-datapoints2use:end-1));
    Early_post = cell2mat(data_postLTP.MultiChannelData_analyzed.(ChannelNames_post{n}).EarlyComponents(end-datapoints2use:end-1));
    
    EarlyX_pre(:,n) = Early_pre(:,1);
    EarlyX_post(:,n) = Early_post(:,1);
    EarlyY_pre(:,n) = Early_pre(:,2);
    EarlyY_post(:,n) = Early_post(:,2);
    
    
    
end

EarlyX_pre = [realchannelnumber,EarlyX_pre'];
EarlyX_post = [realchannelnumber,EarlyX_post'];
PreAndPost.EarlyX = [EarlyX_pre;EarlyX_post];
EarlyY_pre = [realchannelnumber,EarlyY_pre'];
EarlyY_post = [realchannelnumber,EarlyY_post'];
PreAndPost.EarlyY = [EarlyY_pre;EarlyY_post];

% Late

LateX_pre = pre;
LateX_post = post;
LateY_pre = pre;
LateY_post = post;


for n=1:length(ChannelNames_pre)
    
    
    Early_pre = cell2mat(data_preLTP.MultiChannelData_analyzed.(ChannelNames_pre{n}).LateComponents(end-datapoints2use:end-1));
    Early_post = cell2mat(data_postLTP.MultiChannelData_analyzed.(ChannelNames_post{n}).LateComponents(end-datapoints2use:end-1));
    
    LateX_pre(:,n) = Early_pre(:,1);
    LateX_post(:,n) = Early_post(:,1);
    LateY_pre(:,n) = Early_pre(:,2);
    LateY_post(:,n) = Early_post(:,2);
    
    
    
end

LateX_pre = [realchannelnumber,LateX_pre'];
LateX_post = [realchannelnumber,LateX_post'];
PreAndPost.LateX = [LateX_pre;LateX_post];
LateY_pre = [realchannelnumber,LateY_pre'];
LateY_post = [realchannelnumber,LateY_post'];
PreAndPost.LateY = [LateY_pre;LateY_post];

names = fieldnames(PreAndPost);

outputfolder = data_preLTP.Config.Outputfolder;

for n=1:length(names)
    
    
    
    csvname = [outputfolder OutputName '_' names{n} '.csv'];
    csvwrite(csvname,PreAndPost.(names{n}));
    
    
end




