function [quantiles_sum ] = statistical_curves( conc_profile_sum_ofinterest,num_yr,LineofInterest)
%This function gets the p10,p50,p90 statistical curves out of all the
%curves
%   Detailed explanation goes here
%this is the prediction we are interested in 

conc_profile_t_choice=conc_profile_sum_ofinterest(200*(num_yr-1)+1:200*num_yr,:);
NX=200;
quantiles_sum=[];

%number of quantiles
p_values=10:10:90;
quantile_p=p_values/100;

for i=1:size(conc_profile_t_choice,1)
    conc_along_i=conc_profile_t_choice(i,:);
    %get the p10,p90,p50 for each i locaiton
    quantiles_temp=quantile(conc_along_i,quantile_p);
    %each row then is px values along the line
    quantiles_sum=[quantiles_sum quantiles_temp'];
    %size(quantiles_sum);
end


%makeing plots of the statistical curves
C=jet;
color_code_lplot=C(floor(linspace(1,size(C,1),length(p_values))),:);

figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
for i=1:size(quantiles_sum,1)
    %figure;
    %axis handle
    %axes('FontSize',12,'FontWeight','b');hold on;box on;
    
    plot(1:NX,quantiles_sum(i,:),'color',color_code_lplot(i,:),'LineWidth',3);
    %set(gca,'LineWidth',3)
    %title(['p' num2str(p_values(i))  blanks(1) 'representation of all curves at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);
    hold on;
end
hold off;
ylim([0 0.2]);

%set the frame line width 
set(gca,'LineWidth',3);
    
title([ 'representation of all curves at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);
legend('p10','p20','p30','p40','p50','p60','p70','p80','p90') ;

end

