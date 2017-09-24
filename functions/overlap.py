from PIL import Image
from itertools import combinations
import cv2
import numpy as np

alphas=[]
for i in range(1,4):
    imgpath = '../pics/5-alpha%01d.png' % i
    arr = np.asfarray(Image.open(imgpath))
    alphas.append(arr)


a=list(combinations(range(3), 2))
for i in range(len(a)):
    arr=alphas[a[i][0]]/255.0*alphas[a[i][1]]/255.0
    arr=arr>0.2
    arr=np.asarray(arr*255,dtype='uint8')
    kernel = np.ones((2, 2), np.uint8)
    #arr = cv2.erode(arr, kernel, iterations=1)
    #arr = cv2.dilate(arr, kernel, iterations=1)
    img = Image.fromarray(arr)
    #img.show()
    img.save('out%2d.png'%i)


