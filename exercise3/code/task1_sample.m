clear all
clc
load lab3_data

% Set reduced dimension


% Construct two subspace U1 and U2 for facial expression features and audio
% features

[] = PCA();

% Extract low-dimensional features for training and testing features:

% Use Z-score normalization to normalize for facial expression

% Use Z-score normalization to normalize for audio


% Concatenate multiple feature
combined_trainingData = [training_data1 training_data2];
combined_testingData = [testing_data1 testing_data2];

% linear kernel SVM for fused features


% test linear SVM classifier with training and testing data 


% Accuracies of  linear kernel SVM for fused features


% Confusion matrices

