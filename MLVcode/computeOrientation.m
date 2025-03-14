function vecLD = computeOrientation(vecLD)
% vecLD = computeOrientation(vecLD)
%         computes orientations for the contours in the vectorized line
%         drawing vecLD
%         Note that this computes orientations from 0 to 360 degrees.
%         To obtain orientaiton from 0 to 180, use mod(ori,180).
% Input:
%   vecLD - vectorized line drawing data structure
% Output:
%   vecLD - a vector LD of structs with orientation information added

% -----------------------------------------------------
% This file is part of the Mid Level Vision Toolbox: 
% http://www.mlvtoolbox.org
%
% Copyright Dirk Bernhardt-Walther
% University of Toronto, Toronto, Ontario, Canada, 2022
%
% Contact: dirk.walther@gmail.com
%------------------------------------------------------

vecLD.orientations = {};

for c = 1:vecLD.numContours
    thisCon = vecLD.contours{c};  
    vecLD.orientations{c} = mod(atan2d((thisCon(:,2)-thisCon(:,4)),(thisCon(:,3)-thisCon(:,1))),360)';    
    vecLD.contours{c} = thisCon;
end

end