function [lbpDatasets] = compileLBPBook(facesDataset)
%compileLBPBook Summary of this function goes here
%   Detailed explanation goes here
[numPersons, numSamples, ~, ~] = size(facesDataset);
len = length(genLBPFeatures(squeeze(facesDataset(1,1,:,:))));
lbpDatasets = zeros(numPersons, numSamples, len);
for i = 1 : numPersons
    for j = 1 : numSamples
        lbpDatasets(i, j, :) = genLBPFeatures(squeeze(facesDataset(i,j,:,:)));
    end
end