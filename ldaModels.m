function [models] = ldaModels(W, X, C, numSamples)
%ldaModels Summary of this function goes here
%   Detailed explanation goes here
Y = W.' * X;
models = zeros(C, C-1);
for i = 1 : C
    Yi = Y(:, ((i-1)*numSamples+1):(i*numSamples));
    models(i, :) = mean(Yi, 2);
end
end

