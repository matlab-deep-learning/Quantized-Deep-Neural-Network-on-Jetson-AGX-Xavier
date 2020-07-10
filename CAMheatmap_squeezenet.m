function HeatMap = CAMheatmap_squeezenet(image,act,scores,Weights)

coder.gpu.kernelfun

imageActivations = act;

% check the classified category from scores
if scores(1) > scores(2)
    classIndex      = 1;
else
    classIndex      = 2;
end
% get classified category's Weight data at the fully conntected layer
weightVector = Weights(classIndex,:);

% calculate Classification Activation Map
weightVectorSize = size(weightVector); 
weightVector = reshape(weightVector,[1 weightVectorSize]); 
dotProduct = bsxfun(@times,imageActivations,weightVector); 
classActivationMap = sum(dotProduct,3); 
originalSize = size(image);
% resize 
classActivationMap = imresize(classActivationMap,originalSize(1:2)); 

imgmap = double(classActivationMap);
range = [min(imgmap(:)) max(imgmap(:))];

heatmap_gray = imgmap - range(1);
heatmap_gray = heatmap_gray/(range(2)-range(1));
heatmap_x = round(heatmap_gray * 255);

%persistent tbl;
%if isempty(tbl)
    tbl = coder.const(jet(256));
%end

% Make sure A is in the range from 1 to size(cm,1)
a = max(1,min(heatmap_x,size(tbl,1)));

useMap = true;
if ~useMap
    b = uint8(a);
    bw = imbinarize(b);
    sz = size(bw);
    flag = (sz(1)*sz(2)/2) > sum(bw(:));

    % 
    if flag
        pad = b;
        pad(~bw) = 0;
    else
        pad = 255 - b;
        pad(bw) = 0;
    end
    pad = pad + 1;    
else
    pad = a;
end

% Extract r,g,b components
r = tbl(pad,1);
r = reshape(r,[227 227]);
g = tbl(pad,2);
g = reshape(g,[227 227]);
b = tbl(pad,3);
b = reshape(b,[227 227]);

tmp = im2double(image)*0.3 + (cat(3, r, g, b) * 0.5);
HeatMap = uint8(tmp*255);

end

%%  Copyright 2020 The MathWorks, Inc.

%% Reference
% Learning Deep Features for Discriminative Localization
% Bolei Zhou, Aditya Khosla, Agata Lapedriza, Aude Oliva, Antonio Torralba Computer Science and Arti?cial Intelligence Laboratory, MIT
% http://cnnlocalization.csail.mit.edu/
