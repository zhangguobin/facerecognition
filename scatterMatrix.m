function [Sbetween, Swithin] = scatterMatrix(X, C, numSamples)
%withinClassScatterMatrix Summary of this function goes here
%   Detailed explanation goes here
[rows, cols] = size(X);
if cols ~= C * numSamples
    error("incorrect inputs!\n");
end

Sbetween = zeros(rows, rows);
Swithin = zeros(rows, rows);
u = mean(X, 2);
for i = 1:C
    samples = X(:, ((i-1)*numSamples+1):(i*numSamples));
    ui = mean(samples, 2);
    Sbetween = Sbetween + (ui - u) * (ui - u).' * numSamples;
    Swithin = Swithin + (samples - ui) * (samples - ui).';
end
end

