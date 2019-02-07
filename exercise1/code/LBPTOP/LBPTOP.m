function Histogram = LBPTOP(VolData, FxRadius, FyRadius, TInterval, NeighborPoints, TimeLength, BorderLength, rows, cols, timePart, overatio, mappingtype)
% Readme
% Compute LBP in each block, and then concatenate the histogram of each
% block to get the long histograms for one sequence
% original C++ version by Dr. Zhao

% Parameter

% VolData: the video data (H*W*F)
% FxRadius: the radius along the X direction
% FyRadius: the radius along the Y direction
% TInterval: the radius along the T direction
% NeighborPoints: the number of neighbors on three planes [Pxy, Pxt, Pyt]
% BorderLength/TimeLength: the length of border on an image (please note that this length should be consistent to radius)
% rows: the number of row blocks
% cols: the number of colume blocks
% timePart: the number of time blocks
% overatio: the overlapping ratio on XY plane
% mappingtype: the mapping table for LBP

% Example

% Rx = 3;
% Ry = 3;
% Rt = 3;
% P = 8;
% rows = 4;
% cols = 4;
% tblocks = 1;
% overatio = 0;
% video_hist = LBPTOP(video_data, Rx, Ry, Rt, [P P P], Rx, Ry, rows, cols, tblocks, overatio, 'u2')

% Modified Log:
% 08.2010 --  create the original LBP-TOP code
% 29.10.2011 -- add the function 'getmapping' and permit differnt number of neighbors in three planes)
% 'u2'   for uniform LBP (0-57; uniform, 58: no uniform, different from C++ version
% 24.8.2012 -- fix one bug
% 	 CodeXY = 0 : 2 ^ XYNeighborPoints - 1;
%    CodeXT = 0 : 2 ^ XTNeighborPoints - 1;
%    CodeYT = 0 : 2 ^ YTNeighborPoints - 1;
% 15.5.2015 -- remove overlapping ratio function (the parameter: overatio) in
% 15.5.2015 -- modify getmapping.m for later than Matlab R2013a
%    Change j = bitset(bitshift(i,1,samples),1,bitget(i,samples)); %rotate left
%    to     j = bitset(bitshift(i,1,'uint8'),1,bitget(i,samples)); %rotate left

% References:
% [1] G. Zhao, M. Pietikainen. Dynamic texture recognition using local
% binary pattern with an application to facial expressions. IEEE PAMI,
% 29(6), pp. 915-928, 2007f

%%

XYNeighborPoints = NeighborPoints(1);
XTNeighborPoints = NeighborPoints(2);
YTNeighborPoints = NeighborPoints(3);

if strcmp(mappingtype, 'u2') % uniform
    a = getmapping(XYNeighborPoints, mappingtype);
    CodeXY = a.table;
    b = getmapping(XTNeighborPoints, mappingtype);
    CodeXT = b.table;
    c = getmapping(YTNeighborPoints, mappingtype);
    CodeYT = c.table;
else % use the normal
    CodeXY = 0 : 2 ^ XYNeighborPoints - 1;
    CodeXT = 0 : 2 ^ XTNeighborPoints - 1;
    CodeYT = 0 : 2 ^ YTNeighborPoints - 1;
end

% The number of neighbors in three planes may be different
BinXY = length(unique(CodeXY));
BinXT = length(unique(CodeXT));
BinYT = length(unique(CodeYT));
Bincount = max([BinXY, BinXT, BinYT]); % pre-define matrix

%% revised this bug (rows * cols * 3)
Histogram = zeros(rows * cols * timePart * 3, Bincount);

[height, width, frameNum] = size(VolData);

firstF = 0;
lastF = frameNum - 1;

ToverSize = 1;

%% go through all frames
for i = firstF + TimeLength : lastF - TimeLength
    % for every frame, get its previous and posterior frame
    pFrame = zeros(height, width, 2 * TInterval + 1);
    for j = -TInterval : TInterval
        pFrame(:, :, j + TInterval + 1) = VolData(:, :, i + j + 1); % previous, current and posterior frame
        % if first frame
        if (i == firstF + TimeLength) && (j == -TInterval)
            if (1 - overatio) < 0.000001
                XoverSize = 10;
                YoverSize = 10;
            else
                % Original block size
                NooverBlockW = ceil((width - BorderLength * 2) / cols) - 1;
                NooverBlockH = ceil((height - BorderLength * 2) / rows) - 1;
                XoverSize = ceil(NooverBlockW * overatio) - 1;
                YoverSize = ceil(NooverBlockH * overatio) - 1;
                % correct the case when over ratio is 0
                if XoverSize < 0
                    XoverSize = 0;
                end
                if YoverSize < 0
                    YoverSize = 0;
                end
                % To compute the block size after overlapping
                BlockW = floor((width - BorderLength * 2 + XoverSize * (cols - 1)) / cols);
                BlockH = floor((height - BorderLength * 2 + YoverSize * (rows - 1)) / rows);
                BlockT = floor((frameNum - TimeLength * 2 + ToverSize * (timePart - 1))/timePart);
            end
        end
    end
    
    % fixed code
    if (i - firstF - TimeLength - BlockT < 0)
        CurT = 0;
    else
        CurT = ceil((i - firstF - TimeLength - BlockT)/(BlockT - ToverSize) + 1) - 1;
    end
    
    if (CurT >= timePart)
        CurT = timePart - 1;
    end
    
    NexT = ceil((i - firstF - TimeLength + (CurT + 1) * ToverSize)/BlockT) - 1;
    if NexT >= timePart
        NexT = timePart - 1;
    end
    
    % The coordinate among C and Matlab is different. C: 0   Matlab: 1
    for yc = BorderLength + 1: height - BorderLength
        for xc = BorderLength + 1 : width - BorderLength
            
            if (yc - BorderLength - BlockH - 1 < 0)
                CurRows = 0;
            else
                CurRows = floor((yc - BorderLength - BlockH - 1) / (BlockH - YoverSize) + 1);
            end
            
            if (xc - BorderLength - BlockW - 1 < 0)
                CurCols = 0;
            else
                CurCols =floor((xc - BorderLength - BlockW - 1) / (BlockW - XoverSize) + 1);
            end
            
            if CurRows >= rows
                CurRows = rows - 1;
            end
            
            if CurCols >= cols
                CurCols = cols - 1;
            end
            
            % overlapping area, points belong to CurRows and CurCols
            % also belong to the NewRows and NewCols
            NexRows = ceil((yc - BorderLength + (CurRows + 1) * YoverSize) / BlockH) - 1;
            NexCols = ceil((xc - BorderLength + (CurCols + 1) * XoverSize) / BlockW) - 1;
            
            if (NexRows >= rows)
                NexRows = rows - 1;
            end
            
            if (NexCols >= cols)
                NexCols = cols - 1;
            end
            
            BasicLBP = 1;
            CenterVal = pFrame(yc, xc, TInterval + 1);
            %% In XY plane, compute the LBP code
            
            for p = 1 : XYNeighborPoints
                x = floor(xc + FxRadius * cos((2 * pi * (p - 1)) / XYNeighborPoints) + 0.5);
                y = floor(yc - FyRadius * sin((2 * pi * (p - 1)) / XYNeighborPoints) + 0.5);
                CurrentVal = pFrame(y, x, TInterval + 1);
                if CurrentVal >= CenterVal
                    BasicLBP = BasicLBP + 2 ^ (p - 1);
                end
            end
            
            Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 1, CodeXY(1, BasicLBP) + 1) = Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 1, CodeXY(1, BasicLBP) + 1) + 1;
            
            if ((NexRows ~= CurRows) || (NexCols ~= CurCols) || (NexT ~= CurT))
                Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 1,  CodeXY(1, BasicLBP) + 1) = Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 1,  CodeXY(1, BasicLBP) + 1) + 1;
            end
            
            %% XT-plane
            
            BasicLBP = 1;
            for p = 1 : XTNeighborPoints
                x = floor(xc + FxRadius * cos((2 * pi * (p - 1)) / XTNeighborPoints) + 0.5);
                z = floor(i - TInterval * sin((2 * pi * (p - 1)) / XTNeighborPoints) + 0.5);
                CurrentVal = pFrame(yc, x, z - i + TInterval + 1);
                if CurrentVal >= CenterVal
                    BasicLBP = BasicLBP + 2 ^ (p - 1);
                end
            end
            
            Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 2, CodeXT(1, BasicLBP) + 1) = Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 2, CodeXT(1, BasicLBP) + 1) + 1;
            if ((NexRows ~= CurRows) || (NexCols ~= CurCols) || (NexT ~= CurT))
                Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 2,  CodeXT(1, BasicLBP) + 1) = Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 2,  CodeXT(1, BasicLBP) + 1) + 1;
            end
            
            %% YT-plane
            
            BasicLBP = 1;
            for p = 1 : YTNeighborPoints
                y = floor(yc - FxRadius * cos((2 * pi * (p - 1)) / YTNeighborPoints) + 0.5);
                z = floor(i - TInterval * sin((2 * pi * (p - 1)) / YTNeighborPoints) + 0.5);
                CurrentVal = pFrame(y, xc, z - i + TInterval + 1);
                if (CurrentVal >= CenterVal)
                    BasicLBP = BasicLBP + 2 ^ (p - 1);
                end
            end
            
            Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 3, CodeYT(1, BasicLBP) + 1) = Histogram((CurT * (rows * cols) + CurRows * cols + CurCols) * 3 + 3, CodeYT(1, BasicLBP) + 1) + 1;
            
            if ((NexRows ~= CurRows) || (NexCols ~= CurCols) || (NexT ~= CurT))
                
                Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 3,  CodeYT(1, BasicLBP) + 1) = Histogram((NexT * (rows * cols) + NexRows * cols + NexCols) * 3 + 3,  CodeYT(1, BasicLBP) + 1) + 1;
                
            end
        end
    end
end

%% Normalize the histogram
[m, n] = size(Histogram);
Histogram = reshape(Histogram', 1, m * n);
if (BinXY == BinXT) && (BinXY == BinYT) && (BinXT == BinYT)
    Histogram = Histogram./sum(Histogram);
else
    HistXY = Histogram(1 : BinXY);
    HistXT = Histogram(Bincount + 1 : Bincount + BinXT);
    HistYT = Histogram(2 * Bincount + 1 : 2 * Bincount + BinYT);
    Histogram = [HistXY HistXT HistYT];
    Histogram = mean(Histogram);
end