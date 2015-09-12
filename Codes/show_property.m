function [ perm_realization] = show_property(CaseNum)


%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% %for debugging
% scenario=geologic_scenarios(1);
% CaseNum=CaseNum{1};

input_realization=['examples_property/Case' num2str(CaseNum) 'poro'];

%load the data
temp=importdata(input_realization);
perm_realization=temp.data;


figure;
imagesc(reshape(perm_realization,200,200));
%add the color bar
colorbar;
caxis([0.1 0.3]);



end

