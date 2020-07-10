function out = targetFunction(img, Weights, host) %#codegen

%Prevents inlining of the current function in the generated code.
coder.inline('never');

%Place the pragma for CUDA code generation
coder.gpu.kernelfun

%Update compile and linker flags for the required third party
if ~host
    opencv_link_flags = '`pkg-config --cflags --libs opencv`';
    coder.updateBuildInfo('addLinkFlags',opencv_link_flags);
end

wi = 320;
he = 240;
ch = 3;

%Pre Processing : Extract the regions where the hexagon nuts are
[Iori, nuts, num, bbox] = myNDNet_Preprocess(img);

scores = coder.nullcopy(zeros(2,4));
HeatMap = coder.nullcopy(zeros(227,227,3,4));
assert (num < 5);
a = coder.nullcopy(zeros(227,227));
for i = 1:num
    indata = repmat(nuts(:,:,i), [1 1 3]);
    %Defect detection using pretrained CNN
    [scores(:,i), act] = gpu_predict(indata);
    %Post Processing 1 : Perform class activation mapping
    HeatMap(:,:,:,i) = CAMheatmap_squeezenet(indata,act,scores(:,i),Weights);
end
    
%Post Processing 2 : Annotate objects in the image and overlay class activation map
out = myNDNet_Postprocess(Iori, num, bbox, scores, wi, he, ch, HeatMap);

end

%%  Copyright 2020 The MathWorks, Inc.
