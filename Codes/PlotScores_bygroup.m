function PlotScores_bygroup( scores_gp1,scores_gp2 )
%this function plots the scores after fda
%   Detailed explanation goes here

%color by passing or no passing for the scatterplot
figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
%color the polluted one with blue color
for i=1:size(scores_gp1,1)
        plot(scores_gp1(i,1), scores_gp1(i,2), 'o', 'Color','b', ...  % points in clusters
            'MarkerSize', 10, 'LineWidth', 1,'MarkerFaceColor','b', ...
            'MarkerEdgeColor','k');
        hold on;
end
%color the non-polluted one with red color
for i=1:size(scores_gp2,1)
        plot(scores_gp2(i,1), scores_gp2(i,2), 'o', 'Color','r', ...  % points in clusters
            'MarkerSize', 10, 'LineWidth', 1,'MarkerFaceColor','r', ...
            'MarkerEdgeColor','k');
        hold on;
end
hold off;
grid on;
%the line thickness of the box
set(gca,'LineWidth',3)
%set(gca,'XTickLabel',{''})
%set(gca,'YTickLabel',{''})
title('fda scores distribution');
end

