function [Mixed,ReconstructedCurvesSet]=PerformMixedPCA_fromFPCA(TimeStep,FDAOutput,VarProp,NumComponents)
FPCAobject=FDAOutput.FPCAobject;

NbWells=length(FPCAobject);
Mixed.ScoreRaw=[];
for k=1:NbWells
    Mixed.ScoreRaw=[Mixed.ScoreRaw,FDAOutput.FPCAobject{k}.harmscr/sqrt(FDAOutput.FPCAobject{k}.eigvals(1))];
end

rmpath('../packages/fda_matlab/')
[Mixed.coeff,Mixed.Score,Mixed.eig,~,Mixed.explained,Mixed.mu]=pca(Mixed.ScoreRaw);
Mixed.cumulative=cumsum(Mixed.explained);

if ~isempty(VarProp)
    Mixed.HowMany=find(Mixed.cumulative>=VarProp); Mixed.HowMany=Mixed.HowMany(1);
end

if ~isempty(NumComponents)
    Mixed.HowMany=NumComponents;
end

Mixed.ReducedDataSet=Mixed.Score(:,1:Mixed.HowMany);

addpath('../packages/fda_matlab/')
ReconstructedFromMixed=ReconstructFromInversePCA(Mixed.coeff,Mixed.Score,Mixed.mu,Mixed.HowMany);
ReconstructedFromMixed=reshape(ReconstructedFromMixed,size(ReconstructedFromMixed,1),[],NbWells);
clear CurveReconstructed

% Need to multiply sqrt of eigenvalue here.

for k=1:NbWells
    ReconstructedFromMixed(:,:,k)=ReconstructedFromMixed(:,:,k)*sqrt(FDAOutput.FPCAobject{k}.eigvals(1));
    
end
NbRealz=size(ReconstructedFromMixed,1);

ReconstructedCurvesSet=nan(length(TimeStep),NbWells,NbRealz);

% Reconstruct all the curves at this point.
for k=1:NbWells
    EigenFunctions=eval_fd(TimeStep,FDAOutput.FPCAobject{k}.harmfd);
    CurveReconstructed=repmat(eval_fd(TimeStep,FDAOutput.FPCAobject{k}.meanfd),1,size(ReconstructedFromMixed,1))+...
        EigenFunctions*ReconstructedFromMixed(:,:,k)';
    ReconstructedCurvesSet(:,k,:)=CurveReconstructed;
    
end





end