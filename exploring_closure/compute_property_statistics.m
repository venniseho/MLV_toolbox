function result = compute_property_statistics(fileName, vecLD)
    % Compute and store all relevant statistics for the given data
    
    % Initialize result structure
    result = struct();
    result.imageName = fileName;
    result.numContours = vecLD.numContours;
    
    % Orientation
    % result.meanOrientation = mean(vecLD.orientations, 'omitnan');
    % result.minOrientation = min(vecLD.orientations, [], 'omitnan');
    % result.maxOrientation = max(vecLD.orientations, [], 'omitnan');
    % result.stdOrientation = std(vecLD.orientations, 'omitnan');
    % result.medianOrientation = median(vecLD.orientations, 'omitnan');
    [vecLD, ~, ~] = getCurvatureStats(vecLD);
    % Contour Length
    result.meanContourLength = mean(vecLD.contourLengths, 'omitnan');
    result.minContourLength = min(vecLD.contourLengths, [], 'omitnan');
    result.maxContourLength = max(vecLD.contourLengths, [], 'omitnan');
    result.stdContourLength = std(vecLD.contourLengths, 'omitnan');
    result.medianContourLength = median(vecLD.contourLengths, 'omitnan');
    
    % Curvature
    % result.meanCurvature = mean(vecLD.curvatures, 'omitnan');
    % result.minCurvature = min(vecLD.curvatures, [], 'omitnan');
    % result.maxCurvature = max(vecLD.curvatures, [], 'omitnan');
    % result.stdCurvature = std(vecLD.curvatures, 'omitnan');
    % result.medianCurvature = median(vecLD.curvatures, 'omitnan');
    
    % Junctions
    % result.meanJunctions = mean(vecLD.junctions, 'omitnan');
    % result.minJunctions = min(vecLD.junctions, [], 'omitnan');
    % result.maxJunctions = max(vecLD.junctions, [], 'omitnan');
    % result.stdJunctions = std(vecLD.junctions, 'omitnan');
    % result.medianJunctions = median(vecLD.junctions, 'omitnan');
    
    % Separation (from MAT)
    result.meanSeparationMeans = mean(vecLD.separationMeans, 'omitnan');
    result.minSeparationMeans = min(vecLD.separationMeans, [], 'omitnan');
    result.maxSeparationMeans = max(vecLD.separationMeans, [], 'omitnan');
    result.stdSeparationMeans = std(vecLD.separationMeans, 'omitnan');
    result.medianSeparationMeans = median(vecLD.separationMeans, 'omitnan');
    
    return;
end
