function [lbpVector] = genLbpVector(image, m, n)
%genLbpVector Summary of this function goes here
%   Detailed explanation goes here
blocks = im2col(image, [m, n], 'distinct');
[~, cols] = size(blocks);
wholeLBPsets = zeros(cols, 59);
for i = 1:cols
    blockMatrix = reshape(blocks(:,i), [m,n]);
    wholeLBPsets(i, :) = genLBP(blockMatrix);
end
lbpVector = wholeLBPsets(:);

% [rows, ~] = size(blocks);
% cells = mat2cell(blocks, rows, ones(1, cols));
% lbpCells = cellfun(@(x) genLBP(reshape(x, [m n])), cells,...
%     'UniformOutput',false);
% lbpVector = reshape(cell2mat(lbpCells), [], 1);
end

