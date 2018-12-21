function [models] = pcaModelOneVsAll(trainCoeffes, numSamples, oneId)
%pcaModelOneVsAll Summary of this function goes here
%   Detailed explanation goes here
coeffes = trainCoeffes;
[~, len] = size(coeffes);
models = zeros(2, len);
sampleIdx = (oneId-1) * numSamples + 1;
samples = coeffes(sampleIdx:(oneId*numSamples), :);
models(1, :) = mean(samples);
coeffes(sampleIdx:(oneId*numSamples), :) = [];
models(2, :) = mean(coeffes);
end

