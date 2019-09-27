clc;clear all; close all;


% Can edit
datafiles = {'PreLTP_analyzed.mat','PostLTP_analyzed.mat'};

outputfolder = 'C:\Users\au258658\Documents\MATLAB\outputfolder\';


% Dont Edit (and dont look:S)


Parameters = {'Slopes','Slopes_Rsquared','EarlyComponents','LateComponents','localMaximums'};

% parameterIsCoordinate = {'EarlyComponents','LateComponents','localMaximums'};
% outputParameters = {'EarlyComponents_x','LateComponents_x','LocalMaximums_x','EarlyComponents_y','LateComponents_y','LocalMaximums_y','Slopes','Slopes_Rsquared'};




dataholder = cell(length(datafiles),1);


for n = 1:length(datafiles)
    
    dataholder{n} = load(datafiles{n});

end

%   Reorganize data in convenient datastructure (parameter->file->channel)

mystruct = struct();

for n=1:length(Parameters)
    
    currentParameter = Parameters{n};
    
    parameterholder = cell(1,length(datafiles));

    for m = 1:length(datafiles)
        
        currentDatastruct = dataholder{m};
        currentDatastruct = currentDatastruct.MultiChannelData_analyzed;
        ChannelNames = fieldnames(currentDatastruct);
        valuesAllChannels = cell(1,length(ChannelNames));
        
        for i = 1:length(ChannelNames)
            
            realChannelNumber = str2double(currentDatastruct.(ChannelNames{i}).RealChannelNumber);
            
            currentValues = currentDatastruct.(ChannelNames{i}).(Parameters{n});    
            
            if iscell(currentValues) == 1
                
                wasCell = 1;
                
                currentValues = cell2mat(currentValues);
                %
                %                 currentValues_x = currentValues(:,1);
                %
                %                 currentValues_y = currentValues(:,2);
                                
                valuesAllChannels_x{i} = [realChannelNumber;currentValues(:,1)];
                valuesAllChannels_y{i} = [realChannelNumber;currentValues(:,2)];
                
            else
                wasCell = 0;
                
                valuesAllChannels{i} = [realChannelNumber;currentValues];
            end
            
            
            
        end
        
        if wasCell == 1
            fieldnameFromDatafile = erase(datafiles{m},'.mat');
            
            parametername = [currentParameter '_x'];
            mystruct.(parametername).(fieldnameFromDatafile) = valuesAllChannels_x;
            parametername = [currentParameter '_y'];
            mystruct.(parametername).(fieldnameFromDatafile) = valuesAllChannels_y;
                        
        else
            fieldnameFromDatafile = erase(datafiles{m},'.mat');
            mystruct.(currentParameter).(fieldnameFromDatafile) = valuesAllChannels;
        end
        
    end
    
end

% Write csv according to new datastructure with NaN padding

outputParameters = fieldnames(mystruct);

for n =1:length(outputParameters)
    
    currentParameter = outputParameters{n};
        
    csvCell = {};
    sizes = zeros(1,length(datafiles));
    
    for m =1:length(datafiles)
        
        fieldnameFromDatafile = erase(datafiles{m},'.mat');
        csvCell = [csvCell,cell2mat(mystruct.(currentParameter).(fieldnameFromDatafile))];
        
        sizes(m) = size(cell2mat(mystruct.(currentParameter).(fieldnameFromDatafile)),1);
        
    end
    
    csvMat = NaN(max(sizes),length(ChannelNames)*length(datafiles));

    for m=1:length(csvCell)
        
        dim1 = [1,sizes(m)];
        dim2 = [1+(m-1)*length(ChannelNames),m*length(ChannelNames)];
        csvMat(dim1(1):dim1(2),dim2(1):dim2(2)) = csvCell{m};
        
        
    end
    
    csvname = [outputfolder currentParameter,'.csv'];
    
    csvwrite(csvname,csvMat);
    
end



