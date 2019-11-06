function PlotAllResponse_Prior_PostQuantiles...
    (TimeStep,WellNames,SimulatedValuesPrior,SimulatedValuesPosterior,GreenOn, HistoricalValues,nRows,QuantilesOn,YLabelText,Figsize)
% if nargin<8
%     QuantilesOn=true;
% end

NbWells=length(WellNames);
nCols=ceil(NbWells/nRows);
NbRealz=size(SimulatedValuesPrior,3);

figure;
rng(134); 
indiciesSampled = randsample(1:NbRealz,300);

for k=1:NbWells
    subplot(nRows,nCols,k); hold on;
    
    for k2=1:length(indiciesSampled)
        h11=plot(TimeStep,SimulatedValuesPrior(:,k,k2),'Color',[.5,.5,.5]);
    end
    
    if GreenOn
        NbRealzPost = size(SimulatedValuesPosterior,3);
        for k2=1:NbRealzPost
            h13=plot(TimeStep,SimulatedValuesPosterior(:,k,k2),'Color',[0,1,0]);
        end
    end
    
    
    if QuantilesOn
        %         QuanitlesToPlot=quantile(permute(SimulatedValuesPrior(:,k,:),[3,1,2]),[.1,.5,.9]);
        %         for j=1:3
        %             h1=plot(TimeStep,QuanitlesToPlot(j,:),'k','LineWidth',3);
        %         end
        QuanitlesToPlot=quantile(permute(SimulatedValuesPosterior(:,k,:),[3,1,2]),[.1,.5,.9]);
        for j=1:3
            h2=plot(TimeStep,QuanitlesToPlot(j,:),'b--','LineWidth',3);
        end
        
    end
    
    xlim([TimeStep(1),TimeStep(end)]);
    h3=plot(TimeStep,HistoricalValues(:,k),'Color','r','LineWidth',4);
    set(gca,'Fontsize',14); xlabel('Time(Day)','Fontsize',16);
    title(WellNames{k},'Fontsize',18);
    
    if strcmp(YLabelText,'WATERCUT') || strcmp(YLabelText,'watercut')
        ylim([0,1]);
    end
    
    %ylim([0,1000]);
    ylabel(YLabelText,'Fontsize',16);
    
end
% Put the legend at the end only
legend([h11,h2,h3],{'Prior','Posterior','Reference'},'Fontsize',14,'Location','Best');
set(gcf,'Position',Figsize);
end
