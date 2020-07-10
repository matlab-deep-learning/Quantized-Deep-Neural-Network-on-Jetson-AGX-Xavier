/* Copyright 2020 The MathWorks, Inc. */

/* Headers */
#include <stdio.h>
#include <cuda.h>
#include <sys/timeb.h>
/* Opencv includes*/
#include "opencv2/opencv.hpp"

using namespace cv;

/* targetFunction source headers*/
#include "targetFunction.h"

int main(int argc, const char * const argv[])
{
    
    unsigned int wi = 320;
    unsigned int he = 240;
    //unsigned int ch = 3;
    //unsigned int size = wi*he*ch;
    
    int sw;
    sw = atoi(argv[1]);
    
    /* Input arguments */
    VideoCapture cap;
    if ( sw < 3 ) {
        if ( sw < 2 ) {
            //VideoCapture cap(atoi(argv[2])); //use device number for camera.
            cap.open(atoi(argv[2])); //use device number for camera.
            if (!cap.isOpened()) {
                printf("Could not open the video capture device.\n");
                return -1;
            }
            cap.set(CAP_PROP_FRAME_WIDTH, wi);
            cap.set(CAP_PROP_FRAME_HEIGHT, he);
            //cap.set(CAP_PROP_AUTOFOCUS, 0);
            //cap.set(28, 70);
        } else {
            //VideoCapture cap(argv[2]);
            cap.open(argv[2]);
            if (!cap.isOpened()) {
                printf("Could not open the video capture device.\n");
                return -1;
            }
        }
    }
           
    namedWindow("Defect Detection Demo",CV_WINDOW_NORMAL);
	resizeWindow("Defect Detection Demo", 300,300);    
    
    cudaEvent_t start, stop;
    float fps=0;
    Mat inImg;
    //Mat im;
    Mat outImg;
    cudaEventCreate(&start);
    cudaEventCreate(&stop);     
    unsigned char output[230400];
    
    /* Start reading frames */
    for(;;)
    {
        //Mat inImg;
		
        cudaEventRecord(start);
        
        if ( sw < 3 ) {
            cap >> inImg;
        } else {
            inImg = imread(argv[2], 1);
        }
            
		if (inImg.empty()) {
            if ( sw == 2 ) {
                cap.set(CAP_PROP_POS_FRAMES, 0);
                cap >> inImg;
            } else {
                printf("Could not open the video capture device.\n");
                break;
            }
        }
        
        //Size size(wi,he);
		//resize(inImg,im,size);
        
        targetFunction(inImg.data, output); 
        cudaEventRecord(stop);
        cudaEventSynchronize(stop);
        
        Mat outImg(inImg.size(),inImg.type(),output);
                       
        char strbuf[50];
        float milliseconds = -1.0; 
        cudaEventElapsedTime(&milliseconds, start, stop);
        fps = fps*.9+1000.0/milliseconds*.1;        
                
        if( waitKey(50)%256 == 27 ) break; // stop capturing by pressing ESC
        
        if ( sw == 3 ) {
            imwrite("output.png", outImg);
            break;
        }
        
        sprintf (strbuf, "%.2f FPS", fps);
        putText(outImg, strbuf, cvPoint(120,30), CV_FONT_HERSHEY_DUPLEX, 0.5, CV_RGB(0,0,0), 1);
        
        imshow("Defect Detection Demo", outImg);
    }
    
    destroyWindow("Defect Detection Demo");
   
    return 0;
}

