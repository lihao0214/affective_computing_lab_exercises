%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 09.07.2016

%% Close Figures
close all
%% Detect Facial Landmarks using FaceTrack Tool. 
subplot(2,2,1);
example_img = im2double(example_img);
fpt = FaceTrack(example_img,'Chehra_f1.0.mat',1);
title('Original Image with Facial Landmarks');
%% Apply Spatial Transformation using Local Weighted Mean. 
[TFORM] = cp2tform(fpt, model, 'lwm', 49);

%% Register the facial image using transformation matrix
registeredImage = imtransform(example_img, TFORM);
fptNew = FaceTrack(registeredImage,'Chehra_f1.0.mat',0);
subplot(2,2,2);
imshow(registeredImage)
title('Registered Image with Facial Landmarks');
hold on;
plot(fptNew(:,1),fptNew(:,2), 'g*', 'MarkerSize',6);hold off;
hold off

%% Crop the facial image based on the registered image
% Use facial landmarks coordinates around eyes to crop the image
croppedImage = FaceCrop(registeredImage, fptNew, 0);
subplot(2,2,3);
imshow(croppedImage);
title('Cropped Image');

%% Display Cropped Image Gray Level Histogram
subplot(2,2,4);
hist(round(croppedImage(:) * 255),256)
xlim([0 255]);
grid on;
title('Cropped Image Gray Level Histogram');
