function test_sam_thresholds
    % function to test various SAM thresholds on a selection of images
    
    % clc; clear; close all;
    
    % Define input and output folders
    inputFolder = 'C:\Users\venni\MATLAB\Projects\vennise-fork\MLVcode\vennise-scripts\input_images';  % Folder with test images
    outputFolder = 'C:\Users\venni\MATLAB\Projects\vennise-fork\MLVcode\vennise-scripts\output_images'; % Folder to save results
    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder); % Create output folder if it doesn't exist
    end
    
    % Define threshold values to test
    thresholds = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];

    % Get all images in the input folder
    imageFiles = dir(fullfile(inputFolder, '*.jpg')); % Change to '*.png' if needed
    disp({imageFiles.name});
    
    % Process each image with different ScoreThreshold values
    for i = 1:length(imageFiles)
        fprintf('Image Number: %d \n', i);
        fileName = imageFiles(i).name;
        imgPath = fullfile(inputFolder, fileName);
        img = imread(imgPath);
        
        for t = 1:length(thresholds)
            % Apply Segment Anything Model (SAM) with current threshold
            disp(thresholds(t))
            masks = imsegsam(img, ScoreThreshold=thresholds(t));
            
            % Convert label matrix to edge map
            edges = labelMatrix2edges(labelmatrix(masks));
            
            % Convert edge map to a vectorized line drawing
            vecLD = GetConSeg(edges);  
            disp(length(vecLD));
            
            % Create a figure for the line drawing
            figure;
            drawLinedrawing(vecLD); % Draws the extracted contours
            title(sprintf('Line Drawing (Threshold=%.1f)', thresholds(t)));
            
            % Save the output image
            outputFileName = sprintf('%s_thresh_%.1f.png', fileName(1:end-4), t);
            outputPath = fullfile(outputFolder, outputFileName);
            imwrite(overlayImg, outputPath);
            
            % Display progress
            fprintf('Processed %s with ScoreThreshold=%.1f\n', fileName, t);
        end
    end
    
    disp('Processing complete. Results saved in output_images/');
