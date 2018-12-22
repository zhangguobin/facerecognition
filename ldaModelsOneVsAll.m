function [models] = ldaModelsOneVsAll(W, X, C, numSamples)
%ldaModelsOneVsAll Summary of this function goes here
%   Detailed explanation goes here
Y = W.' * X;
models = zeros(C, 2, C-1);
for i = 1 : C
    indexsI = ((i-1)*numSamples+1):(i*numSamples);
    otherIndexs = setdiff(1:C*numSamples, indexsI);
    models(i, 1, :) = mean(Y(:, indexsI), 2);
    models(i, 2, :) = mean(Y(:, otherIndexs), 2);
end
end

