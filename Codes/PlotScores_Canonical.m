function PlotScores_Canonical(U,V,dobs,y_vector)
%this function plots the scores distribution against dobs in canonical
%space, first dimenison
%   Detailed explanation goes here
%plot the data line along the axe 
figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
scatter(U(:,1),V(:,1),60,'bo','filled');
hold on;

plot(dobs(1).*ones(length(y_vector),1),y_vector,'r-','LineWidth',2);
h = text(dobs(1)+0.1,3.5,'d_{obs}');
h.FontSize = 14;
hold off;
xlabel('d_1^c');
ylabel('h_1^c');
title('observed data score location');


end

