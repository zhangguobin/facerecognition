function [models] = pcaCoeffe(A, eigVec, numPersons, numSamples)
%pcaCoeffe Summary of this function goes here
%   Detailed explanation goes here
coeffes = A.' * eigVec;
[~, len] = size(coeffes);
models = zeros(numPersons, len);
for i = 1 : numPersons
    models(i, :) = mean(coeffes(((i-1)*numSamples+1):(i*numSamples), :));
end
end

