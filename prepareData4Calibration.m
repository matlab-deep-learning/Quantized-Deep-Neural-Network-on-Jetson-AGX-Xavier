function prepareData4Calibration(ds)
    labelInfo = countEachLabel(ds);
    labels = string(labelInfo.Label);
    
    % Create Directoriy
    parentFolder = 'calibImages';
    mkdir(parentFolder)
    
    % Read images from image datastore, and write new images to the
    % directory
    for i = 1:size(labels,1)
        mkdir(parentFolder, labels(i));
        indexes = find(ds.Labels == labels(i));
        for ii = 1:size(indexes,1)
            [img, info] = readimage(ds, indexes(ii));
            [path, name, ext] = fileparts(info.Filename);
            fullpath = fullfile(pwd, parentFolder, labels(i), [name, ext]);
            imwrite(img, fullpath, 'png');
        end
    end
end

%%  Copyright 2020 The MathWorks, Inc.
