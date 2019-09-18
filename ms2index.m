function in_index = ms2index(in_ms,samplingrate)

in_index = in_ms*samplingrate/1000;

in_index = round(in_index)+1;

end