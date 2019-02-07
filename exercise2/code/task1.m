%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 27.09.2016

% MFCC Features Extraction from the speech signal 

%% Init

clear
clc 
close all 
load('lab2_data.mat');

%% Downsample the Speech Signal 
%  p = 2297 , q = 10000 p/q = 0.2297 = ratio 
fs = 48000;
fsNew = 11025; 
ratio = 1/ (fs / fsNew);
speechResampled = resample(speech_sample, 2297, 10000);

%% Apply Pre-emphasis filter to emphasize highest frequency in the signals. 
b = [1 -0.98];
a = 1;

speechFiltered = filter(b,a,speechResampled);

%% Display Pre-emphasis filter frequency response in Hz using fvtool
% set the sampling frequency to 11025 Hz in the visualization tool.
fvtool(b,a);

%% Use melcepst to create 12 MFCC feature contours. 

mfccFeatureContours = melcepst(speechFiltered,fsNew);

%% Plot the raw speech with MFCC contours in a subplot 

subplot(2,1,1);
t1 = linspace(0,size(speech_sample,1)/fs,size(speech_sample,1));
plot(t1,speech_sample);
xlabel('Time (s)');
ylabel('Amplitude');
title('Raw Speech Signal');
xlim([0,2.5]);
ylim([-1 1]);
grid on;

t2 = linspace(0,2.5,215);
subplot(2,1,2);
for n = 1 : size(mfccFeatureContours,2)
    plot(t2,mfccFeatureContours(:,n),'linewidth',1);
    hold on;
end
hold off; 
xlabel('Time (s)');
ylim([-10 5]);
title('MFCC Contours of the Speech Signal');
grid on;

%% Calculate the mean of each MFCC contour 
mfccFeatureContourMean = mean(mfccFeatureContours,1);

%% Comparison with the first row in MFCC Training Feature Dataset 

% Compare values with 1% tolerance. 

result = sum(isalmost(training_data_mfcc(1,:), mfccFeatureContourMean,0.01));
disp(['Feature values Similar Count :' num2str(result)]);