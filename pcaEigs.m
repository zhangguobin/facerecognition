function [eigVec,eigVal] = pcaEigs(A)
%pcaEigs Summary of this function goes here
%   Detailed explanation goes here
C = A.' * A;
[V, D] = eig(C);
[d, ind] = sort(diag(D), 'descend');
sortedV = V(:, ind);
totalLambda = sum(d);
topLambda = 0;
for i = 1 : length(d)
    topLambda = topLambda + d(i);
    if topLambda / totalLambda > 0.95
        topVec = sortedV(:, 1:i);
        topVal = d(1:i);
    end
end
eigVec = A * topVec;
eigVal = topVal;
end

