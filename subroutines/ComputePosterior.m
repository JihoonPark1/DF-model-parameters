function [mu_posterior, C_posterior,G,Dc,Hc,DcPredicted,dobs_c,C_T,DDiff]=ComputePosterior(X,CCAOutputs,dobs_original)
% dobs_c must be on the cca space.
Dc=CCAOutputs.U;
Hc=CCAOutputs.V;

dobs_c=(dobs_original-mean(X))*CCAOutputs.A;

Hc_gauss = NormalScoreTransform(Hc,0);
C_H = cov(Hc_gauss);
H_CG_Mean = mean(Hc_gauss)';
G = Dc'/Hc_gauss';
DcPredicted=G*Hc_gauss';DcPredicted=DcPredicted';

DDiff= Dc'-G*Hc_gauss';
C_T = DDiff*DDiff'/length(Dc);
mu_posterior = H_CG_Mean + C_H*G'*pinv(G*C_H*G' + C_T)*(dobs_c'-G*H_CG_Mean);
C_posterior = inv(G'*pinv(C_T)*G + inv(C_H));


end