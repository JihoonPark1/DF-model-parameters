function [History,Simulated]=SplitDataObservedSimulated(DataAll,ReferenceNumber)
% The function splits the data array into history and simulated values. 
%
NbRealz=size(DataAll,3);
%% Initializations 
SimulatedIndex=1:NbRealz; 
SimulatedIndex=setdiff(SimulatedIndex,ReferenceNumber);

%% Assign.
History=DataAll(:,:,ReferenceNumber);
Simulated=DataAll(:,:,SimulatedIndex);


end