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

% [~, ~, imageH, imageW] = size(facesDataset);
% imageSize = imageH*imageW;
% temp = reshape(permute(facesDataset, [3 4 2 1]), imageSize, []);
% faceCells = mat2cell(temp, imageSize,...
%     ones(1, numPersons * numSamples));
% lbpCells = cellfun(@(x) genLbpVector(reshape(x, imageH, []), W, H),...
%     faceCells, 'UniformOutput',false);
% lbpVectors = cell2mat(lbpCells);
% lbpVectors = permute(reshape(lbpVectors, [], numSamples, numPersons), [3 2 1]);
end