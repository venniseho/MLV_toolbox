% Script to Compute Visual Properties for Closure Analysis

% INPUT FOLDERS
inputFolder = 'stimuli/dataset_acc_test'; 

% OPEN LOG FILE
fid = fopen('processing_log.txt', 'w');

% add for loop
for folder_num = 3:3
    inputFolder = sprintf('%s/%d', inputFolder, folder_num);
    outputFolder = sprintf('%d_output.png', folder_num);

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder); % Create output folder if it doesn't exist
    end
    
    imageFiles = dir(fullfile(inputFolder, '*.jpg')); 
    num_images = length(imageFiles);

    % INIT EMPTY RESULTS TABLE (for property stats)
    resultsTable = table();

    for image_num = 1:1
        fprintf('Image Number: %d of %d \n', image_num, num_images);
        fprintf(fid, 'Image Number: %d of %d \n', image_num, num_images); % Save to log file
    
        fileName = imageFiles(image_num).name;
        imgPath = fullfile(inputFolder, fileName);
    
        % CONVERT IMAGE TO LINE DRAWING
        vecLD = traceLineDrawingFromRGB(imgPath);
        imgLD = renderLinedrawing(vecLD);
    
        % COMPUTE CONTOUR PROPERTIES 
        vecLD = computeContourProperties(vecLD);

        % COMPUTE MEDIAL AXIS TRANSFORM (MAT)
        MAT = computeMAT(imgLD);
        [MATimg,MATskeletonImages,skeletalBranches] = computeAllMATproperties(MAT,img);
        properties = fieldnames(MATimg);
        for p = 1:length(properties)
            thisPropImg = mapMATtoContour(skeletalBranches,img,MATskeletonImages.(properties{p}));
            vecLD = MATpropertiesToContours(vecLD,thisPropImg,properties{p});
            vecLD = getMATpropertyStats(vecLD,properties{p});
        end
    
        % --- SAVE IMAGE RESULTS ---
        fig = figure('Visible', 'off');
        
        % Plot the results
        subplot(2, 3, 1); imshow(img); title('Original Image');
        subplot(2, 3, 2); drawLinedrawing(vecLD); title('Line Drawing');
        subplot(2, 3, 3); drawMATproperty(vecLD, 'separation'); title('Medial Axis');
        subplot(2, 3, 4); drawLinedrawingProperty(vecLD, 'orientation'); title('Orientation');
        subplot(2, 3, 5); drawLinedrawingProperty(vecLD, 'junctions'); title('Junctions');
        
        % Define output folder and ensure it exists
        outputFolder = 'output_results'; 
        if ~exist(outputFolder, 'dir')
            mkdir(outputFolder);
        end
        
        % Save the figure as an image
        outputFileName = fullfile(outputFolder, sprintf('%s_results.png', fileName(1:end-4)));
        saveas(fig, outputFileName);
        
        % Close the figure 
        close(fig);
        
        fprintf('Image saved to %s\n', outputFileName);
        
        % --- SAVE PROPERTY STATS TO EXCEL ---
        % Save computed properties in a structure
        result = compute_property_statistics(outputFileName, vecLD);
        
        % Append result to table
        resultsTable = [resultsTable; struct2table(result)];
    end

    % Save results to Excel
    outputFile = fullfile(outputFolder, sprintf('computed_properties_%d.xlsx', folder_num));
    writetable(resultsTable, outputFile);
    
    fprintf('All properties stats saved to %s\n', outputFile);
end


