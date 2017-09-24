clear all; close all ;
for i=1:3
% [A,map,L{i}]=imread(['2reorder0132-layer0',int2str(i),'.png']);
L{i}=imread(['2reorder0321-layer0',int2str(i),'.png']);

A =imgradient(imgaussfilt(L{i},2)) ;
normA = A - min(A(:));
normA = normA ./ max(normA(:));
G{i}=normA;
figure;
imshow(imgaussfilt(normA),[0 1]);
end

% C=uint8(ones(size(L{1})));
% for i=1:3
% BW = imgradient(imgaussfilt(L{i}),'Sobel');
% figure; imshow(BW/255)
% C=double(C).*BW/255;
% end
% 
% imshow(C);

 
Grad=ones(size(G{1}));
for i = 1:2
Grad=Grad.*imgaussfilt(G{i},2);
end
figure
imshow(Grad*10);  
% close all; 
sum(Grad(:)')