function Sampled=SampleFromEmpiricalDistribution(ReferenceMat,Nsamples,seednum)
Sampled=nan(Nsamples,size(ReferenceMat,2));
rng(seednum)

for k=1:size(ReferenceMat,2)
% Added 
	if mod(k,100)==0
		fprintf('%s dim. sampling is completed\n',num2str(k));
	end
		
    [F,X] = ecdf(ReferenceMat(:,k));
    u=rand(Nsamples,1); %
    Sampledk=interp1(F,X,u);
    Sampled(:,k)=Sampledk;
   
end
end