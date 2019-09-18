function [earlyCompWindow,lateCompWindow,localMaxWindow] = generateWindows(MultichannelData,ChannelNames,Config)

TestChannels = Config.Channelmap;

AllSweeps = [];

for n=1:length(ChannelNames)

    % Check if testchannels are in dataset
    L = ismember(str2num(MultichannelData.(ChannelNames{n}).title),TestChannels);
    
    if L>0
        currentsweep = MultichannelData.(ChannelNames{n}).values;
        AllSweeps = cat(1,AllSweeps,currentsweep);
    end
    
end

TestSweep = mean(AllSweeps);

[~,Pmin] = islocalmin(TestSweep);
[~,Pmax] = islocalmax(TestSweep);
P = Pmax;
Pmin_nonzero = find(Pmin);
P(Pmin_nonzero) = Pmin(Pmin_nonzero);

maximum = max(P);
P = P/maximum;

P_nonzero = P(find(P));
P_nonzero_median = median(P_nonzero);


P_cutoff = P_nonzero_median*10;
fig = figure;

while isempty(P_cutoff) == 0
    

    extremities = logical(P>P_cutoff);
    extremities = find(extremities);

    
    plot(TestSweep);
    hold on
    scatter(extremities,TestSweep(extremities));
    num = [1:length(extremities)];
    markers = num2str(num');

    text(extremities,TestSweep(extremities),markers)
    hold off
    disp(['Prominence was ', num2str(P_cutoff)]);
    
    P_cutoff = input('New Prominence value? (press return to accept current value)');

end


earlyComp_x = input('Early Component?');
lateComp_x = input('Late Component?');
localMax_x = input('Local Maximum?');



earlyComp_x = extremities(earlyComp_x);
lateComp_x = extremities(lateComp_x);
localMax_x = extremities(localMax_x);

tolerance = Config.Windowsize;

earlyCompWindow = [earlyComp_x-tolerance,earlyComp_x+tolerance];
lateCompWindow = [lateComp_x-tolerance,lateComp_x+tolerance];
localMaxWindow = [localMax_x-tolerance,localMax_x+tolerance];

close gcf;
end