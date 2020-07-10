function out = ocv2mat(img, sz)
    % Convert image data format to MATLAB compatible image format

    sec = sz(1)*sz(2);
    Im = zeros([sz(2), sz(1), sz(3)], 'uint8');
    Im(1:sec) = img(3:3:end);
    Im(sec+1:sec*2) = img(2:3:end);
    Im(sec*2+1:sec*3) = img(1:3:end);
    out = permute(Im, [2 1 3]);
end


%%  Copyright 2020 The MathWorks, Inc.