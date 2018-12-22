facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
blockRows = 16;
blockCols = 16;
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

% while(1)
%     seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
%     if seq <=0 || seq > 15
%         break;
%     end
%     testPersons = testDataReduced(:, (4*(seq-1)+1):(4*seq));
%     predict = testPersons.' * optimalW;
%     for i = 1:4
%         top = 1;
%         for j = 2:15
%             if (norm(predict(i, :) - fisherfaces(j, :), 1)) < ...
%                     (norm(predict(i, :) - fisherfaces(top, :), 1))
%                 top = j;
%             end
%         end
%         fprintf("image %d is recognized as person %d.\n", i, top);
%     end    
% end

results = zeros(15, 4);
testProjected = optimalW.' * testDataReduced;
reshapedFisherfaces = repmat(fisherfaces.', 60, 1);
diffs = abs(testProjected(:) - reshapedFisherfaces);
for i = 1:15
    for j = 1:4
        index = (i-1) * 4 + j;
        distancesL1 = sum(diffs(((index-1)*len+1):(index*len), :));
        [~, results(i,j)] = min(distancesL1);
    end
end
accuracy = sum(results == transpose(1:15), 'all') / (numPersons * 4);
fprintf("Face recognition accuracy: %f.\n", accuracy);