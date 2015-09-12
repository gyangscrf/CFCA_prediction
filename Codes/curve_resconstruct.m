function [posterior_ensenmble]=curve_resconstruct(pcastr,realization_posterior)
%construct the concentration curves based on the posterior scores
%   refer to the plot_pca function

 harmfd  = pcastr.harmfd;
  basis   = getbasis(harmfd);
  rangex  = getbasisrange(basis);
  %fdnames = getnames(harmfd);
  x       = linspace(rangex(1), rangex(2), nx);
  fdmat   = eval_fd(harmfd, x);
  meanmat = squeeze(eval_fd(pcastr.meanfd, x));
  dimfd   = size(fdmat);
  nharm   = dimfd(2);
end

