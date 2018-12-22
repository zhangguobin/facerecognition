facesData = load_yale_faces();
numPersons = 15;
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 16;
blockCols = 16;
trainLbpVectors = compileLbpVectors(trainFaces, blockRows, blockCols);
trainData = concatLbpDescriptor(trainFaces, trainLbpVectors);
[eigenVectors, ~] = pcaEigenfaces(trainData);
trainDataReduced = eigenVectors.' * trainData;

[Sb, Sw] = scatterMatrix(trainDataReduced, numPersons, 7);
optimalW = ldaProjectMatrix(Sb, Sw, numPersons);
fisherfaces = ldaModelsOneVsAll(optimalW, trainDataReduced, numPersons, 7);

testLbpVectors = compileLbpVectors(testFaces, blockRows, blockCols);
testData = concatLbpDescriptor(testFaces, testLbpVectors);
testDataReduced = eigenVectors.' * testData;

testProjected = optimalW.' * testDataReduced;
[len, ~] = size(testProjected);
reshapedFisherfaces = reshape(permute(fisherfaces, [3 2 1]),...
    len, 2*numPersons);
reshapedFisherfaces = repmat(reshapedFisherfaces, numPersons * numTests, 1);
faceDiffs = abs(testProjected(:) - reshapedFisherfaces);

numTests = 4;
predicts = zeros(numPersons, 4);
for i = 1 : numPersons
    for j = 1 : numTests
        index = (i-1) * numTests + j;
        distancesL1 = sum(faceDiffs(((index-1)*len+1):index*len, :));
        distancesL1 = reshape(distancesL1, 2, []);
        indexs = find(distancesL1(1, :) < distancesL1(2, :));
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
%     if seq <=0 || seq > numPersons
%         break;
%     end
%     numTests = 4;
%     testPersons = testDataReduced(:, (numTests*(seq-1)+1):(numTests*seq));
%     testProjected = optimalW.' * testPersons;
%     
%     [len, ~] = size(testProjected);
%     reshapedFisherfaces = reshape(permute(fisherfaces, [3 2 1]),...
%         len, 2*numPersons);
%     reshapedFisherfaces = repmat(reshapedFisherfaces, numTests, 1);
%     faceDiffs = abs(testProjected(:) - reshapedFisherfaces);
%     for i = 1 : numTests
%         distancesL1 = sum(faceDiffs(((i-1)*len+1):i*len, :));
%         distancesL1 = reshape(distancesL1, 2, []);
%         indexs = find(distancesL1(1, :) < distancesL1(2, :));
%         disp(indexs);
%         if isempty(indexs)
%             fprintf("image %d is not recognized.\n", i)
%         end
%         [~, I] = min(distancesL1(1, indexs) ./ distancesL1(2, indexs));
%         predict = indexs(I);
%         fprintf("image %d is recognized as person %d.\n", i, predict);
%     end    
% end
