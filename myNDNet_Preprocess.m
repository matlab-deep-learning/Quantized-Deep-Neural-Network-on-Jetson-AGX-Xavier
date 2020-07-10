function [Iori, nuts, num1, bbox] = myNDNet_Preprocess(inImg)
%#codegen
coder.gpu.kernelfun

%% Parameters of input image
sz = size(inImg);
wi = sz(2);
he = sz(1);
ch = sz(3);

ratio = wi*he*ch / 921600;
imgSz = 227;

%% Convert image data format to MATLAB compatible image format
Iori = coder.nullcopy(zeros([he,wi,ch], 'uint8'));
%Iori = inImg;
% r = reshape(inImg(3:3:end), [he,wi]);
% g = reshape(inImg(2:3:end), [he,wi]);
% b = reshape(inImg(1:3:end), [he,wi]);
% Iori = cat(3, r, g, b);
for i = 1:he
    for j = 1:wi
        Iori(i,j,3) = inImg((i-1)*wi*ch + (j-1)*ch+1);
        Iori(i,j,2) = inImg((i-1)*wi*ch + (j-1)*ch+2);
        Iori(i,j,1) = inImg((i-1)*wi*ch + (j-1)*ch+3);
    end
end

%% Extract where the nuts are, as an ROI
hsv = rgb2hsv(Iori); %RGB to HSV color space conversion
th = otsuthresh(imhist(hsv(:,:,2))); %Binarize image
bw = hsv(:,:,2) < th;
bw = bwareaopen(bw, 20000*ratio); %Remove noise

%% Measure boundingbox of roi instead of using regionprops
bwl = bwlabel(bw);
num = max(bwl(:));

gray = rgb2gray(Iori);
gray = imadjust(gray);

bbox = coder.nullcopy(zeros(4));
nuts = coder.nullcopy(zeros([imgSz,imgSz,4], 'uint8'));
k=0;
if num > 0 && num < 5
    for i = 1:num
        [r, c] = find(bwl == i);
        rmin = min(r);
        rmax = max(r);
        cmin = min(c);
        cmax = max(c);
        %Crop the image if measured area is in a specified range
        if (cmax-cmin) * (rmax-rmin) < 20000 && rmin >0 && cmin >0
        k=k+1;
        bbox(k, :) = [cmin, rmin, cmax-cmin, rmax-rmin];
        tmp = imcrop(gray, bbox(k,:));
        nuts(:,:,k) = imresize(tmp, [imgSz imgSz]);
        end
    end
    num1 = k;
else
    num1 = 0;
end

end


%%  Copyright 2020 The MathWorks, Inc.