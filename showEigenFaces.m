eigenFaces = pcaEigenfaces(reshape(permute(facesData, [3 4 2 1]), 243*320, []));
figure
eigenFaces = rescale(eigenFaces, 0, 255);
eigenFaces = cast(eigenFaces, 'uint8');
for i = 1:3
    for j = 1:4
        k = (i-1)*4 + j;
        subplot(3,4,k);
        imshow(reshape(eigenFaces(:, k), 243, []));
    end
end