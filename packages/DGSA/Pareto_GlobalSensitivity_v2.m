%
% This function creates a Pareto plot showing the standardized measure of SensitivityValues 
% for each parameter.
% In blue, the sensitive parameters, in red the non-sensitive parameters 
 
% Author: Celine Scheidt
% Date: August 2012

function Pareto_GlobalSensitivity_v2(SensitivityValues,ParamsNames,NumParametersToDisplay,IsSensitive)

%% Input Parameters
%   - SensitivityValues: vector (NbParams x 1) of the parameter sensitivities
%   - ParamsNames: Parameter names
%   - IsSensitive (optional): vector (NbParams x 1) of 0 (if not sensitive) or 1
%                 (sensitive) to color bars.(By default all bars are of the same color.)


NbParams = length(SensitivityValues);

if NbParams > 10
    TextSize = 10;
else
     TextSize = 12;
end  

% Sort from less sensitive to most sensitive
[~, SortedSA] = sort(SensitivityValues(:),'descend');  
SensitivityValues = SensitivityValues(SortedSA);
ParamsNames = ParamsNames(SortedSA);



SensitivityValues = SensitivityValues(1:NumParametersToDisplay);
ParamsNames = ParamsNames(1:NumParametersToDisplay);

SensitivityValues = flipud(SensitivityValues);
ParamsNames = fliplr(ParamsNames);

NbParams = NumParametersToDisplay;

C1 = [0,0,0.8];
C2 = [0.8,0,0];

figure
axes('FontSize',TextSize,'fontweight','b');  hold on;

if nargin<4
    
    barh(SensitivityValues,'FaceColor',C2,'BarWidth',0.8,'LineStyle','-','LineWidth',2);
    box on;
    set(gca,'YTick',1:NbParams)
    set(gca,'YTickLabel',ParamsNames)
    ylim([0 NbParams+1])
    
    
else
    
    IsSensitive = IsSensitive(SortedSA);
    h1 = []; h2 = [];    

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
    
end

hold off;



end

