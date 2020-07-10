function [imgPacked] = myNDNet_Postprocess(Iori, num, bbox, scores, wi, he, ch, HeatMap)

%% Parameters of input image
% wi = 640;
% he = 480;
% ch = 3;
coder.gpu.kernelfun

labeltbl = {'Defective';'Good'};
colortbl = [255 255 102; 73 6 248];

%% Insert annotation as an post-processing
img2 = Iori;
for i = 1:num
    idx = (scores(1, i) < scores(2, i)) + 1;
    bbox = round(bbox);
    img2 = insertObjectAnnotation(img2, 'rectangle', bbox(i,:),...
        labeltbl{idx}, 'FontSize', 16, 'Color', colortbl(idx,:));    
    tmp = imresize(HeatMap(:,:,:,i), [bbox(i,4)+1 bbox(i,3)+1]);
    img2(bbox(i,2):bbox(i,2)+bbox(i,4),bbox(i,1):bbox(i,1)+bbox(i,3),:) = tmp;
end

%% Convert image data format to OpenCV compatible image format
imgPacked = coder.nullcopy(zeros([1,he*wi*ch], 'uint8'));

for i = 1:he
    for j = 1:wi
        imgPacked((i-1)*wi*ch + (j-1)*ch + 3) = img2(i,j,1);
        imgPacked((i-1)*wi*ch + (j-1)*ch + 2) = img2(i,j,2);
        imgPacked((i-1)*wi*ch + (j-1)*ch + 1) = img2(i,j,3);
    end
end

end

%%  Copyright 2020 The MathWorks, Inc.