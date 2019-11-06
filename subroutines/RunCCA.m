function CCAOutputs=RunCCA(X,Y,ReferenceNumber,NumDim,NumRows,PrefixX,PrefixY,HowManyDisplay,FigSize)
% This function runs cca and plot the graph.

[A,B,R,U,V] = canoncorr(X,Y);
if isempty(NumDim)
    NumDim=size(U,2);
end

figure;
set(gcf,'Position',FigSize);
if nargin<8
    HowManyDisplay=NumDim;
end
NumCols=ceil(HowManyDisplay/NumRows);
for k=1:HowManyDisplay
%    XName=[PrefixX,'^c_%s']; XName=sprintf(XName,num2str(k));
%    YName=[PrefixY,'^c_%s']; YName=sprintf(YName,num2str(k));
    %XName=[PrefixX,'^c']; XName=sprintf(XName,num2str(k));
    %YName=[PrefixY,'^c']; YName=sprintf(YName,num2str(k));
    
    XName = ['$',PrefixX,'_{c}^{%d}$'];
    YName = ['$',PrefixY,'_{c}^{%d}$'];
    
    %title(sprintf('$\\alpha_{c}^{%d}$',2),'interpreter','latex');
    
    XName = sprintf(XName,k);  YName = sprintf(YName,k);
        
    subplot(NumRows,NumCols,k);    
    plot(U(:,k),V(:,k),'o','MarkerEdgeColor','k','MarkerFaceColor','b','Markersize',7);
    %axis equal
    xlabel(XName,'Fontsize',20,'Interpreter','latex');
    ylabel(YName,'Fontsize',20,'Interpreter','latex');
    set(gca,'Fontsize',16);
    h=get(gca);
    Ylimh=h.YLim;
    line([U(ReferenceNumber,k),U(ReferenceNumber,k)],Ylimh,'Color',[1,0,0],'LineWidth',3);
    %U(ReferenceNumber,k)
    %title(sprintf('Corr=%0.2f',num2str(corr(U(:,k),V(:,k)),2)),'Fontsize',16);
    title(sprintf('Corr=%0.2f',corr(U(:,k),V(:,k))),'Fontsize',16);
end



CCAOutputs.A=A;
CCAOutputs.B=B;
CCAOutputs.R=R;
CCAOutputs.U=U;
CCAOutputs.V=V;


end