% Script to investigate the need for closure using MLVToolbox
% Author: Vennise Ho
% March 2025

% Load dataset (Doreen's Stimuli)
stimuliFolder = 'stimuli\Distortion004\FixationOutside\Jitter20_Color-WhiteBackground'; 

% Get list of image files in the folder 
imageFiles = dir(fullfile(stimuliFolder, '*.png')); 

% Display the list of image files
disp(imageFiles);

% Initialize results table with preallocation
numImages = length(imageFiles);
resultsTable = table(cell(numImages, 1), NaN(numImages, 1), NaN(numImages, 1), NaN(numImages, 1), ...
                    NaN(numImages, 1), NaN(numImages, 1), NaN(numImages, 1), NaN(numImages, 1), ...
                    NaN(numImages, 1), NaN(numImages, 1), ...
                    'VariableNames', {'ImageName', 'Junctions', 'ContourLength', 'NumContours', ...
                                      'MirrorSymmetry', 'TaperSymmetry', 'Curvature', ...
                                      'MedialAxisBranches', 'DistanceMapMean', 'AOFMean'});

% Loop through each image in the dataset
for i = 1:5      %numImages          
    fileName = fullfile(imageFiles(i).folder, imageFiles(i).name);
    img = imread(fileName);

    % Extract Line Drawing
    vecLD = traceLineDrawingFromRGB(fileName);
    imgLD = renderLinedrawing(vecLD);

    % Compute Medial Axis Transform (MAT)
    MAT = computeMAT(imgLD, 28);

    % Compute contour properties
    vecLD = computeContourProperties(vecLD);

    % Extract property metrics
    numJunctions = length(vecLD.junctions);  % Example property
    numContours = length(vecLD.numContours);

    % Additional properties
    %[mirrorSymmetryImage, skeletalBranchesMirror] = computeMATproperty(MAT, 'mirror');
    %[taperSymmetryImage, skeletalBranchesTaper] = computeMATproperty(MAT, 'taper');
    curvature = computeCurvature(vecLD);
    medialAxisBranches = length(MAT.skeleton); % Number of medial axis branches
    distanceMapMean = mean(MAT.distance_map(:));
    aofMean = mean(MAT.AOF(:));

    % Store results in table
    resultsTable.ImageName{i} = imageFiles(i).name;
    resultsTable.Junctions(i) = numJunctions;
    resultsTable.NumContours(i) = numContours;
    %resultsTable.MirrorSymmetry(i) = mean(skeletalBranchesMirror(:));  % Take mean of branch ratings
    %resultsTable.TaperSymmetry(i) = mean(skeletalBranchesTaper(:));      % Take mean of branch ratings
    resultsTable.Curvature(i) = curvature;
    resultsTable.MedialAxisBranches(i) = medialAxisBranches;
    resultsTable.DistanceMapMean(i) = distanceMapMean;
    resultsTable.AOFMean(i) = aofMean;

    % Display results
    figure;
    subplot(2, 2, 1);
    drawLinedrawing(vecLD);
    title(['Original Line Drawing - ', imageFiles(i).name]);

    subplot(2, 2, 2);
    imshow(imoverlay(rgb2gray(imgLD), MAT.skeleton, 'b'));
    title('Medial Axis Skeleton');

    subplot(2, 2, 3);
    drawLinedrawingProperty(vecLD, 'orientation');
    title('Contour Orientation');

    subplot(2, 2, 4);
    drawLinedrawingProperty(vecLD, 'junctions');
    title('Contour Junctions');

    % Save results
    outputPath = fullfile('output', ['results_' strrep(imageFiles(i).name, '/', '_') '.png']);
    saveas(gcf, outputPath);

    fprintf('Analysis complete for %s. Results saved to %s\n', imageFiles(i).name, outputPath);
end

% Save results table to Excel file
writetable(resultsTable, 'closure_analysis_results.xlsx');
fprintf('All property results saved to closure_analysis_results.xlsx\n');
