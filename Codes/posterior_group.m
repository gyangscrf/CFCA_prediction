function [pgroup_posterior]=posterior_group(P_groups,G,dobs,Mean_gp1pred,Sigma_gp1pred,Mean_gp2pred,Sigma_gp2pred,Mean_gp3pred,Sigma_gp3pred);

%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%function to use bayesian probability (we will implement this later)
likelihood(1)=exp(-1/2*(inv(G)*dobs'-Mean_gp1pred')'*inv(Sigma_gp1pred)*(inv(G)*dobs'-Mean_gp1pred'));

%how to calculate the covariance of the non-breakthrough group
%use the polluted sigma to replace the not polluted sigma
likelihood(2)=exp(-1/2*(inv(G)*dobs'-Mean_gp2pred')'*inv(Sigma_gp1pred)*(inv(G)*dobs'-Mean_gp2pred'));

%group 3
likelihood(3)=exp(-1/2*(inv(G)*dobs'-Mean_gp3pred')'*inv(Sigma_gp3pred)*(inv(G)*dobs'-Mean_gp3pred'));
%use a small covariance sigma (address how to deal with this issue)
%likelihood_notpolluted=exp(-1/2*(inv(G)*dobs-mean_not_polluted')'*inv(diag(ones(length(Mu_pred),1))*1e-4)*(inv(G)*dobs-mean_not_polluted'));

%the posterior probability
for i=1:3
    pgroup_posterior_temp(i)=likelihood(i)*P_groups(i);
end

for i=1:3
    pgroup_posterior(i)=pgroup_posterior_temp(i)/sum(pgroup_posterior_temp);
end

end

