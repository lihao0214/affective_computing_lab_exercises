%% Source 
% This function is taken from One Machine Vision assignment
% Function plots the confusion matrix graphically
% Input is classIds and confusion matrix computed using function

function plotConfusionMatrix(classIds,confusionMatrix,label)
    classCount = length(classIds);
   
    imagesc(confusionMatrix);

    strings = cellstr(num2str(confusionMatrix(:)));
    [x,y] = meshgrid(1:classCount);
    
    text(x(:),y(:),strings(:),'HorizontalAlignment','center','Color','Magenta','FontSize',40,'FontWeight','Bold');
    ylabel('Real label','FontSize',12,'FontWeight','bold');
    xlabel('Assigned label','FontSize',12,'FontWeight','bold');
    set(gca,'XTick',1:classCount,...                         %# Change the axes tick marks
        'XTickLabel',num2cell(classIds),...                     %#   and tick labels
        'YTick',1:classCount,...
        'YTickLabel',num2cell(classIds),...
        'TickLength',[0 0]);
    
    title(label,'FontSize',16);
end