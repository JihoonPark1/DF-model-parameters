function CompareDistributionHistograms_Two(A,B,HowManyTake,nrow,ref,LegendLabel,PCLabels)

[~,kA]=size(A);
[~,kB]=size(B);



if isempty(HowManyTake)
    HowManyTake=kA;
end

ncol=ceil(HowManyTake/nrow);

figure; hold on;

for k=1:HowManyTake
    subplot(nrow,ncol,k); hold on;
    % First get the historgram. 
    
    h1 = histogram(A(:,k),'FaceColor',[.5,.5,.5],'Normalization','probability','NumBins',20);
    h2 = histogram(B(:,k),'FaceColor',[0,0,1],'Normalization','probability','EdgeColor','w','FaceAlpha',.6,'NumBins',20);
    
    % Plotting reference should be later.
    
   
    %h3 = line([ref(k),ref(k)],[0,hh(2)],'LineWidth',3,'Color',[1,0,0]);
    
    
    if ~isempty(ref)
        aa = get(gca);hh=aa.YLim;
        h3 = line([ref(k),ref(k)],[0,hh(2)],'LineWidth',3,'Color',[1,0,0]);    
    end
    
    if nargin<7
        title(['PC',num2str(k)],'Fontsize',16);
    else
        title(PCLabels{k},'FOntsize',16);
    end
    
    if k==1
        if length(LegendLabel) == 3
            legend([h1,h2,h3],LegendLabel,'Location','Best','Fontsize',14);
        else
            legend([h1,h2],LegendLabel,'Location','Best','Fontsize',14);
        end
    end
    
    set(gca,'Fontsize',13);
    xlim([min(A(:,k)),max(A(:,k))]);
    
%     
%     
%     
%     
%     
% 
%     
%     
%     %[fA,xA]=ksdensity(A(:,k));[fB,xB]=ksdensity(B(:,k));%,'Support',[min(A(:,k)),max(A(:,k))]); % Modified on 11 April 2018
%     
%     % Truncation Part. Do not use support.
% %     idxxB=find(B(:,k)>min(A(:,k)) & B(:,k)<max(A(:,k)));
% %     fB=fB(idxxB);
% %     xB=xB(idxxB);
%     % normalize this. 
%  %   Integrals=trapz(xB,fB);
%   %  fB=fB/Integrals;
%     
%     subplot(nrow,ncol,k); hold on;
%     h1=plot(xA,fA,'LineWidth',3,'Color','k'); 
%     h2=plot(xB,fB,'LineWidth',3,'Color','b');hold off
%     if nargin>4
%         aa=get(gca);hh=aa.YLim;
%         h3=line([ref(k),ref(k)],[0,hh(2)],'LineWidth',3,'Color',[1,0,0]);
%     end    
%     if nargin<6
%         title(['PC',num2str(k)],'Fontsize',16);
%     else
%         title(PCLabels{k},'FOntsize',16);
%     end
%     
%     if k==1
%         if nargin>4
%             legend([h1,h2,h3],{'Prior','Posterior','Reference'},'Location','Best');            
%         else
%             legend([h1,h2],{'Prior','Posterior'}); 
%         end
%     end
%     
%    set(gca,'Fontsize',13);
    
    
end



end