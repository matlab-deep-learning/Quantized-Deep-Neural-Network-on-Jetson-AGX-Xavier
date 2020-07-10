function [out, act] = gpu_predict(in) 
%#codegen

persistent mynet;

if isempty(mynet)
    % Load the mySqueezenet.mat into the persistent mynet for code
    % generation
    mynet = coder.loadDeepLearningNetwork('mySqueezeNet.mat','convnet');
end

out = mynet.predict(in);
act = mynet.activations(in, 'relu_conv10','OutputAs','channels');

end

%%  Copyright 2020 The MathWorks, Inc.
