% Script to Compute Visual Properties for Closure Analysis

% INPUT/OUTPUT FOLDERS
inputFolder = 'stimuli/dataset_acc_test'; 
outputFolder = 'output_results'; 
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end

% OPEN LOG FILE
fid = fopen('processing_log.txt', 'w');

% add for loop
for folder_num = 3:12
    fprintf('Folder Number: %d of 12 \n', folder_num);
    fprintf(fid, 'Folder Number: %d of 12 \n', folder_num); % Save to log file
    
    inputSubFolder = sprintf('%s/%d', inputFolder, folder_num);

    outputSubFolder = sprintf('%s/%d_output.png', outputFolder, folder_num);
    if ~exist(outputSubFolder, 'dir')
        mkdir(outputSubFolder); % Create output folder if it doesn't exist
    end
    
    imageFiles = dir(fullfile(inputSubFolder, '*.jpg')); 
    num_images = length(imageFiles);

    % INIT EMPTY RESULTS TABLE (for property stats)
    resultsTable = table();

    for image_num = 1:num_images
        fprintf('Image Number: %d of %d \n', image_num, num_images);
        fprintf(fid, 'Image Number: %d of %d \n', image_num, num_images); % Save to log file
    
        fileName = imageFiles(image_num).name;
        imgPath = fullfile(inputSubFolder, fileName);

        if exist(imgPath, 'file')
            fprintf('Results for folder %d already exist. Skipping...\n', image_num);
            fprintf(fid, 'Results for folder %d already exist. Skipping...\n', image_num);
            continue; 
        end
    
        % CONVERT IMAGE TO LINE DRAWING
        vecLD = traceLineDrawingFromRGB(imgPath, 'SAM', 0.1);
        imgLD = renderLinedrawing(vecLD);
    
        % COMPUTE CONTOUR PROPERTIES 
        vecLD = computeContourProperties(vecLD);
        
        % --- COMPUTE KEY PROPERTIES FOR CLOSURE ANALYSIS ---
        [vecLD, curvatureHistogram, curvatureBins] = getCurvatureStats(vecLD);
        [vecLD, junctionHistogram] = getJunctionStats(vecLD);
        [vecLD, contourHistogram] = getLengthStats(vecLD);

        % COMPUTE MEDIAL AXIS TRANSFORM (MAT)
        MAT = computeMAT(imgLD);
        [MATimg,MATskeletonImages,skeletalBranches] = computeAllMATproperties(MAT,imgLD);
        properties = fieldnames(MATimg);
        for p = 1:length(properties)
            thisPropImg = mapMATtoContour(skeletalBranches,imgLD,MATskeletonImages.(properties{p}));
            vecLD = MATpropertiesToContours(vecLD,thisPropImg,properties{p});
            vecLD = getMATpropertyStats(vecLD,properties{p});
        end
    
        % SAVE IMAGE RESULTS
        fig = figure('Visible', 'off');
        
        % Plot the results
        subplot(2, 3, 1); imshow(imgPath); title('Original Image');
        subplot(2, 3, 2); drawLinedrawing(vecLD); title('Line Drawing');
        subplot(2, 3, 3); imshow(imoverlay(rgb2gray(imgLD),MAT.skeleton,'b'))
        subplot(2, 3, 4); drawMATproperty(vecLD, 'separation'); title('Separation');
        subplot(2, 3, 5); drawLinedrawingProperty(vecLD, 'orientation'); title('Orientation');
        subplot(2, 3, 6); drawLinedrawingProperty(vecLD, 'junctions'); title('Junctions');
        
        % Save the figure as an image
        outputFileName = fullfile(outputSubFolder, sprintf('%s_results.png', fileName(1:end-4)));
        saveas(fig, outputFileName);
        
        % Close the figure 
        close(fig);
        
        fprintf('Image saved to %s\n', outputFileName);
        
        % SAVE PROPERTY STATS TO EXCEL
        % Save computed properties in a structure
        % result = compute_property_statistics(outputFileName, vecLD);
        result = struct();
        result.ImageName = fileName;
        result.meanContourLength = mean(vecLD.contourLengths, 'omitnan');
        result.medianContourLength = median(vecLD.contourLengths, 'omitnan');
        result.minContourLength = min(vecLD.contourLengths, [], 'omitnan');
        result.maxContourLength = max(vecLD.contourLengths, [], 'omitnan');
        result.stdContourLength = std(vecLD.contourLengths, 'omitnan');
        result.ContourHistogram = contourHistogram;

        result.CurvatureHistogram = curvatureHistogram;
        
        result.JunctionHistogram = junctionHistogram;
       
        result.meanSeparationMeans = mean(vecLD.separationMeans, 'omitnan');
        result.minSeparationMeans = min(vecLD.separationMeans, [], 'omitnan');
        result.maxSeparationMeans = max(vecLD.separationMeans, [], 'omitnan');
        result.stdSeparationMeans = std(vecLD.separationMeans, 'omitnan');
        result.medianSeparationMeans = median(vecLD.separationMeans, 'omitnan');

        % Append result to table
        resultsTable = [resultsTable; struct2table(result)];
    end

    % Save results to Excel
    outputFile = fullfile(outputSubFolder, sprintf('computed_properties_%d.xlsx', folder_num));
    writetable(resultsTable, outputFile);
    
    fprintf('All properties stats saved to %s\n', outputFile);
    fprintf(fid, 'All properties stats saved to %s\n', outputFile); % Save to log file
    fprintf(fid, '----------------------------------------------------');
end


