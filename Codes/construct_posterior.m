function [posterior_curves,x]=construct_posterior(realization_posterior,fpca)

%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
harmfd  = fpca.harmfd;
basis   = getbasis(harmfd);
rangex  = getbasisrange(basis);
nx=101;
 x       = linspace(rangex(1), rangex(2), nx);
fdmat   = eval_fd(harmfd, x);
meanmat = squeeze(eval_fd(fpca.meanfd, x));
%dimension of the fdmat
dimfd   = size(fdmat);
nharm   = dimfd(2);

harm = (1:nharm);

for i=1:size(realization_posterior,1)
    %fac 
    conc_curve=meanmat;
    for iharm = harm
          vecharm = fdmat(:,iharm);
          conc_curve  = conc_curve+realization_posterior(i,iharm).*vecharm;
    end
    posterior_curves(:,i)=10.^conc_curve-0.01;
   
    posterior_curves(find(posterior_curves(:,i)<0),i)=0;
end




end

