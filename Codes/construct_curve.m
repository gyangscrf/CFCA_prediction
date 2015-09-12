function [conc_curve]=construct_curve(pred_obs,fpca,fpcaObj)
%UNTITLED2 Summary of this function goes here
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

%fac 
conc_curve=meanmat;
for iharm = harm
      vecharm = fdmat(:,iharm);
      conc_curve  = conc_curve+pred_obs(iharm).*vecharm;
end

 %axis handle
axes('FontSize',12,'FontWeight','b');hold on;box on;
plot(x, 10.^conc_curve,   '-');


end

