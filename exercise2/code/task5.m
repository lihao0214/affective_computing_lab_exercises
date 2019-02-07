%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 27.09.2016

% Cross Validation Estimation of Recognition Performance

%% Init

clear
clc 
close all 
load('lab2_data.mat');

%% Combining Datasets 

option = 2;
if option == 1
    features = [training_data_proso;testing_data_proso];
elseif option == 2
    features = [training_data_mfcc;testing_data_mfcc];
end

classes = [training_class;testing_class];
personIds = [training_personID; testing_personID];

%% Find Unique Person IDs

uniqueIdList = unique(personIds);

%% Perform Cross Validation

CV = zeros(1,size(uniqueIdList,1));

for i = 1 : size(uniqueIdList,1)
    id = uniqueIdList(i);
    
    trainingSet = features(personIds ~= id,:);
    trainingClass = classes(personIds ~= id,:);
    
    testingSet = features(personIds == id,:);
    testingClass = classes(personIds == id,:);
    
    svmStruct = svmtrain(trainingSet,trainingClass, 'kernel_function', 'polynomial','polyorder',3);
    
    yTrain = svmclassify(svmStruct, trainingSet);
    yTest = svmclassify(svmStruct, testingSet);
    
    [~,f1Train,~] = displayClassifierPerformance(yTrain, trainingClass, false, '');
    [accTest,f1Test, ~] = displayClassifierPerformance(yTest, testingClass, false, '');
   
    CV(i) = accTest;
   
end

disp('Ten Fold Cross Validation Score');
CV

disp(['Mean ' num2str(mean(CV))]);
disp(['Standard Deviation ' num2str(std(CV))]);

