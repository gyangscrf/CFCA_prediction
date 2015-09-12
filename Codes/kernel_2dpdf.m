function  kernel_2dpdf( harmscr_prediction )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% Generate some normally distributed data
x = harmscr_prediction(:,1);
y = harmscr_prediction(:,2);
% Estimate a continuous pdf from the discrete data
[pdfx xi]= ksdensity(x);
[pdfy yi]= ksdensity(y);
% Create 2-d grid of coordinates and function values, suitable for 3-d plotting
[xxi,yyi]     = meshgrid(xi,yi);
[pdfxx,pdfyy] = meshgrid(pdfx,pdfy);
% Calculate combined pdf, under assumption of independence
pdfxy = pdfxx.*pdfyy; 
% Plot the results
%mesh plot
figure
mesh(xxi,yyi,pdfxy)
set(gca,'XLim',[min(x) max(x)])
set(gca,'YLim',[min(y) max(y)])


figure;
imagesc(pdfxy/max(pdfxy(:)));
% axis([min(x) max(x) min(y) max(y)]);
%take out the axis 
set(gca,'XTick',[]);
set(gca,'YTick',[]);


end

