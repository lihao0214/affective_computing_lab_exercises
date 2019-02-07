%% Details 
% Author : Awais Aslam
% Student Number : 2473910 
% Email : awais.aslam@student.oulu.fi
% Date : 09.07.2016

%% 

%% Local Binary Pattern Histogram of norm_face 

mapping = getmapping(8,'u2');
LBPHist = lbp(norm_face, 1, 8, mapping , 'h');

subplot(2,1,1);
bar(LBPHist);
title('Local Binary Pattern Histogram');
grid on;


%% LBP-TOP Features Extraction 

mapping = getmapping(8,'u2');

Rx = 3;
Ry = 3;
Rt = 3;
P = 8;
rows = 1;
cols = 1;
tblocks = 1;
overatio = 0;
videoHist = LBPTOP(example_crop_video, Rx, Ry, Rt, [P P P], Rx, Ry, rows, cols, tblocks, overatio, 'u2');

subplot(2,1,2);
bar(videoHist);
title('LBPTOP Histogram');
grid on;