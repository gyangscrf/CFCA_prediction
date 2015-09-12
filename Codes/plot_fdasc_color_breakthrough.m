function [ harmscr_prediction,idx_nopassing_threshold,idx_passing_threshold,Mu_init,Sigma_init,PComponents_init ] = plot_fdasc_color_breakthrough( conc_profile_sum_ofinterest,num_yr,LineofInterest,threshold_error_pred )

NX=200;


%numner to break in the function
% num_yr=20;
% LineofInterest=120;


%this is the prediction we are interested in (200*number_of_realizations)
conc_profile_t_choice=conc_profile_sum_ofinterest(200*(num_yr-1)+1:200*num_yr,:);


%Splitting into 2 groups by simply thresholding 
% max_each_curve=max(conc_profile_t_choice);
% tag=(max_each_curve>=cut_threshold);
% 
% idx_nopassing_threshold=find(tag==0);
% idx_passing_threshold=find(tag==1);
% 
% 
% %only do fda analysis on the curves that breaksthrough
% conc_profile_t_choice_bt=conc_profile_t_choice(:,idx_passing_threshold)


%now we want to do a log transform on the concentration values
min_idx=0;
idx_nopassing=[];

for i=1:size(conc_profile_t_choice,2)
    temp_conc=conc_profile_t_choice(:,i);
    idx_nonzero=find(temp_conc~=0);
    idx_zero=find(temp_conc==0);
    %the non-passing ones  (all zeros concentrations)
    if(length(idx_nonzero)==0)
        idx_nopassing=[idx_nopassing i];
    else
        min_idx=min_idx+1;
        %the log transform 
        log_conc_profile_t_choice(idx_nonzero,i)=real(log(temp_conc(idx_nonzero)));
        min_conc(min_idx)=min(real(log(temp_conc(idx_nonzero))));
        log_conc_profile_t_choice(idx_zero,i)=min_conc(min_idx).*ones(length(idx_zero),1);
    end 
end

min_min_conc=min(min_conc);
log_conc_profile_t_choice(:,idx_nopassing)=min_min_conc.*ones(NX,length(idx_nopassing));

%do some testing plot
% figure;
% plot(1:NX,log_conc_profile_t_choice(:,168));


%reserve spaces for all the scores

%knots for fpca
breaks=[0:15:30 45:10:145 170:15:200] ;

%conduct fda analysis on curves without zero
harmscr_prediction=fda_analysis(log_conc_profile_t_choice,breaks,NX);


%plot the histogram of harmonic scores in each dimension 
figure;
for i=1:size(harmscr_prediction,2)
    subplot(3,2,i)
    hist(harmscr_prediction(:,i));
    title(['harmonic scores histogram in' blanks(2) num2str(i) 'th dimension']);
end


%get the curves that didn't break through
idx_nopassing_threshold=[];
idx_passing_threshold=[];
for i=1:size(harmscr_prediction,1)
    %if idx_nopassing is empty
    if (~isempty(idx_nopassing))
        temp=[harmscr_prediction(i,:); harmscr_prediction(idx_nopassing(1),:)];
    else
        %find the lowest value
        mean_log_conc_profile=mean(log_conc_profile_t_choice); %the mean log values for each curve(mean over sample 200) 
        min_idx_log_conc=find(mean_log_conc_profile==min(mean_log_conc_profile));
        temp=[harmscr_prediction(i,:); harmscr_prediction(min_idx_log_conc,:)];
    end
    %temp=[harmscr_prediction(i,1) harmscr_prediction(i,2)];
    dist_temp=pdist(temp,'euclidean');
    %if(temp(1)<-30 && temp(2) <-6)
    if(dist_temp<threshold_error)
        idx_nopassing_threshold=[idx_nopassing_threshold i];
        %color_code(i)=1;
        color_code_lplot{i}='r';
    else
        idx_passing_threshold=[idx_passing_threshold i];
        %color_code(i)=2;
        color_code_lplot{i}='b';
    end
end

not_polluted=length(idx_nopassing_threshold);
polluted=length(idx_passing_threshold);

PComponents_init=[not_polluted/(not_polluted+polluted) polluted/(not_polluted+polluted)];


%color by passing or no passing for the scatterplot
figure;
    for i=1:size(harmscr_prediction,1)
            plot(harmscr_prediction(i,1), harmscr_prediction(i,2), 'o', 'Color',color_code_lplot{i}, ...  % points in clusters
                'MarkerSize', 8, 'LineWidth', 1.3,'MarkerFaceColor',color_code_lplot{i}, ...
                'MarkerEdgeColor','k');
            hold on;
    end
grid off;


set(gca,'LineWidth',3)
%set(gca,'XTickLabel',{''})
%set(gca,'YTickLabel',{''})
title('fda scores distribution');

%plot the histogram of scores by groups
harmscr_prediction_nopassing=harmscr_prediction(idx_nopassing_threshold,:);

harmscr_prediction_passing=harmscr_prediction(idx_passing_threshold,:);

%calculate the inital mean values and covariance based on the grouping 

Mu_init=[mean(harmscr_prediction_nopassing);mean(harmscr_prediction_passing)];



Sigma_init(:,:,1)=cov(harmscr_prediction_nopassing);

Sigma_init(:,:,2)=cov(harmscr_prediction_passing);

figure;
title(' for cases not passing threshold');
for i=1:size(harmscr_prediction_nopassing,2)
    subplot(3,2,i)
    hist(harmscr_prediction_nopassing(:,i));
    title(['harmonic scores histogram in' blanks(2) num2str(i) 'th dimension']);
end


figure;
title(' for cases passing threshold');
for i=1:size(harmscr_prediction_passing,2)
    subplot(3,2,i)
    hist(harmscr_prediction_passing(:,i));
    title(['harmonic scores histogram in' blanks(2) num2str(i) 'th dimension ']);
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


%plot in log scale
figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
for i=1:size(conc_profile_t_choice,2)
    
    plot(1:NX,log_conc_profile_t_choice(:,i),'color',color_code_lplot{i});
    
    hold on;
end
hold off;

set(gca,'LineWidth',3)
title(['Log concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);

%plot separate figures for 2 groups 
figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
for i=1:length(idx_nopassing_threshold)
    
    plot(1:NX,conc_profile_t_choice(:,idx_nopassing_threshold(i)),'color',color_code_lplot{idx_nopassing_threshold(i)});
    
    hold on;
end
hold off;

set(gca,'LineWidth',3)
title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);


figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
for i=1:length(idx_passing_threshold)
    
    plot(1:NX,conc_profile_t_choice(:,idx_passing_threshold(i)),'color',color_code_lplot{idx_passing_threshold(i)});
    
    hold on;
end
hold off;

set(gca,'LineWidth',3)
title(['Concentration profile for different case at year' num2str(num_yr) blanks(1) 'along J=' num2str(LineofInterest)]);



end