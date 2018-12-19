function [allFeatures] = compileAllFeatures(facesData, lbpData)
%compileTrainData Summary of this function goes here
%   Detailed explanation goes here
[numPersons, numSamples, height, width] = size(facesData);
[temp1, temp2, lbpLen] = size(lbpData);
if (numPersons ~= temp1) || (numSamples ~= temp2)
    error("dimension inconsistent between facesData and lbpData");
end

allFeatures = zeros(height*width+lbpLen, numPersons*numSamples);

for i = 1 : numPersons
    for j = 1 : numSamples
        image = squeeze(facesData(i, j, :, :));
        lbp = squeeze(lbpData(i, j, :));
        allFeatures(:, (i-1)*numSamples + j) = [image(:); lbp];
    end
end
end

