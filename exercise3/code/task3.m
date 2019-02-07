
%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 11.10.2016


%% Summary of the Tasks 

% Cross Validation 
% Combine Training & Testing Datasets of Audio and Facial Features
% Combine training & testing classes, and person Ids 
% Perform a 10 fold cross validation
% Perfrom feature fusion for audio & facial datasets
% Use PCA to reduce the dimensions for the datasets
% Project the datasets into subspace vectors.
% Compute the z-score normalized datasets. 
% Combine the features for training & testing datasets
% Train the classifier using combined training set.
% Evaluate the classifier using combined testing set. 
% Store the accuracy of the classifier for each fold. 

% Compute the mean & std of the CV Score set. 
%% Init 

clear
clc 
close all
load('lab3_data.mat');

%% Combining Datasets for Cross Validation

audioFeatures = [training_data_proso;testing_data_proso];
facialFeatures = [training_data;testing_data];
classes = [training_class;testing_class];
personIds = [training_personID; testing_personID];

%% Find Unique Person IDs

uniqueIdList = unique(personIds);

%% Perform Cross Validation

CV = zeros(1,size(uniqueIdList,1));
options = [];
m1 = 20;
m2 = 15;

for i = 1 : size(uniqueIdList,1)
    id = uniqueIdList(i);
    
    % Extracting Training & Testing Dataset from LBP Facial Features 
    trainingSetFacial = facialFeatures(personIds ~= id,:);
    testingSetFacial = facialFeatures(personIds == id,:);
    
    
   
    % Extract U1 subspace for facial expressions using training dataset.
    options.ReducedDim = m1;                % 20 Dimensions for Facial Expressions
    [U1,~] = PCA(trainingSetFacial,options);
    
    % Map Datasets to Subspace U1 using facial expression datasets. 
    training_data1 = (trainingSetFacial) * U1; 
    testing_data1 = (testingSetFacial) * U1; 
    
    % For facial expression datasets (Compute the Z-score normalized dataset)
    meanFacial = mean(training_data1,1);
    stdFacial = std(training_data1,0,1);
    training_data1_norm = (training_data1 - repmat(meanFacial,size(training_data1,1),1)) ./ repmat(stdFacial,size(training_data1,1),1);
    testing_data1_norm = (testing_data1 - repmat(meanFacial,size(testing_data1,1),1)) ./ repmat(stdFacial,size(testing_data1,1),1);
    
    % Extracting Training & Testing Dataset from Speech Prosody Features 
    trainingSetAudio = audioFeatures(personIds ~= id,:);
    testingSetAudio = audioFeatures(personIds == id,:);
    
    %Extract U2 subspace for audio features using training dataset. 
    options.ReducedDim = m2;               % 15 Dimesions for audio features 
    [U2,~] = PCA(trainingSetAudio,options);
   
    training_data2 = (trainingSetAudio) * U2;
    testing_data2 = (testingSetAudio) * U2; 
   
   % For audio features datasets
    meanAudio = mean(training_data2,1);
    stdAudio = std(training_data2,0,1);
    training_data2_norm = (training_data2 - repmat(meanAudio,size(training_data2,1),1)) ./ repmat(stdAudio,size(training_data2,1),1);
    testing_data2_norm = (testing_data2 - repmat(meanAudio,size(testing_data2,1),1)) ./ repmat(stdAudio,size(testing_data2,1),1);
    
    
    trainingClass = classes(personIds ~= id,:);
    testingClass = classes(personIds == id,:);
    
    combinedTrainingSet = [training_data1_norm training_data2_norm];
    combinedTestingSet = [testing_data1_norm testing_data2_norm];
    
    svmStruct = svmtrain(combinedTrainingSet,trainingClass, 'kernel_function', 'linear');
    
    yTrain = svmclassify(svmStruct, combinedTrainingSet);
    yTest = svmclassify(svmStruct, combinedTestingSet);
    
    [accTrain,~,~] = checkClassifierPerformance(yTrain, trainingClass, false, '');
    [accTest,~, ~] = checkClassifierPerformance(yTest, testingClass, false, '');
   
    CV(i) = accTest;   
    
    %break;
end

disp('Ten Fold Cross Validation Score');
CV

disp(['Mean ' num2str(mean(CV))]);
disp(['Standard Deviation ' num2str(std(CV))]);
