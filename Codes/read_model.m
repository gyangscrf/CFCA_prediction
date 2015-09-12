function [ realization ] = read_model( filename )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

fileID=fopen(filename,'r');

C=textscan(fileID,'%f', 'HeaderLines',3);
realization=C{1};



end

