function [beta, Sigma,E,r] =ols_fitting(harmscrdata,harmscrpred)
%UNTITLED Summary of this function goes here
%   beta is the coefficients of transform 1-d
% Sigma is the estimated d-by-d variance-covariance
% E is the residuals matrix
%r is the correlation of the fitting


Y=harmscrdata;
[n,d] =size(Y);

X=cell(n,1);
%data fitting
for i=1:n
    x=harmscrpred(i,:);
    %we didn't consider interceptor
    X{i} = diag(x);
end



%beta is of length d (the transform)
%Sigma of covariance 
[beta,Sigma,E]=mvregress(X,Y);


for i=1:d
    
%Calculate the correlation 
r(i)=corr2(harmscrpred(:,i),harmscrdata(:,i));
xx = linspace(min(harmscrpred(:,i)),max(harmscrpred(:,i)))';
fits = xx.*beta(i);

figure;
%axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
subplot(2,1,1)

plot(harmscrpred(:,i),Y(:,i),'x',xx,fits,'-');
title(['OLS linear fitting in ' num2str(i) 'th dimension R^2=' num2str(r(i))]);
xlabel(['h_' num2str(i)]);
ylabel(['d_' num2str(i)]);

subplot(2,1,2)

%plot the residual
residuals=Y(:,i)-beta(i).*harmscrpred(:,i);
plot(harmscrpred(:,i),residuals,'x',xx,zeros(length(xx),1),'ro');
title(['Residues in ' num2str(i) 'th dimension ']);
xlabel(['h_' num2str(i)]);
ylabel(['d_' num2str(i) blanks(1) 'residues']);


end
end

