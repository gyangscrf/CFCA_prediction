function [ Y, eigVector,eigValue ] = kpca_process( r_summary )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Gaussian kernel PCA

%debug
d=size(r_summary,1);
DIST=distanceMatrix(r_summary);
DIST(DIST==0)=inf;
DIST=min(DIST);
%the sigma squared para (c=5)
para=5*mean(DIST);
disp('Performing Gaussian kernel PCA...');
[Y, eigVector,eigValue]=kPCA(r_summary,d,'gaussian',para);

end

