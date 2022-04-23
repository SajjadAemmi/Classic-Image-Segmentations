clc
clear all
close all

pad_size = 50;

img = imread('mri.jpg');
img = im2double(img);
img = rgb2gray(img);
img_p = padarray(img,[50 50],'both');
%[r,c] = size(img);
[r_p,c_p] = size(img_p);
T_x = zeros(r_p,c_p);
T_y = zeros(r_p,c_p);

T = [cosd(25), -sind(25), 60;...
    sind(25), cosd(25), -100;...
    0,0,1];

for i = 1  : r_p 
    for j = 1  : c_p 

        m =  T * [i;j;1];
        T_x(i,j) = m(1);
        T_y(i,j) = m(2);
    end
end

T_image = interp2(img_p,T_y,T_x,'bilinear');

imshow(img_p);
figure;
imshow(T_image);