function [MultichannelData, ChannelNames] = getMultichannelData(MultichannelDataFile)
% clear all; clc; close all;

MultichannelData = load(MultichannelDataFile);

ChannelNames = fieldnames(MultichannelData); 
end
