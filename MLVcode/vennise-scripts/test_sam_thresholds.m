function test_sam_thresholds
    % function to test various SAM thresholds on a selection of images
    
    tic; % Start timer at the beginning of script
    
    % Open log file for writing
    logFile = fullfile('C:\Users\venni\MATLAB\Projects\vennise-fork\MLVcode\vennise-scripts', 'processing_log.txt');
    fid = fopen(logFile, 'w'); % Open file in write mode
    if fid == -1
        error('Could not open log file for writing.');
    end

    % Define input and output folders
    inputFolder = 'C:\Users\venni\MATLAB\Projects\vennise-fork\MLVcode\vennise-scripts\input_images';  % Folder with test images
    outputFolder = 'C:\Users\venni\MATLAB\Projects\vennise-fork\MLVcode\vennise-scripts\output_images2'; % Folder to save results

    if ~exist(outputFolder, 'dir')
        mkdir(outputFolder); % Create output folder if it doesn't exist
    end
    
    % Define threshold values to test
    thresholds = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];

    % Get all images in the input folder
    imageFiles = dir(fullfile(inputFolder, '*.jpg')); 
    disp({imageFiles.name});
    fprintf(fid, 'Images found: %s\n', strjoin({imageFiles.name}, ', ')); % Save to log file
    
    % Process each image with different ScoreThreshold values
    for i = 1:length(imageFiles)
        fprintf('Image Number: %d \n', i);
        fprintf(fid, 'Image Number: %d \n', i); % Save to log file

        fileName = imageFiles(i).name;
        imgPath = fullfile(inputFolder, fileName);
        img = imread(imgPath);
        
        for t = 1:length(thresholds)
            disp(thresholds(t))
            fprintf(fid, 'Processing with threshold: %.1f\n', thresholds(t)); % Save to log file
            
            % Run traceLineDrawingFromRGB with method = SAM
            masks = imsegsam(img, ScoreThreshold=thresholds(t));
            
            % Convert label matrix to edge map
            edges = labelMatrix2edges(labelmatrix(masks));
            
            % Save only the edge image (line drawing)
            outputFileName = sprintf('%s_thresh_%.1f.png', fileName(1:end-4), thresholds(t));
            outputPath = fullfile(outputFolder, outputFileName);
            imwrite(uint8(~edges) * 255, outputPath); % Save as a black-and-white image
            
            % Display progress
            fprintf('Processed %s with ScoreThreshold=%.1f\n', fileName, thresholds(t));
            fprintf(fid, 'Processed %s with ScoreThreshold=%.1f\n', fileName, thresholds(t));

            % Log elapsed time
            elapsedTime = toc; % Get elapsed time in seconds
            fprintf('Elapsed time: %.2f seconds\n', elapsedTime);
            fprintf(fid, 'Elapsed time: %.2f seconds\n', elapsedTime);
        end
    end
    
    disp('Processing complete. Results saved in output_images/');
    fprintf(fid, 'Processing complete. Results saved in output_images/\n');

    elapsedTime = toc; % Get elapsed time in seconds
    fprintf('Elapsed time: %.2f seconds\n', elapsedTime);
    fprintf(fid, 'Total elapsed time: %.2f seconds\n', elapsedTime);
    
    fclose(fid);
end