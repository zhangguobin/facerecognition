function [lbpFeatures] = genLBPFeatures(image)
%genLBPFeatures Extract local binary pattern (LBP) features
%   Detailed explanation goes here

cells16by16 = im2col(image, [16,16], 'distinct');
[~, cols] = size(cells16by16);
cellBins = zeros(256, cols);
for i = 1:cols
    cellMatrix = reshape(cells16by16(:,i), [16,16]);
    cells3by3 = im2col(cellMatrix, [3,3], 'sliding');
    [~, count] = size(cells3by3);
    tempCells = cells3by3;
    tempCells(5, :) = [];
    results = tempCells >= cells3by3(5, :);
    values = zeros(count);
    bitmasks = num2str(transpose(results));
    for j = 1:count
        temp = bitmasks(j, :);
        temp(isspace(temp)) = '';
        values(j) = bin2dec(temp);
    end
    [cellBins(:, i), ~] = histcounts(values, 0:256);
end
lbpFeatures = cellBins(:);
end

