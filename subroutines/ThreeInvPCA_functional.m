function [ReconstructedCurvesSet_Oil,ReconstructedCurvesSet_Wat]=...
    ThreeInvPCA_functional(PriorDataOil,PriorDataWat, Prior1Mixed, ...
    WellNamesData,TimeStepData,OilMixed,WatMixed,FDAOutput_oil_data, ...
    FDAOutput_water_data,ReferenceNumber,PlotOn)


addpath('../packages/fda_matlab/')

NumPhase = 2;

NbWellsData = length(WellNamesData);

ReconstructedFromMixed=ReconstructFromInversePCA(Prior1Mixed.coeff,Prior1Mixed.Score,Prior1Mixed.mu,Prior1Mixed.HowMany);
NumOil = size(OilMixed.Score,2); NumWat = size(WatMixed.Score,2); 

ReconstructedFromMixed_Oil = ReconstructedFromMixed(:,1:NumOil);
ReconstructedFromMixed_Wat = ReconstructedFromMixed(:,NumOil+1:end); 
ReconstructedFromMixed_Oil = ReconstructedFromMixed_Oil*sqrt(OilMixed.eig(1));
ReconstructedFromMixed_Wat = ReconstructedFromMixed_Wat*sqrt(WatMixed.eig(1));

ReconstructedFromMixed_Oil = ...
    ReconstructFromInversePCA(OilMixed.coeff,ReconstructedFromMixed_Oil,OilMixed.mu,OilMixed.HowMany);
ReconstructedFromMixed_Wat = ...
    ReconstructFromInversePCA(WatMixed.coeff,ReconstructedFromMixed_Wat,WatMixed.mu,WatMixed.HowMany);

ReconstructedFromMixed_Oil=reshape(ReconstructedFromMixed_Oil,size(ReconstructedFromMixed_Oil,1),[],NbWellsData);
ReconstructedFromMixed_Wat=reshape(ReconstructedFromMixed_Wat,size(ReconstructedFromMixed_Wat,1),[],NbWellsData);

for k=1:NbWellsData 
    ReconstructedFromMixed_Oil(:,:,k)=ReconstructedFromMixed_Oil(:,:,k)*sqrt(FDAOutput_oil_data.FPCAobject{k}.eigvals(1));
    ReconstructedFromMixed_Wat(:,:,k)=ReconstructedFromMixed_Wat(:,:,k)*sqrt(FDAOutput_water_data.FPCAobject{k}.eigvals(1));
end

NbRealz=size(ReconstructedFromMixed,1);

ReconstructedCurvesSet_Oil=nan(length(TimeStepData),NbWellsData,NbRealz);
ReconstructedCurvesSet_Wat=nan(length(TimeStepData),NbWellsData,NbRealz);

% Reconstruct all the curves at this point.
for k=1:NbWellsData 
    EigenFunctionsOil=eval_fd(TimeStepData,FDAOutput_oil_data.FPCAobject{k}.harmfd);
    EigenFunctionsWat=eval_fd(TimeStepData,FDAOutput_water_data.FPCAobject{k}.harmfd);
    CurveReconstructedOil=repmat(eval_fd(TimeStepData,FDAOutput_oil_data.FPCAobject{k}.meanfd),1,size(ReconstructedFromMixed_Oil,1))+...
        EigenFunctionsOil*ReconstructedFromMixed_Oil(:,:,k)';
    CurveReconstructedWat=repmat(eval_fd(TimeStepData,FDAOutput_water_data.FPCAobject{k}.meanfd),1,size(ReconstructedFromMixed_Wat,1))+...
        EigenFunctionsWat*ReconstructedFromMixed_Wat(:,:,k)';
    
    ReconstructedCurvesSet_Oil(:,k,:)=CurveReconstructedOil;
    ReconstructedCurvesSet_Wat(:,k,:)=CurveReconstructedWat;
    
end

if PlotOn
    Plot_CompareChosenModels(TimeStepData,WellNamesData,PriorDataOil,ReconstructedCurvesSet_Oil,[ReferenceNumber],2,{'Original','Reconst.'});
    FigSizeResp = [319 215 1245 642];
    %set(gcf,'Position',[281 246 1272 656]);
    set(gcf,'Position',FigSizeResp);
    Plot_CompareChosenModels(TimeStepData,WellNamesData,PriorDataWat,ReconstructedCurvesSet_Wat,[ReferenceNumber],2,{'Original','Reconst.'});
    %set(gcf,'Position',[281 246 1272 656]);
    set(gcf,'Position',FigSizeResp);
end

rmpath('../packages/fda_matlab/');
end