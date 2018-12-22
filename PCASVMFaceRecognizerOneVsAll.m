facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 16;
blockCols = 16;
trainLbpVectors = compileLbpVectors(trainFaces, blockRows, blockCols);
trainData = concatLbpDescriptor(trainFaces, trainLbpVectors);
[eigVec, ~] = pcaEigenfaces(trainData);

testLbpVectors = compileLbpVectors(testFaces, blockRows, blockCols);
testData = concatLbpDescriptor(testFaces, testLbpVectors);

trainDataReduced = eigVec.' * trainData;
trainY = repmat((1:15), 7, 1);
trainY = trainY(:);

SVMModels = cell(3,1);
for i = 1:15
    indexs = ((i-1)*7+1):(i*7);
    otherIndexs = setdiff(1:15*7, indexs);
    trainY2Class = trainY;
    trainY2Class(otherIndexs) = 0;
    SVMModels{i} = fitcsvm(trainDataReduced.', trainY2Class,...
        'Standardize',true, 'ClassNames', [0, i]);
end

testDataReduced = eigVec.' * testData;

predictY = zeros(15, 15*4);
pscores = zeros(15, 15*4, 2);
for i = 1:15
    [predictY(i, :), pscores(i, :, :)] = predict(SVMModels{i},...
        testDataReduced.');
end

finalPredictY = zeros(15, 4);
for i = 1:15
    for j = 1:4
        index = (i-1)*4+j;
        k = find(predictY(:, index) ~= 0);
        if isempty(k)
            fprintf('image %d, %d is not recognized', i, j);
            continue
        end
        [~, top] = max(pscores(k, index, 2));
        finalPredictY(i, j) = k(top);
    end
end

accuracy = sum(finalPredictY == transpose(1:15), 'all') / (15 * 4);
fprintf("Face recognition accuracy: %f.\n", accuracy);