function [uniformLbp] = genLBP(image)
%genLBP Extract local binary pattern (LBP) features
%   Detailed explanation goes here

cells16by16 = im2col(image, [16,16], 'distinct');
[~, cols] = size(cells16by16);
lbpFeatures = zeros(1, 256);
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
    lbpFeatures = lbpFeatures + histcounts(values, 0:256);
end
% uniform LBP
% TODO get rid of hard coding
uniPatterns = [0, 1, 2, 3, 4, 6, 7, 8, 12, 14, 15, 16, 24, 28,...
    30, 31, 32, 48, 56, 60, 62, 63, 64, 96, 112, 120, 124, 126, 127,...
    128, 129, 131, 135, 143, 159, 191, 192, 193, 195, 199, 207, 223,...
    224, 225, 227, 231, 239, 240, 241, 243, 247, 248, 249, 251, 252,...
    253, 254, 255];
uniformLbp = zeros(1, 59);
uniformLbp(1:58) = lbpFeatures(uniPatterns+1);
uniformLbp(59) = sum(lbpFeatures) - sum(uniformLbp(1:58));
end

