function  prior_posterior_comparison(conc_profile_sum_ofinterest,obs_number,sample_posterior_curves,xsamples)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
yr_of_interest=20;

figure;
%axis handle
axes('FontSize',20,'FontWeight','b'); box on; hold on;


NX=200;
for i=1:size(conc_profile_sum_ofinterest,2)
    plot(1:NX,conc_profile_sum_ofinterest((yr_of_interest-1)*NX+1:yr_of_interest*NX,i),'Color',[0 0 0]+0.8,'LineWidth',1);hold on;
end
ylim([0 1])


for i=1:size(sample_posterior_curves,2)
    plot(xsamples, sample_posterior_curves(:,i), 'b-','LineWidth',2);hold on;
    
end


%plot the true curve
plot(1:NX,conc_profile_sum_ofinterest((yr_of_interest-1)*NX+1:yr_of_interest*NX,obs_number),'r-','LineWidth',3);
title('Posterior comparison with prior');
hold off;
end

