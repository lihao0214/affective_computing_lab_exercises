%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 09.07.2016


%% Training the Classifier (Support Vector Machine)
% Train the SVM using Test Data set and linear Kernel 

svmStruct = svmtrain(training_data,training_class, 'kernel_function', 'linear');

%% Evaluating the Classifer (Support Vector Machine)

% Classify training dataset using trained SVM 
yTrain = svmclassify(svmStruct, training_data);

% Apply the trained SVM on testing data
yTest = svmclassify(svmStruct, testing_data);

%% Show the performance of classifier on Training and Testing Data Sets
disp('------------------------');
disp('Classifier Performance Statistics for Training Dataset');
[acc1,f1] = displayClassifierPerformance(yTrain, training_class);

disp('------------------------');
disp('Classifier Performance Statistics for Testing Dataset');
[acc2,f2] = displayClassifierPerformance(yTest, testing_class);

disp('------------------------');
disp('Classifier Average Performance for Training & testing dataset');
avgF = ( f1 + f2 ) / 2;
disp(['Average F1 Score : ' num2str(avgF * 100) '%']);

%% Plotting Confusion Matrix of Linear Kernel SVM 
% Using Training Dataset

C1 = confusionmat(training_class, yTrain);
plotConfusionMatrix([1,2],C1,'Confusion Matrix ( Training Dataset )');

figure()
C2 = confusionmat(testing_class, yTest);
plotConfusionMatrix([1,2],C2,'Confusion Matrix ( Testing Dataset )');