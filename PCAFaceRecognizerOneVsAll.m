facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 16;
blockCols = 16;
trainLbpVectors = compileLbpVectors(trainFaces, blockRows, blockCols);
trainData = concatLbpDescriptor(trainFaces, trainLbpVectors);
[eigVec, ~] = pcaEigenfaces(trainData);
trainCoeffes = trainData.' * eigVec;
[~, len] = size(trainCoeffes);
numPersons = 15;
numSamples = 7;
models = zeros(numPersons, 2, len);
for i = 1 : numPersons
    models(i, :, :) = pcaModelOneVsAll(trainCoeffes, numSamples, i);
end

testLbpVectors = compileLbpVectors(testFaces, blockRows, blockCols);
testData = concatLbpDescriptor(testFaces, testLbpVectors);
testCoeffes = testData.' * eigVec;
[~, len] = size(testCoeffes);
reshapedModels = permute(models, [3,2,1]);
reshapedModels = reshape(reshapedModels, len, []);
reshapedModels = repmat(reshapedModels, 60, 1);
testCoeffes = testCoeffes.';
tempCoeffes = testCoeffes(:);
diffCoeffes = abs(tempCoeffes - reshapedModels);

predicts = zeros(numPersons, 4);
for i = 1 : numPersons
    for j = 1 : 4
        index = (i - 1) * 4 + j;
        distancesL1 = sum(diffCoeffes(((index-1)*len+1):(index*len), :));
        distancesL1 = reshape(distancesL1, 2, []);
        results = distancesL1(1,:) < distancesL1(2,:);
        indexs = find(results);
        if isempty(indexs)
            fprintf("image (%d, %d) is not recognized.\n", i, j);
            continue
        end
        [~, I] = min(distancesL1(1, indexs) ./ distancesL1(2, indexs));
        predicts(i, j) = indexs(I);
    end
end
accuracy = sum(predicts == transpose(1:15), 'all') / (numPersons * 4);
fprintf("Face recognition accuracy: %f.\n", accuracy);

% while(1)
%     seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
%     if seq <=0 || seq > 15
%         break;
%     end
%     numTests = 4;
%     testPersons = testData(:, (numTests*(seq-1)+1):(numTests*seq));
%     testCoeffes = testPersons.' * eigVec;
%     [~, len] = size(testCoeffes);
%     reshapedModels = permute(models, [3,2,1]);
%     reshapedModels = reshape(reshapedModels, len, []);
%     reshapedModels = repmat(reshapedModels, numTests, 1);
%     testCoeffes = testCoeffes.';
%     tempCoeffes = testCoeffes(:);
%     distances = abs(tempCoeffes - reshapedModels);
%     for i = 1 : numTests
%         distanceI = sum(distances(((i-1)*len+1):(i*len), :));
%         distanceI = reshape(distanceI, 2, []);
%         results = distanceI(1,:) < distanceI(2,:);
%         indexs = find(results);
%         if isempty(indexs)
%             message = sprintf("image %d is not recognized %d.\n", i);
%             disp(message);
%             continue
%         end
% %         disp(indexs);
% %         disp(distanceI(:, indexs));
% %         disp(distanceI(1, indexs) ./ distanceI(2, indexs));
%         [~, I] = min(distanceI(1, indexs) ./ distanceI(2, indexs));
%         top = indexs(I);
%         fprintf("image %d is recognized as person %d.\n", i, top);
%     end
% end
