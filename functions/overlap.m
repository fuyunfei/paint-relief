% input N images with alpha value 
% ouput overlap regions 
clear all; close all ;
for i=1:3
% [A,map,L{i}]=imread(['7-A0',int2str(i),'.png']);
L{i}=imread(['zeros_I',int2str(i-1),'.png']);
end

ovlap_R=uint8(zeros(size(L{i})));
for i = 1:3 
% t=1-double(L{i})/255.0;
% ovlap_R=ovlap_R+t.*t;
ovlap_R=ovlap_R+L{i}/255;
end
ovlap_R(ovlap_R<2)=0;

ovlap_R= cat(3,ovlap_R,ovlap_R,ovlap_R) ;
imshow(ovlap_R,[0 1]);

rgbimage= imread('5.png');
rgbimage(ovlap_R==0)=0;

imshow(rgbimage);