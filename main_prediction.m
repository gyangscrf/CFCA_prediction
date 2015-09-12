%example for prediction
close all; clear all; clc

%add the code directory to path
addpath('Codes');
addpath('fda_matlab');

%load in the order of processing(since the simulation is conduct in random
%order)
output_order='Result/order';
order=load(output_order);

%load the concentration distribution at NX=120;
%this is the prediction 
LineofInterest=120;
conc_profile_name=['Result/concsum_Line' num2str(LineofInterest)];
conc_profile_sum_ofinterest=load(conc_profile_name);

%choose the year of prediction 
yr_of_interest=20;

%thresholding non-breakthrough and breakthrough
%also getting harmonic scores for prediciton 
cut_threshold=0.01;

%number of record_locations in the curves (this should be changed by the
%number of monitoring wells along the line
Num_records=200;

%centers of the basis function, more dense in the center
%this is user defined
knots=[0:20:40 45:5:155 160:20:200] ;

%getting the harmonics and make some plots 
[harmscrpred_polluted,not_polluted_pred,polluted_pred,fpca,fpcaObj]= plot_fdasc_cut_threshold(conc_profile_sum_ofinterest,yr_of_interest,LineofInterest,cut_threshold,Num_records,knots);

NX=200;
%get the scores of very small polluted profile
conc_profile_not_polluted_ofinterest=conc_profile_sum_ofinterest((yr_of_interest-1)*NX+1:yr_of_interest*NX,polluted_pred);

%find the max 
max_conc_not_polluted_ofinterest=max(conc_profile_not_polluted_ofinterest);
%find the minimum values of maximum pollution values in the curves 
[min_max_conc_not_polluted,idx_min_max]=min(max_conc_not_polluted_ofinterest);
%get the scores of not polluted(almost), this serves as the mean for not
%polluted curves
mean_not_polluted=harmscrpred_polluted(idx_min_max,:);
harmscrpred_notpolluted=repmat(mean_not_polluted,length(not_polluted_pred),1);

%fill the scores (harmscrpred is number_relizations* number of eigenfunctions)
harmscrpred(polluted_pred,:)=harmscrpred_polluted;
%the scores of not polluted should not be all zeros, but some values
%devoiated from the mean 
harmscrpred(not_polluted_pred,:)=repmat(mean_not_polluted,length(not_polluted_pred),1);

%get the ratio between the polluted versus not polluted
not_polluted=length(not_polluted_pred);
polluted=length(polluted_pred);
PComponents_init=[not_polluted/(not_polluted+polluted) polluted/(not_polluted+polluted)];

%% Plot the harmonic scores of prediction and mean, cov of the scores
PlotScores_bygroup(harmscrpred_polluted,harmscrpred_notpolluted);

% %multivariate transform (right now is only univariate transform)
% [harmscrpred_transformed,lamda_transformed,constant_transform]=mvgtransform(harmscrpred_polluted);
% figure;
% gkde2(harmscrpred_transformed(:,1:2));
% kernel_2dpdf(harmscrpred_transformed);
% %plot the transformed scores
% PlotTransformed(harmscrpred_transformed);

%get the means and covariance of the polluted case
Mu_pred=mean(harmscrpred_polluted);
Sigma_pred=cov(harmscrpred_polluted);



%% Repeat the same process for data
%first transform the fpca score feature space to canonical function space
%(Would also use the data, because G is constructed based on dc and hc)
%get the scores for the data
LineofData=100;

conc_profile_data_name=['Result/concsum_Line' num2str(LineofData)];
conc_profile_sum_ofdata=load(conc_profile_data_name);

%% get the harmonic scores for the data
%make functions to get the harmsc and also make plots colored by
%breakthrough or not
yr_of_data=10;
%the thresholding would be an optimization problem for best estimation
%of two groups
cut_threshold=0.01;
%thresholding and then make log transform
[harmscrdata_polluted,not_polluted_data,polluted_data,fpca_data,fpcaObj_data]= plot_fdasc_cut_threshold(conc_profile_sum_ofdata,yr_of_data,LineofData,cut_threshold,Num_records,knots );

%get the scores of very small polluted profile
conc_profile_not_polluted_ofdata=conc_profile_sum_ofdata((yr_of_data-1)*NX+1:yr_of_data*NX,polluted_data);
%find the max 
max_conc_not_polluted_ofdata=max(conc_profile_not_polluted_ofdata);

[min_max_conc_not_polluted_data,idx_min_max_data]=min(max_conc_not_polluted_ofdata);
%get the scores of not polluted(almost), this serves as the mean for not
%polluted curves
mean_not_polluted_data=harmscrdata_polluted(idx_min_max_data,:);
harmscrdata_notpolluted=repmat(mean_not_polluted_data,length(not_polluted_data),1);

%fill the scores
harmscrdata(polluted_data,:)=harmscrdata_polluted;
%the scores of not polluted should not all zeros
harmscrdata(not_polluted_data,:)=repmat(mean_not_polluted_data,length(not_polluted_data),1);

%color by passing or no passing for the scatterplot
PlotScores_bygroup(harmscrdata_polluted,harmscrdata_notpolluted);

%% building relationship between d and h
%find the common case numbers for data and pred (that both breakthrough)
commoncasenum=intersect(polluted_pred,polluted_data);
%find the union for prediction and data (either that breakthrough in data or pred)
unionnum=union(polluted_pred,polluted_data); 

%choose a data outside of the commoncasenum 
dynamic_set_data=setdiff(polluted_data,commoncasenum);
dynamic_set_pred=setdiff(polluted_pred,commoncasenum);

%this obs_number in prediction didn't necessarily breakthrough
%from the data that breakthroughs but not breakthrough in prediction
%obs_number=dynamic_set_data(round(rand(1)*length(dynamic_set_data)));

%from the prediction that breakthrough but did not breakthrough in data
%obs_number=dynamic_set_pred(round(rand(1)*length(dynamic_set_pred)));

%sample one from the commoncasenum (where in both h and d polluted)
%obs_number=commoncasenum(round(rand(1)*length(commoncasenum)));

%specify a very special one (for the linear change case) 
obs_number=105; %(the case that breakthrough in the prediction)

%% study only cases pollution happened both in data and prediction
%index for the commoncasenum (fitting only using the 3rd group)
for i=1:length(commoncasenum)
    data_index_commoncase(i)=find(polluted_data==commoncasenum(i));
    pred_index_commoncase(i)=find(polluted_pred==commoncasenum(i));
end

save('data_index_commoncase.dat','data_index_commoncase','-ascii')
save('pred_index_commoncase.dat','pred_index_commoncase','-ascii');

%find the scores in the common groups
harmscrpred_forfitting=harmscrpred_polluted(pred_index_commoncase,:);
harmscrdata_forfitting=harmscrdata_polluted(data_index_commoncase,:);

%construct the canonical transform
[A B r U V] = canoncorr(harmscrdata_forfitting,harmscrpred_forfitting);

%plot the scores in feature space
%only consider the commoncasenum
figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
scatter(harmscrdata_forfitting(:,1),harmscrpred_forfitting(:,1),60,'bo','filled')
xlabel('d_1^f');
ylabel('h_1^f');
title('d to h relationship after dimension reduction');

figure;
%axis handle
axes('FontSize',20,'FontWeight','b');hold on;box on;
scatter(U(:,1),V(:,1),60,'bo','filled')
xlabel('d_1^c');
ylabel('h_1^c');
title('d to h relationship after canonical transform');


%ordinary least squre linear fitting
%[beta_f,Sigma_f,residuals_f,r_f]=ols_fitting(harmscrdata_forfitting,harmscrpred_forfitting);
%ordinary least squre linear fitting in the canonical function space
[beta_c,Sigma_c,residuals_c,r_c]=ols_fitting(U,V);

%evalute the covaraince of the residuals
Sigma_residuals=cov(residuals_c);

%transform the obs score
%find the index in the polluted data
idx_dobs=find(polluted_data==obs_number);
%if the obs_number is not in the polluted group(in this example, we
%explictly made it to be in the pollluted group)
if isempty(idx_dobs)
    idx_dobs=find(not_polluted_data==obs_number);
    %get the dobs value in the canoncial space 
    dobs=(harmscrdata_notpolluted(idx_dobs,:)-mean(harmscrdata_forfitting))*A;
else
    %get the dobs value in the canoncial space 
    dobs=(harmscrdata_polluted(idx_dobs,:)-mean(harmscrdata_forfitting))*A;
end
%% Plotting again
%plot the dobs scores in the canonical space
y_vector=-6:4;
PlotScores_Canonical(U,V,dobs,y_vector);

%plot the data and prediction 
%data
curve_data=conc_profile_sum_ofdata(NX*(yr_of_data-1)+1:NX*yr_of_data, obs_number);
%prediction
curve_prediction=conc_profile_sum_ofinterest(NX*(yr_of_interest-1)+1:NX*yr_of_interest, obs_number);
PlotCurve_datavspred(curve_data,curve_prediction,NX);

%% which scores should be used in the calculation? (need to do maths derivition )
%mean for transform
% Mean_data=mean(harmscrdata_forfitting);
% Mean_pred=mean(harmscrpred_forfitting);

% Mu_pred=mean(V);
% Sigma_pred=cov(V);

%mean of not polluted
%mean_not_polluted=(mean_not_polluted-mean(harmscrpred_forfitting))*B;

%calculate the posterior (we need A,B to transform back to the feature space)
%need to review that I did the right thing
[Mu_hpost,Sigma_hpost,polluted_post,not_polluted_post,G]=posterior_gaussian_mixture(Mu_pred,Sigma_pred,dobs,beta_c,Sigma_residuals,A,B,PComponents_init,mean_not_polluted);

%% sample use the posterior mean and covariance 
%plot the posterior pdf
sample_posterior=mvnrnd(Mu_hpost,Sigma_hpost,1000);
%kernel_2dpdf(sample_posterior);
%illustration purposes
[sample_posterior_curves,xsamples]=construct_posterior(sample_posterior,fpca);


%plot comparison with the true model and the prior
prior_posterior_comparison(conc_profile_sum_ofinterest,obs_number,sample_posterior_curves,xsamples);

