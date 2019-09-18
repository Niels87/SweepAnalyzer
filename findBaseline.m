function baseline = findBaseline(SingleSweep,Config)

Baselinewindow_index = ms2index(Config.BaselineWindow,Config.SamplingRate);

baseline = mean(SingleSweep(Baselinewindow_index(1):Baselinewindow_index(2)));

end