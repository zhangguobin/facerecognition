function [facesData] = load_yale_faces()
%load_yale_faces Summary of this function goes here
%   Detailed explanation goes here
numPersons = 15;
numSamples = 11;
faceHeight = 243;
faceWidth = 320;
prefix = "yalefaces\subject";
middle = num2str(transpose(1:15), "%02d");
postfix = ["centerlight"; "glasses"; "happy"; "leftlight"; "noglasses";...
    "normal"; "rightlight"; "sad"; "sleepy"; "surprised"; "wink"];
postfix = "." + postfix;
filenames = prefix + middle;
filenames = repmat(filenames, 1, numSamples);
filenames = filenames + transpose(postfix);

facesData = zeros(numPersons, numSamples, faceHeight, faceWidth);
for i = 1:numPersons
    for j = 1:numSamples
        facesData(i, j, :, :) = imread(filenames(i, j));
    end
end

end

