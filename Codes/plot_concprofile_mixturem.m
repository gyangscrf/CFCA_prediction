function  plot_concprofile_mixturem( conc_profile_sum_ofinterest,num_yr,LineofInterest,idx )

NX=200;

%this is the prediction we are interested in 
conc_profile_t_choice=conc_profile_sum_ofinterest(200*(num_yr-1)+1:200*num_yr,:);



for i=1:length(idx)
    if idx(i)==1
    color_code_lplot{i}='r';
    
    else
    color_code_lplot{i}='b';
    end
end



%plot the curves colored by breakthrough or no
%the end year of the prediction

%subplot(2,1,2);
figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
for i=1:size(conc_profile_t_choice,2)
    
    plot(1:NX,conc_profile_t_choice(:,i),'color',color_code_lplot{i});
    
    hold on;
end
hold off;

set(gca,'LineWidth',3)
title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);
end