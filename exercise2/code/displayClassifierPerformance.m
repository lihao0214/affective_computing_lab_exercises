%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 27.09.2016 ( Modified - Version 2 ) 

function [accuracyScore,f1Score, cMatrix] = displayClassifierPerformance(predictions,truth, display,statsLabel)

% Class: Happy == 1 (Positive)
% Class: Sadness == 2 (Negative)

cMatrix = confusionmat(truth, predictions);
TP = cMatrix(1,1);
FP = cMatrix(2,1);
TN = cMatrix(2,2);
FN = cMatrix(1,2);

if display == true
    disp('------------------------');
    disp(statsLabel);
    disp(['True Positive: ' num2str(TP)]);
    disp(['False Positive: ' num2str(FP)]);
    disp(['True Negative: ' num2str(TN)]);
    disp(['False Negative: ' num2str(FN)]);
end 


accuracyScore = sum(predictions == truth) / size(truth,1);
if TP + FP ~= 0
    precision = TP / (TP + FP);
else
    precision = 0;
end
    
if TP + FN ~= 0
    recall = TP / (TP + FN);
else
    recall = 0;
end

if precision + recall ~= 0
    f1Score =  2 * precision * recall / (precision + recall);
else
    f1Score = 0
end

if display == true
    disp('------');
    disp(['Accuracy Score : ' num2str(accuracyScore * 100) '%']);
    disp(['F1 Score : ' num2str(f1Score * 100) '%']);
end


