facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 30;
blockCols = 40;
trainLbpVectors = compileLbpVectors(trainFaces, blockRows, blockCols);
testLbpVectors = compileLbpVectors(testFaces, blockRows, blockCols);

trainData = concatLbpDescriptor(trainFaces, trainLbpVectors);
testData = concatLbpDescriptor(testFaces, testLbpVectors);

[eigenVectors, ~] = pcaEigenfaces(trainData);

trainDataReduced = eigenVectors.' * trainData;
testDataReduced = eigenVectors.' * testData;

[Sb, Sw] = scatterMatrix(trainDataReduced, 15, 7);
optimalW = ldaProjectMatrix(Sb, Sw, 15);
fisherfaces = ldaModels(optimalW, trainDataReduced, 15, 7);

while(1)
    seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
    if seq <=0 || seq > 15
        break;
    end
    testPersons = testDataReduced(:, (4*(seq-1)+1):(4*seq));
    predict = testPersons.' * optimalW;
    for i = 1:4
        top = 1;
        for j = 2:15
            if (norm(predict(i, :) - fisherfaces(j, :), 1)) < ...
                    (norm(predict(i, :) - fisherfaces(top, :), 1))
                top = j;
            end
        end
        message = sprintf("image %d is recognized as person %d.\n", i, top);
        disp(message);
    end    
end
