function [uniformLbp] = genLBP(image)
%genLBP Extract local binary pattern (LBP) features
%    (8,1) neighborhood, uniform extension

cells3by3 = im2col(image, [3,3], 'sliding');
tempCells = cells3by3;
tempCells(5, :) = [];
results = tempCells >= cells3by3(5, :);
% permute rows by couter-clockwise from top-left
% idx = [1 2 3 5 8 7 6 4];
% clockwise from the center right
% idx = [7 6 4 1 2 3 5 8];
% patterns = num2str(transpose(results(idx, :)));
% values = arrayfun(@(pattern) bin2dec(strrep(pattern, ' ', '')),...
%     string(patterns));

patterns = num2str(transpose(results));
[~, count] = size(cells3by3);
values = zeros(1, count);
for j = 1:count
    temp = patterns(j, :);
    temp(isspace(temp)) = '';
    values(j) = bin2dec(temp);
end
lbpFeatures = histcounts(values, 0:256);

% uniform LBP
% TODO get rid of hard coding
uniPatterns = [0, 1, 2, 3, 4, 6, 7, 8, 12, 14, 15, 16, 24, 28,...
    30, 31, 32, 48, 56, 60, 62, 63, 64, 96, 112, 120, 124, 126, 127,...
    128, 129, 131, 135, 143, 159, 191, 192, 193, 195, 199, 207, 223,...
    224, 225, 227, 231, 239, 240, 241, 243, 247, 248, 249, 251, 252,...
    253, 254, 255];
otherPatterns = setdiff(0:255, uniPatterns);
uniformLbp = zeros(1, 59);
uniformLbp(1:58) = lbpFeatures(uniPatterns + 1);
uniformLbp(59) = sum(lbpFeatures(otherPatterns + 1));
end

