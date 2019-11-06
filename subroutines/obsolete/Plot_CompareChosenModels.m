function Plot_CompareChosenModels(TimeStep,WellNames,A,B,ChosenIndex,nRows,legendlabel)
% A: One Set of responses.
% B: Other set of responsese
NbWells=length(WellNames);
nCols=ceil(NbWells/nRows);

NumChosens=length(ChosenIndex);
for j=1:NumChosens
    figure; clf;
    for k=1:NbWells
        subplot(nRows,nCols,k); hold on;
        h1=plot(TimeStep,A(:,k,ChosenIndex(j)),'.','LineWidth',3,'Color','r','Markersize',20);
        h2=plot(TimeStep,B(:,k,ChosenIndex(j)),'LineWidth',3,'Color','b');
        
        %ylim([0,1]);
        title(WellNames{k},'Fontsize',16)
        set(gca,'Fontsize',14); xlabel('Time(Day)','Fontsize',16);%ylabel('WOPT(bbl)','Fontsize',16);
        ylabel('WOPT(bbl)','Fontsize',16);
        if nargin>6 && k==NbWells
            legend(legendlabel,'Fontsize',16,'location','Best');
        end
    
    end
end

end