function DisplayCumulativeVar(varExp_cumulative,titletext,nComponents)
if nargin<3
    nComponents = length(varExp_cumulative);
end

figure;hold on;
plot(1:nComponents,varExp_cumulative(1:nComponents),'LineWidth',3); 
xlim([1,nComponents]);
set(gca,'Fontsize',16);

xlabel('Number of PCs','Fontsize',16);
ylabel('Variance Explained (%)','Fontsize',16);

title(titletext,'Fontsize',20);

%set(gcf,'units','normalized','Position',[0.3,0.3,0.8,0.6]);

end