function [ harmscr_prediction,idx_nopassing_threshold,idx_passing_threshold,fpca,fpcaObj] = plot_fdasc_cut_threshold( conc_profile_sum_ofinterest,num_yr,LineofInterest,cut_threshold, NX, breaks )



% % %numner to break in the function
% num_yr=20;
% LineofInterest=120;
% %the threshold for polluted or not polluted
% cut_threshold=0.01;

%this is the prediction we are interested in (200*number_of_realizations)
conc_profile_t_choice=conc_profile_sum_ofinterest(200*(num_yr-1)+1:200*num_yr,:);

%Splitting into 2 groups by simply thresholding 
max_each_curve=max(conc_profile_t_choice);
tag=(max_each_curve>=cut_threshold);

idx_nopassing_threshold=find(tag==0);
idx_passing_threshold=find(tag==1);

%create the colorcode (prediction is red color)
if (LineofInterest==120);
    for i=1:length(tag)
        if (tag(i))
            color_code_lplot{i}='r';
        else
            color_code_lplot{i}='b';
        end
    end
else
    for i=1:length(tag)
    if (tag(i))
        color_code_lplot{i}='b';
    else
        color_code_lplot{i}='r';
    end
    end
end

%plot the curves colored by breakthrough or no
%the end year of the prediction
%subplot(2,1,2);
figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
for i=1:size(conc_profile_t_choice,2)
    plot(1:NX,conc_profile_t_choice(:,i),'color',color_code_lplot{i},'LineWidth',2);
    hold on;
end
hold off;
set(gca,'LineWidth',3)
title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);


%only do fda analysis on the curves that breaksthrough
conc_profile_t_choice_bt=conc_profile_t_choice(:,idx_passing_threshold);


%do the log transform on the concentration
for i=1:size(conc_profile_t_choice_bt,2)
    temp_conc=conc_profile_t_choice_bt(:,i);
    idx_nonzero=find(temp_conc~=0);
    idx_zero=find(temp_conc==0);
    
    %the log transform 
    log_conc_profile_t_choice_bt(idx_nonzero,i)=real(log10(temp_conc(idx_nonzero)));
    
    
    %set to zeros to -0.01 
    log_conc_profile_t_choice_bt(idx_zero,i)=-2.*ones(length(idx_zero),1);
    
end

%smaller value (<0.01) along the line are set to -0.01
log_conc_profile_t_choice_bt(find(log_conc_profile_t_choice_bt<-2))=-2;

%conduct FCA on the log transformed data
%conduct fda analysis on curves without zero
%not Gaussian distribution if not Gaussian distribution 
[harmscr_prediction,fpca,fpcaObj]=fda_analysis(log_conc_profile_t_choice_bt,breaks,NX);


%plot the histogram of harmonic scores in each dimension 
figure;
for i=1:size(harmscr_prediction,2)
    subplot(3,2,i)
    hist(harmscr_prediction(:,i),20);
    title(['harmonic scores histogram in' blanks(1) num2str(i) 'th dimension']);
end

%make 2d pdf of the scores
kernel_2dpdf(harmscr_prediction);



%the gaussian pdf
mean_scpred=mean(harmscr_prediction);
cov_scpred=cov(harmscr_prediction);
r_sample = mvnrnd(mean_scpred,cov_scpred,size(harmscr_prediction,1));
kernel_2dpdf(r_sample);
%save out the original scores for R processing
%save('harmscr_prediction.dat','harmscr_prediction','-ascii');

% %plot the histogram of scores by groups
% harmscr_prediction_nopassing=harmscr_prediction(idx_nopassing_threshold,:);
% harmscr_prediction_passing=harmscr_prediction(idx_passing_threshold,:);
% 
% %calculate the inital mean values and covariance based on the grouping 
% Mu_init=[mean(harmscr_prediction_nopassing);mean(harmscr_prediction_passing)];
% Sigma_init(:,:,1)=cov(harmscr_prediction_nopassing);
% Sigma_init(:,:,2)=cov(harmscr_prediction_passing);
% 
% figure;
% title(' for cases not passing threshold');
% for i=1:size(harmscr_prediction_nopassing,2)
%     subplot(3,2,i)
%     hist(harmscr_prediction_nopassing(:,i));
%     title(['harmonic scores histogram in' blanks(2) num2str(i) 'th dimension']);
% end
% 
% 
% figure;
% title(' for cases passing threshold');
% for i=1:size(harmscr_prediction_passing,2)
%     subplot(3,2,i)
%     hist(harmscr_prediction_passing(:,i));
%     title(['harmonic scores histogram in' blanks(2) num2str(i) 'th dimension ']);
% end


% %plot in log scale
% figure;
% %axis handle
% axes('FontSize',12,'FontWeight','b');hold on;box on;
% for i=1:size(conc_profile_t_choice,2)
%     
%     plot(1:NX,log_conc_profile_t_choice(:,i),'color',color_code_lplot{i});
%     
%     hold on;
% end
% hold off;
% 
% set(gca,'LineWidth',3)
% title(['Log concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);

% %plot separate figures for 2 groups 
% figure;
% %axis handle
% axes('FontSize',12,'FontWeight','b');hold on;box on;
% for i=1:length(idx_nopassing_threshold)
%     
%     plot(1:NX,conc_profile_t_choice(:,idx_nopassing_threshold(i)),'color',color_code_lplot{idx_nopassing_threshold(i)});
%     
%     hold on;
% end
% hold off;
% 
% set(gca,'LineWidth',3)
% title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);
% 
% 
% figure;
% %axis handle
% axes('FontSize',12,'FontWeight','b');hold on;box on;
% for i=1:length(idx_passing_threshold)
%     
%     plot(1:NX,conc_profile_t_choice(:,idx_passing_threshold(i)),'color',color_code_lplot{idx_passing_threshold(i)});
%     
%     hold on;
% end
% hold off;
% 
% set(gca,'LineWidth',3)
% title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);
% 


end