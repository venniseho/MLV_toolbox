% Script to Compute Visual Properties for Closure Analysis

% Clear workspace and set up MLV toolbox
% clear; clc;
% setup; 

% INPUT IMAGE 
fileName = 'stimuli/train/3/complete3_n1_b0_c0.jpg'; 
img = imread(fileName);

% CONVERT IMAGE TO LINE DRAWING
vecLD = traceLineDrawingFromRGB(fileName, 'SAM', 0.5);
imgLD = renderLinedrawing(vecLD);

% COMPUTE MEDIAL AXIS TRANSFORM (MAT)
MAT = computeMAT(imgLD, 28); % Threshold = 28 degrees for medial axis continuity
[MATcontourImages, MATskeletonImages, skeletalBranches] = computeAllMATproperties(MAT, imgLD);

% COMPUTE CONTOUR PROPERTIES 
vecLD = computeContourProperties(vecLD);

% --- DISPLAY RESULTS ---
figure;
subplot(2, 3, 1); imshow(img); title('Original Image');
subplot(2, 3, 2); drawLinedrawing(vecLD); title('Line Drawing');
subplot(2, 3, 3); drawMATproperty(MATskeletonImages, 'separation'); title('Medial Axis');
subplot(2, 3, 4); drawLinedrawingProperty(vecLD, 'orientation'); title('Orientation');
subplot(2, 3, 5); drawLinedrawingProperty(vecLD, 'junctions'); title('Junctions');

