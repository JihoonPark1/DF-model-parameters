function [sen,insen,sensindex,insensindex]=split_by_sensitivityRank(X,maineffects,Num2Choose)
if size(X,2)~=length(maineffects)
    error('Dim does not match')
end

[~,indexsorted]=sort(maineffects,'descend');

sensindex = indexsorted(1:Num2Choose);
insensindex = indexsorted(Num2Choose+1:end);

sen = X(:,sensindex);
insen= X(:,insensindex);


end