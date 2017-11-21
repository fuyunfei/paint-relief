#include "distance_marcher.h"
#include "travel_time_marcher.h"
#include "extension_velocity_marcher.h"
#include <opencv2/opencv.hpp>
#include <fstream>
#include <sstream>
#include <iostream>
#include <stdio.h>

using namespace cv;
using namespace std;

void writeCSV(string filename, Mat m)
{
   ofstream myfile;
   myfile.open(filename.c_str());
   myfile<< cv::format(m, cv::Formatter::FMT_CSV) << std::endl;
   myfile.close();
}


int main(int argc, char const *argv[])
{

    std::string imgname(argv[1]);
    Mat src_gray = imread(imgname,CV_LOAD_IMAGE_GRAYSCALE);
    int width=src_gray.size[1];
    int height=src_gray.size[0];
    Mat dis= Mat::zeros(height,width,CV_64F);
    Mat flag = Mat::zeros(height,width,CV_64F);
    int shape[] = {height,width};
    double localdx[2]={1,1};
    imshow( "imageName", src_gray );
    waitKey(0);
// set phi
    Mat phi = Mat::ones(height,width,CV_64F);
    phi.at<double>(1,1) = -1;

//    for(int i=0; i<height;i++){
//        for(int j=0;j<width;j++){
//            if (src_gray.at<double>(i,j)< 0.00001)
//                phi.at<double>(i,j) = -1;
//        }
//    }

// set speed
    Mat lap;
    Laplacian(src_gray,lap,CV_16S,5,1, 0, BORDER_DEFAULT );
    convertScaleAbs( lap, lap );
    lap.convertTo(lap,CV_64F);
    lap=lap/255.0;
    // set minmum to 0.001
    for(int i=0; i<height;i++){
        for(int j=0;j<width;j++){
            if (lap.at<double>(i,j)< 0.001)
                lap.at<double>(i,j) = 0.001;
        }
    }

    Mat speed = 1.0/lap;

// set  marcher
	baseMarcher *marcher = 0;
    marcher = new travelTimeMarcher(
    (double *)phi.data,
    (double *)localdx,
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

    dis=dis/10;
    imshow( "imageName", dis );
    waitKey(0);

    return 0;
}
