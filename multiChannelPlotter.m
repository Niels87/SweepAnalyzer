function figurehandles = multiChannelPlotter(MultiChannelData_analyzed,Config,plotvariables,plottypes)


datastructure = MultiChannelData_analyzed;
channelnames = fieldnames(datastructure);
dim = size(Config.Channelmap);
channelmap_hat = Config.Channelmap';
figurehandles = zeros(length(plotvariables),1);


for i=1:length(plotvariables)
    
    current_variable = plotvariables{i};
    
    figurehandles(i) = figure;
    
%     plothandles = zeros(length(plotvariables),length(channelnames));
    
    for n=1:(dim(1)*dim(2))
        
        channelnumber = channelmap_hat(n);
        for m=1:length(channelnames)
            if channelnumber == str2double(datastructure.(channelnames{m}).RealChannelNumber)
                subplot(dim(1),dim(2),n);
                
                y_str = ['datastructure' '.' channelnames{m} '.' current_variable];
                
                y = eval(y_str);
                x = 1:length(y);
                x = index2ms(x,Config.SamplingRate);
                
                if strcmp(plottypes{i},'line') == 1
%                     plothandles(m) = plot(x,y); 
                    plot(x,y); 
                elseif strcmp(plottypes{i},'scatter') == 1
%                     plothandles(m) = scatter(x,y,'.');
                    scatter(x,y,'.');                    
                else
                    disp('Plottype not recognized');
                end
              
                title(datastructure.(channelnames{m}).RealChannelNumber);
            end
        end
    end
    
    
    
    
    % Saves figure to file
    figurename = [erase(Config.MultichannelDataFile,'.mat'),'_',strrep(current_variable,'.','')];
    figurename = [Config.Outputfolder,figurename];
    print(gcf,figurename,'-dpdf','-fillpage');
end



end



