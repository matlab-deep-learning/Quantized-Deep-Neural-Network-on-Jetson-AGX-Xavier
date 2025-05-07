# Quantized Deep Neural Network for Defect Detection on Jetson AGX Xavier Using GPU Coder
## How to create, train and quantize network, then integrate it into pre/post image processing and generate CUDA C++ code for targeting Jetson AGX Xavier
[![View Quantized Deep Neural Network for Defect Detection on Jetson on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://jp.mathworks.com/matlabcentral/fileexchange/77984-quantized-deep-neural-network-for-defect-detection-on-jetson)
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=matlab-deep-learning/Quantized-Deep-Neural-Network-on-Jetson-AGX-Xavier)

Deep Learning is really powerful approach to solve difficult problems(e.g. image classification, segmentation and detection). However, performing inference using deep learning is computationally intensive, consuming significant amount of memory. Even networks that are small in size require a considerable amount of memory and hardware to perform these arithmetic operations. These restrictions can inhibit deloyment of deep learning networks to devices that have low computational power and smaller momory resources.

In this case, you can use Deep Learning Toolbox in tandem with the Deep Learning Toolbox Model Quantization Library support package to reduce the memory footprint of a deep neural network by quantizing the weights, biases, and activations of convolution layers to 8-bit scaled integer data types. And then you can use GPU Coder to generate optimized CUDA code for the quantized network.

This example shows how to create, train and quantize a simple convolutional neural network for defect detection, then demonstrate how to generate code for whole algorithms that includes pre/post image processing and convolutional neural network so that you can deploy it into NVIDIA GPUs such as Jetson AGX Xavier, Nano and Drive platforms.

This example demonstrates how to:
1. Load and explore image data
1. Define the network architecture and training options
1. Train the network and classify validation images
1. Quantize network to reduce memory footprint
1. Walk through whole algorithm that consist of pre-processing, CNN and post-processing
1. Generate CUDA C++ code(MEX) for whole algorithm
1. Deploy algorithms to NVIDIA hardware
1. Run the Executable on the Target

![exampleImage](https://user-images.githubusercontent.com/63379838/85224490-c881b000-b405-11ea-9743-5942cf152850.png)

--------------------------------------------------------------------------------

## Prerequisites - MathWorks Products and Support Packages

- MATLAB (R2020a or later)
- MATLAB Coder<sup>TM</sup>
- GPU Coder<sup>TM</sup>
- Parallel Computing Toolbox<sup>TM</sup>
- Deep Learning Toolbox<sup>TM</sup>
- Image Processing Toolbox<sup>TM</sup>
- Computer Vision Toolbox<sup>TM</sup>

--------------------------------------------------------------------------------

## Prerequisites - Development Host REquirements

- NVIDIA® GPU enabled for CUDA with compute capability 3.2 or higher (6.1 or higher is required for quantization)
- NVIDIA CUDA toolkit and driver
- C/C++ Compiler 
- CUDA Deep Neura Network library (cuDNN)
- Open Source Computer Vision Library v3.1.0
- (Optional) NVIDIA TensorRT
- The support package GPU Coder Interface for Deep Learning
- GPU Coder Support Package for NVIDIA GPUs
- The support package Deep Learning Toolbox Model Quantization Library. To install support packages, use the Add-On Explorer.
- Environment variables for the compilers and libraries. For information on the supported versions of the compilers and libraries, see [Third-party Products](https://jp.mathworks.com/help/gpucoder/gs/install-prerequisites.html). For setting up the environment variables, see [Setting Up the Prerequisite Products](https://jp.mathworks.com/help/gpucoder/gs/setting-up-the-toolchain.html).

--------------------------------------------------------------------------------

## Prerequisites - Target Board REquirements

- NVIDIA Jetson AGX Xavier
- Ethernet crossover cable to connect the target board and host PC (if the target board cannot be connected to a local network)
- C/C++ Compiler 
- CUDA Deep Neura Network library (cuDNN)
- Open Source Computer Vision Library v3.1.0 or higher for reading and displaying images/video
- Environment variables on the target for the compilers and libraries. 
For information on the supported versions of the compilers and libraries and their setup, see [installing and setting up prerequisites for NVIDIA boards](https://www.mathworks.com/help/coder/supportpkg/nvidia/ug/install-and-setup-prerequisites.html)

--------------------------------------------------------------------------------

## Running the Example
Open and run the live script 
- English Version : tb_myNDNet_quant_En.mlx
- Japanese Version : tb_myNDNet_quant_Jp.mlx
