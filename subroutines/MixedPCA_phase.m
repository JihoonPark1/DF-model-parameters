function Mixed = MixedPCA_phase(MixedStruct,VarProp,NumComponents)

n_phase = length(MixedStruct);
Mixed.ScoreRaw=[];
for k=1:n_phase
    Mixed.ScoreRaw=[Mixed.ScoreRaw,MixedStruct(k).Score/sqrt(MixedStruct(k).eig(1))];
end

[Mixed.coeff,Mixed.Score,Mixed.eig,~,Mixed.explained,Mixed.mu]=pca(Mixed.ScoreRaw);
Mixed.cumulative=cumsum(Mixed.explained);
if ~isempty(VarProp)
    Mixed.HowMany=find(Mixed.cumulative>=VarProp); Mixed.HowMany=Mixed.HowMany(1);
end

if ~isempty(NumComponents)
    Mixed.HowMany=NumComponents;
end

Mixed.ReducedDataSet=Mixed.Score(:,1:Mixed.HowMany);


end