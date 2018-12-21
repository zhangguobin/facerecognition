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

while(1)
    seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
    if seq <=0 || seq > 15
        break;
    end
    numTests = 4;
    testPersons = testData(:, (numTests*(seq-1)+1):(numTests*seq));
    testCoeffes = testPersons.' * eigVec;
    [~, len] = size(testCoeffes);
    tempModels = permute(models, [3,2,1]);
    tempModels = reshape(tempModels, len, []);
    tempModels = repmat(tempModels, numTests, 1);
    testCoeffes = testCoeffes.';
    tempCoeffes = testCoeffes(:);
    distances = abs(tempCoeffes - tempModels);
    for i = 1 : numTests
        distanceI = sum(distances(((i-1)*len+1):(i*len), :));
        distanceI = reshape(distanceI, 2, []);
        results = distanceI(1,:) < distanceI(2,:);
        indexs = find(results);
        if isempty(indexs)
            message = sprintf("image %d is not recognized %d.\n", i);
            disp(message);
            continue
        end
%         disp(indexs);
%         disp(distanceI(:, indexs));
%         disp(distanceI(1, indexs) ./ distanceI(2, indexs));
        [~, I] = min(distanceI(1, indexs) ./ distanceI(2, indexs));
        top = indexs(I);
        message = sprintf("image %d is recognized as person %d.\n", i, top);
        disp(message);
    end
end
