%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 09.07.2016

function [accuracyScore,f1Score] = displayClassifierPerformance(predictions,truth)

% Class: Happy == 1 (Positive)
% Class: Sadness == 2 (Negative)

TP = sum(predictions(truth == 1) == 1);
FP = sum(predictions(truth == 2) == 1);
TN = sum(predictions(truth == 2) == 2);
FN = sum(predictions(truth == 1) == 2);

disp(['True Positive: ' num2str(TP)]);
disp(['False Positive: ' num2str(FP)]);
disp(['True Negative: ' num2str(TN)]);
disp(['False Negative: ' num2str(FN)]);

disp('------');
accuracyScore = sum(predictions == truth) / size(truth,1);
disp(['Accuracy Score : ' num2str(accuracyScore * 100) '%']);
precision = TP / (TP + FP);
recall = TP / (TP + FN);
f1Score =  2 * precision * recall / (precision + recall);
disp(['F1 Score : ' num2str(f1Score * 100) '%']);
