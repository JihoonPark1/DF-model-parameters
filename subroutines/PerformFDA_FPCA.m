function FDAOutput=PerformFDA_FPCA(FDAInput,TimeStep,ResponseArray,...FD
    Index2Visualize,nRows,WellNames,ReconstructionPloton,ylabeltxt)
% Frist, make the input deck.

FDAOutput.emptyBasis=create_bspline_basis...
    ([FDAInput.StartTime FDAInput.EndTime], FDAInput.nbasis, FDAInput.norder);
figure;
plot(FDAOutput.emptyBasis);
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
set(gca,'Fontsize',16);

title([ 'Order: ' num2str(FDAInput.norder) ' With ' ...
            num2str(FDAInput.nknots) ' Knots Basis B-Splines'],'FontSize',20);
xlabel('Time (Days)');
axis tight;

set(gcf, 'Units', 'normalized', 'Position', [0.2,0.2,0.6,0.6]);

set(gca,'FontSize',16);

NbWells=size(ResponseArray,2); % dim 2 indicates the wells.

for k=1:NbWells
    FDAOutput.Original{k}=reshape(ResponseArray(:,k,:),length(TimeStep),[]);
    FDAOutput.Fdobject{k}=data2fd(FDAOutput.Original{k},FDAInput.tgrid,FDAOutput.emptyBasis,{'Time';'Model';['P',num2str(k)]});
end

%% Visualizations Part.
nCols=ceil(NbWells/nRows);

%% FPCA.
for k=1:NbWells
    FDAOutput.FPCAobject{k}=pca_fd(FDAOutput.Fdobject{k},FDAInput.nbasis);
end
%% Data Reconstruction.
for k=1:NbWells
    FDAOutput.ResponsesRecalculated{k} = eval_fd(FDAOutput.Fdobject{k}, FDAInput.tgrid);
end
%%



%% Compare the data reconstruction. 

if ~isempty(Index2Visualize)
    for k=1:length(Index2Visualize)
        figure;
        for j=1:NbWells
            subplot(nRows,nCols,j);hold on;
            h1=plot(TimeStep,ResponseArray(:,j,Index2Visualize(k)),'.','Color',[1,0,0],'Markersize',15);
            h2=plot(TimeStep,FDAOutput.ResponsesRecalculated{j}(:,Index2Visualize(k)),'Color',[0,0,1],'LineWidth',3);
            
            if strcmp(ylabeltxt,'WATERCUT')
                ylim([0,1]);
            end
            xlim([TimeStep(1),TimeStep(end)]);
            if j==NbWells
                legend([h1,h2],{'Original','Reconstruced'},'Fontsize',14,'Location','northwest');
            end
            title(WellNames{j},'Fontsize',20); hold off;
            set(gca,'Fontsize',14); xlabel('Time(Day)','Fontsize',16);
            ylabel(ylabeltxt,'Fontsize',16);
        end
     
        set(gcf, 'Units', 'normalized', 'Position', [0.2,0.2,0.6,0.6]);
    end
end





end