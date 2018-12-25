function [allFeatures] = concatLbpDescriptor(facesData, lbpData)
%concatLbpDescriptor Summary of this function goes here
%   Also do normalization preprocessing

global meanImage
meanImage = zeros(243*320, 1);
global trainFinished
trainFinished = false;

[numPersons, numSamples, height, width] = size(facesData);
[temp1, temp2, lbpLen] = size(lbpData);
if (numPersons ~= temp1) || (numSamples ~= temp2)
    error("dimension inconsistent between facesData and lbpData");
end

vectorizedFaces = reshape(permute(facesData, [3 4 2 1]), height*width, []);
vectorizedLbps = reshape(permute(lbpData, [3 2 1]), lbpLen, []);
% rescale LBP to same magnitude of image
vectorizedLbps = rescale(vectorizedLbps, 0, 255);

if ~trainFinished
    meanImage = mean(vectorizedFaces, 2);
    meanLbp = mean(vectorizedLbps, 2);
    trainFinished = true;
end

% Mean subtraction (a.k.a. "mean centering") is necessary for performing
% classical PCA to ensure that the first principal component describes the
% direction of maximum variance If mean subtraction is not performed, the
% first principal component might instead correspond more or less to the
% mean of the data. A mean of zero is needed for finding a basis that
% minimizes the mean square error of the approximation of the data.
vectorizedFaces = vectorizedFaces - meanImage;
vectorizedLbps = vectorizedLbps - meanLbp;
allFeatures = [vectorizedFaces; vectorizedLbps];
end

