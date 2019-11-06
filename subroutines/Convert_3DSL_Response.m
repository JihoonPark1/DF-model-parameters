function [Y,TimeGrid]=Convert_3DSL_Response(Data,idx,WellNames,ReferenceTimeStep,TimeIndex)
% Author: Jihoon Park

% Convert the raw data from 3DSL and run interporlation.

NbRealz=length(Data);
NbWells=length(WellNames);

TimeGrid=ReferenceTimeStep;

Y=nan(length(TimeGrid),NbWells,NbRealz); % Initialize the array.
for k=1:NbRealz

    for j=1:NbWells

        data_kj=Data{k}.(WellNames{j});
        Y(:,j,k)=interp1(data_kj(:,TimeIndex),data_kj(:,idx),TimeGrid);
        
    end
end
end