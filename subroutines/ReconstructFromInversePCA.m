function R=ReconstructFromInversePCA(coeff,score,mu,dimen,sig)
% Author: Jihoon Park (jhpark3@stanford.edu)
% The code performes reconstruction of data from the results of PCA.

if nargin<5
    sig=ones(1,length(mu));
end

sig=sig(:); sig=sig';

score=score(:,1:dimen);
coeff=coeff(:,1:dimen);
n=size(score,1);

Xcentered = score*coeff';
% Variance part.
Xcentered=Xcentered.*repmat(sig,n,1);

mu=mu(:);mu=mu';
mu_r=repmat(mu,n,1);

R=mu_r+Xcentered;

end