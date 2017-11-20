#include "distance_marcher.h"
#include "travel_time_marcher.h"
#include "extension_velocity_marcher.h"
#include <opencv2/opencv.hpp>

#include <iostream>
#include <stdio.h>

using namespace cv;

int main(int argc, char const *argv[])
{
    Mat src_gray = imread("../../1.jpg",CV_LOAD_IMAGE_GRAYSCALE);
    int width=src_gray.size[1];
    int height=src_gray.size[0];

    Mat speed= Mat::ones(height,width,CV_64F);
    Mat dis= Mat::ones(height,width,CV_64F);
    Mat phi = Mat::ones(height,width,CV_64F);
    Mat flag = Mat::zeros(height,width,CV_64F);
    phi.at<double>(1,1)=-1;
    int shape[] = {height,width};
    double localdx[2]={1,1};

	baseMarcher *marcher = 0;
    marcher = new travelTimeMarcher(
    (double *)phi.data,
    (double *)localdx,
//    (long *)localflag,
    (long *)flag.data,
    (double *)dis.data,
    2,
    shape,
    0,
    2,
    (double *)speed.data,
    0,
    0);

    marcher->march();
    std::cout<< "dis:"<<std::endl;
    for (int i = 0; i < 3; ++i)
    {
        for (int j = 0; j < 3; ++j)
        {
            std::cout << dis.at<double>(i,j) << ' ';
        }
        std::cout << std::endl;
    }

    return 0;
}
