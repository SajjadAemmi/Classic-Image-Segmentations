% "Active Contours Without Edges" by Chan and Vese

close all
clear all

Img = imread('images/mri.jpg');

%resize original image
scale = 200./min(size(Img,1),size(Img,2));
if scale < 1
   Img = imresize(Img,scale);
end

seg = chanvese(Img,'medium',800,0.02);

Img = imread('images/apple.jpg');

%resize original image
scale = 200./min(size(Img,1),size(Img,2));
if scale < 1
   Img = imresize(Img,scale);
end

seg = chanvese(Img,'medium',800,0.02);

Img = imread('images/anti-mass.jpg');

%resize original image
scale = 200./min(size(Img,1),size(Img,2));
if scale < 1
   Img = imresize(Img,scale);
end

seg = chanvese(Img,'large',300,0.02); 
seg = chanvese(Img,'whole',800,0.02);