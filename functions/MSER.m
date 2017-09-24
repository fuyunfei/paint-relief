% colorImage = imread('/home/sun/Cloud/documents/report/mser.png');
% I = rgb2gray(colorImage);
image_index=2;
I=imread(['5-',int2str(image_index),'.png']);
% Detect MSER regions.
[mserRegions] = detectMSERFeatures(I, ... 
    'RegionAreaRange',[100 80000],'ThresholdDelta',5);

figure
imshow(zeros(size(I)))
hold on
plot(mserRegions, 'showPixelList', true,'showEllipses',false)
title('MSER regions')
hold offfdf


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

filterIdx=[mserStats.MeanIntensity]<35;

% Remove regions
mserStats(filterIdx) = [];
mserRegions(filterIdx) = [];

sumInd=[];
for i = 1 : length(mserStats)
PixelList_i=mserRegions(i).PixelList; 
linearInd = sub2ind(size(I),PixelList_i(:,2),PixelList_i(:,1));
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
imshow(zeros_I,[0 1]);
imwrite(zeros_I,['zeros_I',int2str(image_index),'.png']);
