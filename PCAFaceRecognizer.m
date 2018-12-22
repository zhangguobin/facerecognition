facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 16;
blockCols = 16;
trainLbpVectors = compileLbpVectors(trainFaces, blockRows, blockCols);
trainData = concatLbpDescriptor(trainFaces, trainLbpVectors);
[eigVec, ~] = pcaEigenfaces(trainData);
models = pcaCoeffe(trainData, eigVec, 15, 7);

testLbpVectors = compileLbpVectors(testFaces, blockRows, blockCols);
testData = concatLbpDescriptor(testFaces, testLbpVectors);

testCoeffe = testData.' * eigVec;
dupTestCoeffe = repmat(testCoeffe, 1, 15);
unrolledModels = reshape(models.', 1, []);
diffs = abs(dupTestCoeffe - unrolledModels);

predicts = zeros(15, 4);
for i = 1:15
    for j = 1:4
        index = (i-1)*4+j;
        distancesL1 = sum(reshape(diffs(index, :), [], 15));
        [~, predicts(i, j)] = min(distancesL1);
    end
end
accuracy = sum(predicts == transpose(1:15), 'all') / (numPersons * 4);
fprintf("Face recognition accuracy: %f.\n", accuracy);

% while(1)
%     seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
%     if seq <=0 || seq > 15
%         break;
%     end
%     testPersons = testData(:, (4*(seq-1)+1):(4*seq));
%     testCoeffe = testPersons.' * eigVec;
%     for i = 1:4
%         top = 1;
%         for j = 2:15
%             if (norm(testCoeffe(i, :) - models(j, :), 1)) < ...
%                     (norm(testCoeffe(i, :) - models(top, :), 1))
%                 top = j;
%             end
%         end
%         message = sprintf("image %d is recognized as person %d.\n", i, top);
%         disp(message);
%     end
% end
