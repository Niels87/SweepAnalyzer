function output = save2csv(MultiChannelData_analyzed,Config)

MultichannelDataFile = 'PreLTP.mat';


variables2save = {'EarlyComponents_x','LateComponents_x','LocalMaximums_x','EarlyComponents_y','LateComponents_y','LocalMaximums_y','Slopes','Slopes_Rsquared'};

ChannelNames = fieldnames(MultiChannelData_analyzed);

EndOfBaseline = Config.BaselineWindow(2);

EarlyComponents_x = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).EarlyComponents)+1);
LateComponents_x = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).LateComponents)+1);
LocalMaximums_x = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).localMaximums)+1);
EarlyComponents_y = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).EarlyComponents)+1);
LateComponents_y = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).LateComponents)+1);
LocalMaximums_y = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).localMaximums)+1);

Slopes = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).Slopes)+1);
Slopes_Rsquared = zeros(length(ChannelNames),length(MultiChannelData_analyzed.(ChannelNames{1}).Slopes_Rsquared)+1);

for n=1:length(ChannelNames)
    
    
    EarlyComponents_x(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    LateComponents_x(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    LocalMaximums_x(n,1) = str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    
    EarlyComponents_y(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    LateComponents_y(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    LocalMaximums_y(n,1) = str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    
    Slopes(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    Slopes_Rsquared(n,1)= str2double(MultiChannelData_analyzed.(ChannelNames{n}).RealChannelNumber);
    
    EarlyComponents_mat = cell2mat(MultiChannelData_analyzed.(ChannelNames{n}).EarlyComponents);
    
    LateComponents_mat = cell2mat(MultiChannelData_analyzed.(ChannelNames{n}).LateComponents);
    LocalMaximums_mat = cell2mat(MultiChannelData_analyzed.(ChannelNames{n}).localMaximums);
    
    EarlyComponents_x(n,2:end)= EarlyComponents_mat(:,1) - EndOfBaseline;
    LateComponents_x(n,2:end)= LateComponents_mat(:,1) - EndOfBaseline;
    LocalMaximums_x(n,2:end)= LocalMaximums_mat(:,1) - EndOfBaseline;
    

    
    EarlyComponents_y(n,2:end)= EarlyComponents_mat(:,2);
    LateComponents_y(n,2:end)= LateComponents_mat(:,2);
    LocalMaximums_y(n,2:end)= LocalMaximums_mat(:,2);
    
    
    Slopes(n,2:end)= MultiChannelData_analyzed.(ChannelNames{n}).Slopes;
    Slopes_Rsquared(n,2:end)= MultiChannelData_analyzed.(ChannelNames{n}).Slopes_Rsquared;
    
    
    
end

EarlyComponents_x = EarlyComponents_x';
LateComponents_x = LateComponents_x';
LocalMaximums_x = LocalMaximums_x';

EarlyComponents_y = EarlyComponents_y';
LateComponents_y = LateComponents_y';
LocalMaximums_y = LocalMaximums_y';

Slopes = Slopes';
Slopes_Rsquared = Slopes_Rsquared';

for n = 1:length(variables2save)
    
    csvname = [Config.Outputfolder erase(Config.MultichannelDataFile,'.mat'),'_',variables2save{n},'.csv'];
    
    csvwrite(csvname,eval(variables2save{n}));
    
end


end