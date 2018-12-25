[eigenFaces, eigVal] = pcaEigenfaces(reshape(permute(facesData, [3 4 2 1]), 243*320, []));
figure
eigenFaces = rescale(eigenFaces, 0, 255);
eigenFaces = cast(eigenFaces, 'uint8');
numEigenfaces = size(eigenFaces, 2);
cols = 4;
rows = 2;
for i = 1:rows
    for j = 1:cols
        k = (i-1)*cols + j;
        if k > numEigenfaces
            break
        end
        subplot(rows, cols,k);
        imshow(reshape(eigenFaces(:, k), 243, []));
    end
end