function CompareIterations(MatfileLists,ReferenceNumber,Well2Display)

%% Basic inputs.
n_results = numel(MatfileLists);
DataLoaded = cell(n_results);

% Read sequentially.

for k=1:n_results
    DataLoaded{k} = load(MatfileLists{k});
end

%% Combine all the data

WellNames = {'P1','P2','P3','P4','P5','PNEW2'};
WellNamesData = {'P1','P2','P3','P4','P5'};
WellNamesForecast = {'PNEW2'};

IndexResponseOilRate=4;
IndexResponseWatercut=8;
CutOffHist=7500;


%ReferenceNumber = 106;

ReferenceTimeStep = DataLoaded{1}.Data{ReferenceNumber}.(WellNamesData{1})(:,2);  % Take the reference timestep.
ReferenceTimeStepData = ReferenceTimeStep(ReferenceTimeStep<=CutOffHist);
ReferenceTimeStepForecast = ReferenceTimeStep(ReferenceTimeStep>CutOffHist);


ReferenceTime = ReferenceTimeStepData;
TimeIndex =2;

DataConverted = cell(n_results);

for k=1:n_results
    DataConverted{k}.Oilrate = Convert_3DSL_Response(DataLoaded{k}.Data,IndexResponseOilRate,WellNamesData,ReferenceTime,TimeIndex);
    DataConverted{k}.Watercut = Convert_3DSL_Response(DataLoaded{k}.Data,IndexResponseWatercut,WellNamesData,ReferenceTime,TimeIndex);
    DataConverted{k}.Watercut = DataConverted{k}.Watercut/100;
    
    DataConverted{k}.Oilrate_end = DataConverted{k}.Oilrate(end,:,:);
    DataConverted{k}.Watercut_end = DataConverted{k}.Watercut(end,:,:);
    
end




%% Boxplot: oil rate
WellIndex = find(contains(WellNames,Well2Display));

figure; hold on;
XX=[]; gg=[];
for k=1:n_results
    qq = DataConverted{k}.Oilrate_end(:,WellIndex,:);
    XX = [XX;qq(:)];
    gg =[gg;(k-1)*ones(size(qq(:)))];
end
boxplot(XX,gg);
g = get(gca);

RefVal = DataConverted{1}.Oilrate_end(:,WellIndex,ReferenceNumber);
h1=line(g.XLim,[RefVal,RefVal],'Color','m','LineWidth',3,'LineStyle','--');
legend(h1,{'d_{obs}'},'Fontsize',16,'Location','Best');
set(gca,'Fontsize',14); xlabel('Iteration','Fontsize',16); ylabel('OIL(stb/day)','Fontsize',16); hold off; 

%% Boxplot: Watercut
figure; hold on;

XX=[]; gg=[];
for k=1:n_results
    qq = DataConverted{k}.Watercut_end(:,WellIndex,:);
    XX = [XX;qq(:)];
    gg =[gg;(k-1)*ones(size(qq(:)))];
end
boxplot(XX,gg);
g = get(gca);
RefVal = DataConverted{1}.Watercut_end(:,WellIndex,ReferenceNumber);
h1=line(g.XLim,[RefVal,RefVal],'Color','m','LineWidth',3,'LineStyle','--');
legend(h1,{'d_{obs}'},'Fontsize',16,'Location','Best');
set(gca,'Fontsize',14); xlabel('Iteration','Fontsize',16); ylabel('Watercut','Fontsize',16);
hold off;

end