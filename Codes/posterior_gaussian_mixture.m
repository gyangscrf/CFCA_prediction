function [Mu_hpost,Sigma_hpost,polluted_post,not_polluted_post,G]=posterior_gaussian_mixture(Mu_pred,Sigma_pred,dobs,beta_c,Sigma_residuals,A,B,PComponents_init,mean_not_polluted)

%update the posterior mean and covariance 
%   Detailed explanation goes here

G=inv(A')*diag(beta_c)*B';
% %the G matrix 
% G=B*diag(beta_c)*inv(A);


temp=inv((G*Sigma_pred*G'+Sigma_residuals));

%Mu and Sigma in the s space
Mu_hpost=Mu_pred'+ Sigma_pred* G'*temp*(dobs'-G*Mu_pred');

Sigma_hpost=Sigma_pred-Sigma_pred*G'*temp*G*Sigma_pred;

%function to use bayesian probability (we will implement this later)
likelihood_polluted=exp(-1/2*(inv(G)*dobs'-Mu_pred')'*inv(Sigma_pred)*(inv(G)*dobs'-Mu_pred'));

%how to calculate the covariance of the non-breakthrough group
%use the polluted sigma to replace the not polluted sigma
likelihood_notpolluted=exp(-1/2*(inv(G)*dobs'-mean_not_polluted')'*inv(Sigma_pred)*(inv(G)*dobs'-mean_not_polluted'));
%use a small covariance sigma (address how to deal with this issue)
%likelihood_notpolluted=exp(-1/2*(inv(G)*dobs-mean_not_polluted')'*inv(diag(ones(length(Mu_pred),1))*1e-4)*(inv(G)*dobs-mean_not_polluted'));

polluted_post=likelihood_polluted*PComponents_init(2)/(likelihood_polluted*PComponents_init(2)+likelihood_notpolluted*PComponents_init(1));
not_polluted_post=1-polluted_post;


%fixing the non-positve issue
Sigma_hpost = (Sigma_hpost + Sigma_hpost.') / 2;



end

