function [PosteriorMatFiltered, IndiciesToRemove]=RemoveSamplesViolatingPriors(PriorMat,PosteriorMat)
if size(PriorMat,2)~=size(PosteriorMat,2)
    error('dim does not match')
end
NumVars=size(PriorMat,2);
minsPrior=min(PriorMat);
maxsPrior=max(PriorMat);
IndiciesToRemove=[];
for k=1:NumVars    
    kthVars=PosteriorMat(:,k);
    SmallersIndicies=find(kthVars<=minsPrior(k)); SmallersIndicies=SmallersIndicies(:);
    LargersIndicies=find(kthVars>=maxsPrior(k)); LargersIndicies=LargersIndicies(:);
    IndiciesToRemove=[IndiciesToRemove;SmallersIndicies;LargersIndicies];
    
end

PosteriorMatFiltered=PosteriorMat;
PosteriorMatFiltered(unique(IndiciesToRemove),:)=[]; % Delete.

end