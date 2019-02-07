%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 30.09.2016 

%% Summary of the Tasks 

% Subspace based Feature Fusion Method
% Combining Facial Expression & Prosodic Speech Features
% Applying PCA to reduce dimensions
% 20 for Facial expressions & 15 for audio 
% Apply z-score normalization and then combine the datasets 
% Train the classifer using Combined Training Dataset
% Evaluate the classifer using Combined Testing Dataset

%% Init 

clear
clc 
close all
load('lab3_data.mat');

%% Construct subspaces for facial expression and audio features using PCA
% Feature Fusion Method using PCA

% PCA ( Principal Component Analysis )
% Use trianing datasets to construct subspaces

[n1,D1] = size(training_data);
[n2,D2] = size(training_data_proso);

m1 = 20;
m2 = 15;

norm = true;

options = [];
options.ReducedDim = m1;                % 20 Dimensions for Facial Expressions

% Extract U1 subspace for facial expressions using training dataset.
[U1,value1] = PCA(training_data,options);

% Extract U2 subspace for audio features using training dataset. 
options.ReducedDim = m2;               % 15 Dimesions for audio features 
[U2,value2] = PCA(training_data_proso,options);

%% Extract Low Dimensional Features for facial expression and audio features datasets. 

% Map Datasets to Subspace U1 using facial expression datasets. 
training_data1 = (training_data) * U1; 
testing_data1 = (testing_data) * U1; 

% Map Datasets to Subspace U2 using audio features datasets.

training_data2 = (training_data_proso) * U2;
testing_data2 = (testing_data_proso) * U2; 

%% Perform Z-Score normalization for facial expression and audio features datasets. 

% For facial expression datasets
meanFacial = repmat(mean(training_data1,1),size(training_data,1),1);
stdFacial = repmat(std(training_data1,0,1),size(training_data,1),1);

training_data1_norm = (training_data1 - meanFacial) ./ stdFacial;
testing_data1_norm = (testing_data1 - meanFacial) ./ stdFacial;

% For audio features datasets
meanAudio = repmat(mean(training_data2,1),size(training_data2,1),1);
stdAudio = repmat(std(training_data2,0,1),size(training_data2,1),1);
training_data2_norm = (training_data2 - meanAudio) ./ stdAudio;
testing_data2_norm = (testing_data2 - meanAudio) ./ stdAudio;

%% Combine the Datasets. 

if norm == true 
    combined_trainingData = [training_data1_norm training_data2_norm];
    combined_testingData = [testing_data1_norm testing_data2_norm];
else
    combined_trainingData = [training_data1 training_data2];
    combined_testingData = [testing_data1 testing_data2];
end

%% Train Classifer, Evalulate Classifier and Display Average Classification Performance 

% Train the SVM using Fusion Feature set of training samples and Linear Kernel
svmStruct = svmtrain(combined_trainingData,training_class, 'kernel_function', 'linear');

% Evaluate the classifier using Fusion Feature set of training samples. 
yTrain = svmclassify(svmStruct, combined_trainingData);

% Check classifier performance by evaluating accuracy score and confusion matrix. 
statsLabel = 'Classifier performance using PCA Based Feature Fusion Method (Training Samples)';
[accScoreTrain,f1ScoreTrain,cMatrixTrain] = checkClassifierPerformance(yTrain, training_class, true, statsLabel);

% Evaluate the classifier using Fusion Feature set of test samples. 
yTest = svmclassify(svmStruct, combined_testingData);

% Check classifier performance by evaluating accuracy score and confusion matrix. 
statsLabel = 'Classifier performance using PCA Based Feature Fusion Method (Testing Samples)';
[accScoreTest,f1ScoreTest,cMatrixTest] = checkClassifierPerformance(yTest, testing_class, true, statsLabel);

%% Display Confusion Matrix for Training & Test Datasets

subplot(2,1,1);
plotConfusionMatrix([1,2],cMatrixTrain,'Confusion Matrix - Fused Feature Training Dataset');

subplot(2,1,2);
plotConfusionMatrix([1,2],cMatrixTest,'Confusion Matrix - Fused Feature Testing Dataset');