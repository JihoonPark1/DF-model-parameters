function PlotFlowResponses_with_sampling(TimeStep,WellNames,SimulatedValues,HistoricalValues,nRows,...
    QuantilesOn,YLabelText,NumSamples,seed,Figsize)


NbWells=length(WellNames);
nCols=ceil(NbWells/nRows);
NbRealz=size(SimulatedValues,3);

rng(seed); 
indiciesSampled = randsample(1:NbRealz,NumSamples);

figure;

for k=1:NbWells
    subplot(nRows,nCols,k); hold on;
    
    for k2=1:length(indiciesSampled)
        h1=plot(TimeStep,SimulatedValues(:,k,indiciesSampled(k2)),'Color',[.5,.5,.5]);
    end
    
    if QuantilesOn
        QuanitlesToPlot=quantile(permute(SimulatedValues(:,k,:),[3,1,2]),[.1,.5,.9]);
        for j=1:3
            plot(TimeStep,QuanitlesToPlot(j,:),'k','LineWidth',3)
        end
        
    end
    
    h2=plot(TimeStep,HistoricalValues(:,k),'Color','r','LineWidth',4);
    set(gca,'Fontsize',14); xlabel('Time(Day)','Fontsize',16); ylabel(YLabelText,'Fontsize',16);
   
    title(WellNames{k},'Fontsize',18);

    xlim([TimeStep(1),TimeStep(end)])
    if strcmp(YLabelText,'WATERCUT') || strcmp(YLabelText,'watercut')   
        ylim([0,1]);
    end


    
end

    legend([h1,h2],{'Prior','Reference'},'Fontsize',16,'Location','northeastoutside')
    set(gcf,'Position',Figsize);


end
