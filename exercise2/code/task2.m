%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 27.09.2016

% Prosodic prosodicFeatures Extraction from the speech signal 

%% Init

clear
clc 
close all 
load('lab2_data.mat');

%% Downsample the Speech Signal from 48 KHz to 11.025 KHz
%  p = 2297 , q = 10000 ratio = p/q = 0.2297

fs = 48000;
fsNew = 11025; 
ratio = 1/ (fs / fsNew);
speechResampled = resample(speech_sample, 2297, 10000);

t1 = linspace(0,size(speech_sample,1)/fs,size(speech_sample,1));


%% Calculate the Short time energey (STE) of the downsampled speech signal

N = int64(0.01 * fsNew);
L = N + 1;
hamWindow = hamming(L);
squaredSignal = speechResampled .^ 2;
squaredSignal = squaredSignal(55 : length(squaredSignal) - 55,1);
STE = conv(squaredSignal,hamWindow)';

%% Display Raw Speech Signal and STE Contour of the Speech Signal 

subplot(2,2,1);
plot(t1,speech_sample);
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1 1]);
xlim([0 2.5]);
title('Raw Speech Signal');
grid on;

subplot(2,2,3);
t2 = linspace(0,2.5,size(STE,2));
plot(t2,STE,'linewidth',1);
xlabel('Time (s)');
ylabel('Energy');
title('Short Time Energy (STE) of the speech signal');
xlim([0 2.5]);
ylim([0 6]);
grid on;

%% Extract Prosodic Features from the STE Contour

meanSTE = mean(STE);
stdSTE = std(STE);
prctile10STE = prctile(STE,10);
prctile90STE = prctile(STE,90);
kurtosisSTE = kurtosis(STE);

%% Calculate the F0 Contour of the Speech Signal 
[F0,strength,T_ind,wflag] = getF0(speechResampled, fsNew);


%% Display Raw Speech Signal and F0 Contour of the Speech Signal

subplot(2,2,2);
plot(t1,speech_sample);
xlabel('Time (s)');
ylabel('Amplitude');
ylim([-1 1]);
xlim([0 2.5]);
title('Raw Speech Signal');
grid on;

subplot(2,2,4);
t2 = linspace(0,2.5,249);
plot(t2,F0);
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('F0-contour of the speech signal');
xlim([0 2.5]);
ylim([0 400]);
grid on;

%% Extract Prosodic prosodicFeatures from the F0 Contour 

meanF0 = mean(F0(F0 > 0));
stdF0 = std(F0(F0 > 0));
prctile10F0 = prctile(F0(F0 > 0),10);
prctile90F0 = prctile(F0(F0 > 0),90);
kurtosisF0 = kurtosis(F0(F0 > 0));


%% Perform Voiced / Unvoiced Segmentation 

tracker = (F0 > 0);
voiceC = 0; unVoiceC = 0; frameC = 0;
voiceSeg = []; unVoiceSeg = [];
tracker(length(tracker) + 1) = ~tracker(length(tracker) - 1);
voiceF = (tracker(1) == 1);
for i = 1 : length(tracker)
    frameC = frameC + 1;
    if tracker(i) == 1
        if voiceF == 0
            unVoiceSeg(length(unVoiceSeg) + 1) = (frameC - 1) * 0.01;
            frameC = 1;
            voiceF = 1;
        end   
    elseif (tracker(i) == 0)
        if voiceF == 1 
            voiceSeg(length(voiceSeg) + 1) = (frameC - 1) * 0.01;
            frameC = 1;
            voiceF = 0;
        end
    end  
end

%% Calculate Prosodic Features from the Voiced/unVoiced Segmentation Analysis

meanVoiceSeg = mean(voiceSeg);
stdVoiceSeg = std(voiceSeg);
meanUnVoiceSeg = mean(unVoiceSeg);
stdUnVoiceSeg = std(unVoiceSeg);
voicingRatio = sum(F0 > 0) / size(F0,2);


%% Compile Prosodic Feature Set

prosodicFeatures = zeros(1,15);
prosodicFeatures(1) = meanF0;
prosodicFeatures(2) = stdF0;
prosodicFeatures(3) = prctile10F0;
prosodicFeatures(4) = prctile90F0;
prosodicFeatures(5) = kurtosisF0;

prosodicFeatures(6) = meanSTE;
prosodicFeatures(7) = stdSTE;
prosodicFeatures(8) = prctile10STE;
prosodicFeatures(9) = prctile90STE;
prosodicFeatures(10) = kurtosisSTE;

prosodicFeatures(11) = meanVoiceSeg;
prosodicFeatures(12) = stdVoiceSeg;
prosodicFeatures(13) = meanUnVoiceSeg;
prosodicFeatures(14) = stdUnVoiceSeg;
prosodicFeatures(15) = voicingRatio;

%% Comparison with the first row in Prosodic Training Feature Dataset

% Compare values with 10% tolerance. 

result = sum(isalmost(training_data_proso(1,:), prosodicFeatures,0.1));

disp(['Feature values Similar Count :' num2str(result)]);