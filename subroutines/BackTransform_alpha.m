function Reconstructed_m_total=BackTransform_alpha(alphas,PCAInfo_Field)
% This function takes alpha and gives the corresponding field that is ready
% to run the flow simulations & realisitic visualization.
% For now, this assumes that they are already 
% A lot of functions are from Decompose_m.
% Later, it maybe extended to give options.... for example, fix it to the
% mean values 

NumRealz=size(alphas,1);
DimsToRecover=size(alphas,2);

Reconstructed_m_total=ReconstructFromInversePCA...
    (PCAInfo_Field.coeff_All,alphas,PCAInfo_Field.mu,DimsToRecover); 
% Field was standardized before. so need to reconstruct. Maybe be this may
% need to be an input as well. 
Reconstructed_m_total=Reconstructed_m_total.*repmat(PCAInfo_Field.sigmazscore,NumRealz,1)+repmat(PCAInfo_Field.muzscore,NumRealz,1);


end