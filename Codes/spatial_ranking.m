function [ order ] = spatial_ranking(temp_realization,temp_length)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%debug
% r_summary=realization_summary{i};
% casenum_scenario=length(idx_scenario{i});
NX=200;
NY=200;

%reshape the r_summary
r_summary=reshape(temp_realization,NX*NY,temp_length);

% %figure checking
% figure;
% for i=1:size(r_summary,2)
%     img_test=reshape(r_summary(:,i),NX,NY);
%     imagesc(img_test);
%     pause();
% end

%return the full Kernel KPCA components
[Y, eigVector,eigValue]=kpca_process(r_summary');
%plot the kpca coefficients
figure;
axes('FontSize',20,'FontWeight','b');hold on;box on; grid on;
%we cannot color them now
scatter3(Y(:,1),Y(:,2),Y(:,3),200,'bo','filled');hold on;
%colorbar;
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'ZTickLabel','');
%plot the percetange of variance
%figure;
ploteigvalue(eigValue);

%Rank the SOM
NumNodes=size(r_summary,2);
%specify the number of nodes
%NumNodes=round(size(r_summary,2)/10);

figure;
%initialize the ranking
class=SOM_process(Y,NumNodes);

order=class';

figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;grid on;
%we cannot color them now
scatter3(Y(:,1),Y(:,2),Y(:,3),200,class,'filled');hold on;
%colorbar;
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'ZTickLabel','');
colorbar;

%rank the Y coordinates by class and connected the Y coordinates 
Y_with_rank=[Y order];

[~,index_rank]=sort(Y_with_rank(:,end));
Y_ordered=Y(index_rank,:);
%show the SOM result
figure;
axes('FontSize',20,'FontWeight','b');hold on;box on;grid on;
scatter3(Y_ordered(:,1),Y_ordered(:,2),Y_ordered(:,3),200,'bo','filled');hold on;
%colorbar;
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');
set(gca,'ZTickLabel','');
%show the SOM effect
plot3(Y_ordered(:,1),Y_ordered(:,2),Y_ordered(:,3),'r-','LineWidth',2);


%show some realizations by the rank 
figure;

img_test=reshape(r_summary(:,index_rank(end)),NX,NY);
imagesc(img_test);
set(gca,'XTickLabel','');
set(gca,'YTickLabel','');


end

