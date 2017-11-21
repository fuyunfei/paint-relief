% colorImage = imread('/home/sun/Cloud/documents/report/mser.png');
% I = rgb2gray(colorImage);
% [FileName,PathName,FilterIndex] = uigetfile('*.png','Select the image file');
% file=[PathName,FileName]
close all ; clear all;
% file=['/home/sun/cloud/temp/pics/5/1-layer_optimization_all_weights_map-03.png']
I=imread('/home/sun/cloud/temp/ch/rooster1/rs1-layer_optimization_all_weights_map-04.png');
% I=rgb2gray(I);
sz=size(I,1)*size(I,2);
% I=imsharpen(I);

 
% T = adaptthresh(I,0.1,'ForegroundPolarity','dark');
% I= I-uint8(T*255);
% I=imgaussfilt(I,1);
I=imguidedfilter(I);

% Detect MSER regions.
[mserRegions] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[int16(0.01*sz)  (0.2*sz)],'ThresholdDelta',1)
% ,'ROI',[1 230 168 300 ]

 
% for i = 1 : length(mserRegions)
figure;
imshow(zeros(size(I)),'border','tight','InitialMagnification','fit');
set (gcf,'Position',[0,0,size(I,2),size(I,1)]); axis normal;
hold on;
plot(mserRegions  , 'showPixelList', true,'showEllipses',false);
hold off;
 
% I = getframe(gcf);
% I=frame2im(I);
% imwrite(I,'4.png');


sz = size(I);
pixelIdxList = cellfun(@(xy)sub2ind(sz, xy(:,2), xy(:,1)), ...
    mserRegions.PixelList, 'UniformOutput', false);

% Next, pack the data into a connected component struct.
mserConnComp.Connectivity = 8;
mserConnComp.ImageSize = sz;
mserConnComp.NumObjects = mserRegions.Count;
mserConnComp.PixelIdxList = pixelIdxList;

% Use regionprops to measure MSER properties
mserStats = regionprops(mserConnComp, I,'BoundingBox', 'Eccentricity', ...
    'Solidity', 'Extent', 'Euler', 'Image','MeanIntensity');

filterIdx=[mserStats.MeanIntensity]<25 | [mserStats.Solidity]<0.4;

% Remove regions
mserStats(filterIdx) = [];
mserRegions(filterIdx) = [];

sumInd=[];

imshow(zeros(size(I)));hold on;
plot(mserRegions  , 'showPixelList', true,'showEllipses',false);
hold off;



for i = 1 : length(mserStats)
PixelList_i=mserRegions(i).PixelList; 
linearInd = sub2ind(size(I),PixelList_i(:,2),PixelList_i(:,1));
zeros_I=zeros(size(I));
zeros_I(linearInd)=1;
zeros_I=imfill(zeros_I);
close all;
imshow(zeros_I,[0 1]);
imwrite(zeros_I,['rs4',int2str(i),'.png']);
sumInd=[sumInd ;linearInd];
end


% Show remaining regions
close all;
figure;
imshow(zeros(size(I)))
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
hold off
figure;
sumInd= unique(sumInd);
zeros_I=zeros(size(I));
zeros_I(sumInd)=1;
zeros_I=imfill(zeros_I);

imshow(zeros_I,[0 1]);
imwrite(zeros_I,['zeros_I',int2str(image_index),'.png']);
