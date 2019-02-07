%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 27.09.2016


%% Init

clear
clc 
close all 
load('lab2_data.mat');

%% Hello 

disp('Hello Awais ....') 

%% Training the Classifier (Support Vector Machine)
% Train the SVM classifer using Prosody Training Data Feature set and 3rd
% order polynomial Kernel

disp('Training SVMs using Prosodic and MFCC Features Dataset ....') 

svmStructProso = svmtrain(training_data_proso,training_class, 'kernel_function', 'polynomial','polyorder',3);

% Train the SVM Classifier using MFCC Training Data Feature Set and 3rd
% order polynomial Kernel

svmStructMfcc = svmtrain(training_data_mfcc,training_class, 'kernel_function', 'polynomial','polyorder',3);

%% Evaluating the Classifer (Support Vector Machine)


disp('Testing the Trained SVMs on MFCC and Prosodic Feature Datasets....') 

% Classify training Prosody Features dataset using Prosody Trained SVM 
yTrainProso = svmclassify(svmStructProso, training_data_proso);

% Classify Testing Prosody Features dataset using MFCC Trained SVM
yTestProso = svmclassify(svmStructProso, testing_data_proso);

% Classify training MFCC Features dataset using MFCC Trained SVM 
yTrainMfcc = svmclassify(svmStructMfcc, training_data_mfcc);

% Classify Testing MFCC Features dataset using MFCC Trained SVM
yTestMfcc = svmclassify(svmStructMfcc, testing_data_mfcc);


%% Calculate the average classification performance using Prosodic & MFCC features Training and Testing Dataset


disp('Calculating the average classification performance for both trained SVMs ....');
classifierStatsDisp = true;
% Calculate the Prosodic Feature Trained SVM Classifier average performance. 

statsLabel = 'Prosodic Feature Trained SVM Performance Statistics using Training Prosodic Features Dataset';
[accTrainProso,f1ScoreTrainProso, cMatrixTrainProso] = displayClassifierPerformance(yTrainProso, training_class, classifierStatsDisp, statsLabel);

statsLabel = 'Prosodic Feature Trained SVM Performance Statistics using Testing Prosodic Features Dataset';
[accTestProso,f1ScoreTestProso, cMatrixTestProso] = displayClassifierPerformance(yTestProso, testing_class, classifierStatsDisp, statsLabel);

disp('------------------------');
disp('1) Prosodic Feature Trained SVM Classifier Average Performance');
avgF1ScoreProso = ( f1ScoreTrainProso + f1ScoreTestProso ) / 2;
disp(['Average F1 Score : ' num2str(avgF1ScoreProso * 100) '%']);

% Calculate the MFCC Feature Trained SVM Classifier average performance. 

statsLabel = 'MFCC Feature Trained SVM Performance Statistics using Training MFCC Features Dataset';
[accTrainMfcc,f1ScoreTrainMfcc, cMatrixTrainMfcc] = displayClassifierPerformance(yTrainMfcc, training_class, classifierStatsDisp, statsLabel);

statsLabel = 'MFCC Feature Trained SVM Performance Statistics using Testing MFCC Features Dataset';
[accTestMfcc,f1ScoreTestMfcc, cMatrixTestMfcc] = displayClassifierPerformance(yTestMfcc, testing_class, classifierStatsDisp, statsLabel);

disp('------------------------');
disp('2) MFCC Feature Trained SVM Classifier Average Performance');
avgF1ScoreMfcc = ( f1ScoreTrainMfcc + f1ScoreTestMfcc ) / 2;
disp(['Average F1 Score : ' num2str(avgF1ScoreMfcc * 100) '%']);


%% Plotting Confusion Matrix 

subplot(2,2,1);
plotConfusionMatrix([1,2],cMatrixTrainProso,'Confusion Matrix - Prosodic Features - Training Dataset');

subplot(2,2,2);
plotConfusionMatrix([1,2],cMatrixTestProso,'Confusion Matrix - Prosodic Features - Testing Dataset');

subplot(2,2,3);
plotConfusionMatrix([1,2],cMatrixTrainMfcc,'Confusion Matrix - MFCC Features - Training Dataset');

subplot(2,2,4);
plotConfusionMatrix([1,2],cMatrixTestMfcc,'Confusion Matrix - MFCC Features - Testing Dataset');


disp('Confusion Matrix Display Done ...');

%% Bye 

disp('Bye Bye Awais ....');
disp('------------------');

 