function out = mat2ocv(img)
    % Convert image data format to OpenCV compatible format

    sz = size(img);
    Iocv = zeros([prod(sz), 1], 'uint8');
    % permute data
    Ir = permute(img, [2 1 3]);
    Iocv(1:3:end) = Ir(:,:,3);
    Iocv(2:3:end) = Ir(:,:,2);
    Iocv(3:3:end) = Ir(:,:,1);
    % reshape
    out = reshape(Iocv, sz);
end


%%  Copyright 2020 The MathWorks, Inc.