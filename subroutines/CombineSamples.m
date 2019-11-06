function [GlobalParameters,SpatialParameters]=CombineSamples(SensMat,InsensMat,SenIndex,InSenIndex,HowManyGlobals)
[n1,k1]=size(SensMat);
[n2,k2]=size(InsensMat);

if length(SenIndex)~=k1
    error('length does not match');
end

if length(InSenIndex)~=k2
    error('length does not match');
end

if n1~=n2
    error('sample size does not match');
end

Y = nan(n1,k1+k2);
Y(:,SenIndex) = SensMat;
Y(:,InSenIndex) = InsensMat;

GlobalParameters = Y(:,1:HowManyGlobals);
SpatialParameters = Y(:,HowManyGlobals+1:end);

end