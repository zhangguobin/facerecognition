function [allFeatures] = concatLbpDescriptor(facesData, lbpData)
%concatLbpDescriptor Summary of this function goes here
%   Also do mean mean normalization preprocess
[numPersons, numSamples, height, width] = size(facesData);
[temp1, temp2, lbpLen] = size(lbpData);
if (numPersons ~= temp1) || (numSamples ~= temp2)
    error("dimension inconsistent between facesData and lbpData");
end

allFeatures = zeros(height*width+lbpLen, numPersons*numSamples);

for i = 1 : numPersons
    for j = 1 : numSamples
        image = squeeze(facesData(i, j, :, :));
        % normalize image against mean&std of whole dataset?
        image = normalize(image(:));
        lbp = squeeze(lbpData(i, j, :));
        allFeatures(:, (i-1)*numSamples + j) = [image; lbp];
    end
end
end

