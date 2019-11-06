function DisplayZSliceFrom3D(sub_ny,ResultMatrix,WhatToSee,DimX,DimY,DimZ,ZSlicesIndicies,caxisvalue,ProdCoord,ProdName)
% This follows ECLIPSE coordinates system.
Data_Partial=ResultMatrix(WhatToSee,:); % Take the data that we want to visualize.
DimZ_check=length(Data_Partial(1,:))/DimX/DimY;

if DimZ~=DimZ_check
    error('dimensions are not correct')
end

for k=1:size(Data_Partial,1)
    Datak=reshape(Data_Partial(k,:),[DimX,DimY,DimZ]);
    Datak_sliced=Datak(:,:,ZSlicesIndicies);
    sub_nx=ceil(length(ZSlicesIndicies)/sub_ny);
    %sub_ny=1;
    figure;
    %ha = tight_subplot(sub_ny,sub_nx,[.001 .05]);
    %ha = tight_subplot(sub_ny,sub_nx,[.01 .1],[.0001 .000001],[.01 .01]);
    
    for j=1:length(ZSlicesIndicies)
        subplot(sub_ny,sub_nx,j)
        %tight_subplot(sub_nu)
        %axes(ha(j));        
        imagesc(Datak_sliced(:,:,j)'); c = colorbar;
        if nargin>7
            caxis(caxisvalue); 
            c.Label.String = 'log Perm. (ln-md)';
        end
        hold on;
        set(gca,'xtick',[]);set(gca,'ytick',[])
%        title(['Model ',num2str(k),' z= ',num2str(ZSlicesIndicies(j))],'Fontsize',16)
        title(['layer ',num2str(ZSlicesIndicies(j))],'Fontsize',16)
        %title(['EI ',num2str(ZSlicesIndicies(j))],'Fontsize',16)
        %title(['EigenImage ',num2str(k)],'Fontsize',24)
        %title(['EigenImage ',num2str('100')],'Fontsize',24)
        set(gca,'Fontsize',14);
        axis equal tight
        % caxis added here. 
        %colorbar;caxis(caxisvalue)
        if j==1 && nargin>8 % changed from 7 to 8
            for jj=1:size(ProdCoord,1)
                plot(ProdCoord(jj,1),ProdCoord(jj,2),'x','MarkerSize',20,'Color','r')
                text(ProdCoord(jj,1)+10,ProdCoord(jj,2),ProdName{jj},'Fontsize',20);
            end
        end
        
    end
    
    
    
    
    
    
end


hold off;


end