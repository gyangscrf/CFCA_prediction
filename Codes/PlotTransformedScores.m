function PlotTransformedScores(scores)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%plot the mds of all the scores
figure;
for i=1:size(scores,1)
        plot(scores(i,1), scores(i,2), 'o', 'Color','b', ...  % points in clusters
            'MarkerSize', 10, 'LineWidth', 1,'MarkerFaceColor','b', ...
            'MarkerEdgeColor','k');
        hold on;
end
grid on;
set(gca,'LineWidth',3)
%set(gca,'XTickLabel',{''})
%set(gca,'YTickLabel',{''})
title('fda scores distribution after boxcox transform');
xlim([quantile(scores(:,1),0.01)  quantile(scores(:,1),0.99)])
ylim([quantile(scores(:,2),0.01)  quantile(scores(:,2),0.99)])

end

