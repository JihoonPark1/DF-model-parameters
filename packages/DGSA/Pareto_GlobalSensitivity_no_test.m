
function Pareto_GlobalSensitivity_no_test(SensitivityValues,ParamsNames)

%% Input Parameters
%   - SensitivityValues: vector (NbParams x 1) of the parameter sensitivities
%   - ParamsNames: Parameter names

NbParams = length(SensitivityValues);

if NbParams > 10
    TextSize = 10;
else
     TextSize = 12;
end  

% Sort from less sensitive to most sensitive
[~, SortedSA] = sort(SensitivityValues(:),'ascend');  
SensitivityValues = SensitivityValues(SortedSA);
ParamsNames = ParamsNames(SortedSA);

figure
axes('FontSize',TextSize,'fontweight','b');  hold on;

C2 = [0.8,0,0];

for i = 1:NbParams
    h1 = barh(i,SensitivityValues(i),'FaceColor',C2,'BarWidth',0.8,'LineStyle','-','LineWidth',2);    
end

set(gca,'YTick',1:NbParams)
set(gca,'YTickLabel',ParamsNames)
box on; ylim([0 NbParams+1]);

if nargin == 3  % bar are colored
    
    C1 = [0,0,0.8];
    C2 = [0.8,0,0];
    h1 = []; h2 = [];
    figure
    axes('FontSize',TextSize,'fontweight','b');  hold on;
    for i = 1:NbParams
        if IsSensitive(i) == 1
            h1 = barh(i,SensitivityValues(i),'FaceColor',C2,'BarWidth',0.8,'LineStyle','-','LineWidth',2);
        else
            h2 = barh(i,SensitivityValues(i),'FaceColor',C1,'BarWidth',0.8,'LineStyle','-.','LineWidth',2);
        end
    end
    set(gca,'YTick',1:NbParams)
    set(gca,'YTickLabel',ParamsNames)
    box on; ylim([0 NbParams+1]);
    if ~isempty(h1) && ~isempty(h2)
        legend([h1,h2],'Sensitive','NotSensitive','location','SouthEast')
    elseif isempty(h1)
        legend(h2,'NotSensitive','location','SouthEast')
    elseif isempty(h2)
        legend(h1,'Sensitive','location','SouthEast')
    end
    
else
    figure
    axes('FontSize',TextSize,'fontweight','b');  hold on;
    barh(SensitivityValues);
    box on;
    set(gca,'YTick',1:NbParams)
    set(gca,'YTickLabel',ParamsNames)
    ylim([0 NbParams+1])
end

end

