facesData = load_yale_faces();
testFaces = facesData(:, 5:8, :, :);
trainFaces = facesData(:, [1:4 9:11], :, :);
trainLbp = compileLBPBook(trainFaces);
testLbp = compileLBPBook(testFaces);
trainData = compileAllFeatures(trainFaces, trainLbp);
testData = compileAllFeatures(testFaces, testLbp);
[eigVec, ~] = pcaEigs(trainData);
models = pcaCoeffe(trainData, eigVec, 15, 7);

while(1)
    seq = input('Enter yale face ID (1-15) for recognition (0 stop)\n');
    if seq <=0 || seq > 15
        break;
    end
    testPersons = testData(:, (4*(seq-1)+1):(4*seq));
    testCoeffe = testPersons.' * eigVec;
    for i = 1:4
        top = 1;
        for j = 2:15
            if (norm(testCoeffe(i, :) - models(j, :), 1)) < ...
                    (norm(testCoeffe(i, :) - models(top, :), 1))
                top = j;
            end
        end
        message = sprintf("image %d is recognized as person %d.\n", i, top);
        disp(message);
    end    
end
