function [PosteriorOriginalSpace,d_obs_predicted]=...
    SampleFromCCAPosterior_with_prediction(CCAOutputs,OrigianlSamples_h,OrigianlSamples_d,CycleSize)
C_posterior=CCAOutputs.C_posterior;
mu_posterior=CCAOutputs.mu_posterior;
Hc=CCAOutputs.Hc;
B=CCAOutputs.B;
G = CCAOutputs.G; % G.
A = CCAOutputs.A;
C_posterior2 = (C_posterior + C_posterior')/2;
%rng(1); % This is for checking purpose. 
PosteriorSamples = mvnrnd(mu_posterior',C_posterior2,CycleSize)'; % Sampling from Gaussians.
PosteriorSamplesTransformed = BackTransform(PosteriorSamples,Hc); % Hc is not Gaussian, so backtransform is needed.
PosteriorOriginalSpace = PosteriorSamplesTransformed'*pinv(B)+...
    repmat(mean(OrigianlSamples_h,1)',1,CycleSize)'; % H_f_posterior

% Precition with Samples

d_obs_c_predicted = G*PosteriorSamples; % Predicted.
d_obs_predicted = d_obs_c_predicted'*pinv(A)+...
    repmat(mean(OrigianlSamples_d,1)',1,CycleSize)'; % H_f_posterior




end