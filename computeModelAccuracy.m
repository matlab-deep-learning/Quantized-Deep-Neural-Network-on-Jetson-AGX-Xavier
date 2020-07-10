function accuracy = computeModelAccuracy(predictionScores, net, dataStore)
%% Computes model-level accuracy statistics
    
    % Load ground truth
    tmp = readall(dataStore);
    groundTruth = tmp.response;
    
    % Compare with predicted label with actual ground truth 
    predictionError = {};
    for idx=1:numel(groundTruth)
        [~, idy] = max(predictionScores(idx,:)); 
        yActual = net.Layers(end).Classes(idy);
        predictionError{end+1} = (yActual == groundTruth(idx)); %#ok
    end
    
    % Sum all prediction errors.
    predictionError = [predictionError{:}];
    accuracy = sum(predictionError)/numel(predictionError);
end

%%  Copyright 2020 The MathWorks, Inc.