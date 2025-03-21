% Script to investigate the need for closure using MLVToolbox
% Author: Vennise Ho
% March 2025

% Load dataset (Doreen's Stimuli)
stimuliFolder = 'exploring_closure'; % Update with actual path
stimuliFile = fullfile(stimuliFolder, 'jitter-stimuli.json');

% Read JSON file with stimuli information
stimuliData = jsondecode(fileread(stimuliFile));

% Initialize results table
resultsTable = table();

% Loop through each stimulus entry
% for i = 1:length(stimuliData)
for i = 1:5
    fileName = fullfile(stimuliFolder, stimuliData(i).image);
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
    totalContourLength = sum(arrayfun(@(x) sum(vecLD.edges{x}.edgelength), 1:length(vecLD.edges)));
    numContours = length(vecLD.edges);

    % Additional properties
    mirrorSymmetry = computeMATproperty(MAT, 'mirror');
    taperSymmetry = computeMATproperty(MAT, 'taper');
    curvature = computeContourProperty(vecLD, 'curvature');
    medialAxisBranches = length(MAT.skeleton); % Number of medial axis branches
    distanceMapMean = mean(MAT.distance_map(:));
    aofMean = mean(MAT.AOF(:));

    % Store results in table
    newRow = table({stimuliData(i).image}, numJunctions, totalContourLength, numContours, ...
                    mirrorSymmetry, taperSymmetry, curvature, medialAxisBranches, ...
                    distanceMapMean, aofMean, ...
                    'VariableNames', {'ImageName', 'Junctions', 'ContourLength', 'NumContours', ...
                                      'MirrorSymmetry', 'TaperSymmetry', 'Curvature', ...
                                      'MedialAxisBranches', 'DistanceMapMean', 'AOFMean'});
    resultsTable = [resultsTable; newRow];

    % Display results
    figure;
    subplot(2, 2, 1);
    drawLinedrawing(vecLD);
    title(['Original Line Drawing - ', stimuliData(i).image]);

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
    outputPath = fullfile('output', ['results_' stimuliData(i).image '.png']);
    saveas(gcf, outputPath);

    fprintf('Analysis complete for %s. Results saved to %s\n', stimuliData(i).image, outputPath);
end

% Save results table to Excel file
writetable(resultsTable, 'closure_analysis_results.xlsx');
fprintf('All property results saved to closure_analysis_results.xlsx\n');
