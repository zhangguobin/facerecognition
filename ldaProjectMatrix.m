function [optimalW] = ldaProjectMatrix(Sbetween, Swithin, C)
%ldaProjectMatrix Summary of this function goes here
%   Detailed explanation goes here
[V, D] = eig(pinv(Swithin) * Sbetween);
[~, ind] = sort(diag(D), 'descend');
optimalW = V(:, ind(1:(C-1)));
end

