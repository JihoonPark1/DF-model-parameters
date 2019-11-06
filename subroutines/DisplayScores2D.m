function DisplayScores2D(Scores,Dimensions,ReferenceNumber,titletext,VarExplained)

figure; hold on; 

x_axis = Dimensions(1);
y_axis = Dimensions(2);

h1=plot(Scores(:,x_axis),Scores(:,y_axis),'o','MarkerEdgeColor','k','MarkerFaceColor','b','Markersize',10); 
h2=plot(Scores(ReferenceNumber,x_axis),Scores(ReferenceNumber,y_axis),'x','Markersize',30,'LineWidth',5,'Color','r'); hold off; 

set(gca,'Fontsize',16);
title(titletext,'Fontsize',20);
%title('First two PCs from data variable (Prior)','Fontsize',20);
legend([h1,h2],{'Prior','Reference'},'location','Best');

xlabel(sprintf('PC%s (%.1f%%)',num2str(x_axis),VarExplained(1)),'Fontsize',16);
ylabel(sprintf('PC%s (%.1f%%)',num2str(y_axis),VarExplained(2)),'Fontsize',16);
set(gcf,'Position',[830,482,693,430]);

end