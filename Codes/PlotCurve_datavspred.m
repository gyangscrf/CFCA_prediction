function PlotCurve_datavspred(curve_data,curve_prediction,NX)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
plot(1:NX,curve_data,'b-','LineWidth',3); hold on;
plot(1:NX,curve_prediction,'r-','LineWidth',3); hold off;
ylim([0 0.6]);
legend('d_{obs}','True simulated profile from d_{obs}');
title('Concentration profile of d_{obs} and prediction from d_{obs}');

end

