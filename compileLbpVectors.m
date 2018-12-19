function [lbpVectors] = compileLbpVectors(facesDataset, W, H)
%compileLbpVectors Summary of this function goes here
%   Detailed explanation goes here
[numPersons, numSamples, ~, ~] = size(facesDataset);
temp = squeeze(facesDataset(1,1,:,:));
len = length(genLbpVector(temp, W, H));
lbpVectors = zeros(numPersons, numSamples, len);
for i = 1 : numPersons
    for j = 1 : numSamples
        image = squeeze(facesDataset(i,j,:,:));
        lbpVectors(i, j, :) = genLbpVector(image, W, H);
    end
end