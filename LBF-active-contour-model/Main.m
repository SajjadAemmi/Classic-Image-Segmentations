clear all;
close all;
clc;

ID = 6;

Img = imread(strcat('images/', int2str(ID),'.jpg'));

if size(Img,3) == 3
    Img = rgb2gray(Img);
end

I = double(Img);
[r, c] = size(I);

phi = ones(r, c) .* -2;

%% Hyper Parameters
Eps = 1; 
eta = 0.1;
Kernel_Sigma = 3;

if ID == 1
    Iteration=400;       phi(25:55,55:65)=2;       L1=1;       L2=2;
    mu=1;               nu=0.003*255^2;
    
elseif ID==2
    Iteration=120;       phi(58:66,58:66)=2;       L1=1;       L2=1;  
    mu=1;               nu=0.001*255^2;
            
elseif ID==3
    Iteration=1000;       phi(30:100,30:100)=2;       L1=1;       L2=1;
    mu=1;               nu=0.001*255^2;
                    
elseif ID==4
    Iteration=180;       phi(32:42,53:63)=2;       L1=1;       L2=1;
    mu=1;               nu=0.001*255^2;
    
elseif ID==5
    Iteration=370;       phi(32:42,43:53)=2;       L1=1;       L2=1;
    mu=1;               nu=0.001*255^2;
    
elseif ID==6
    Iteration=370;       phi(32:42,43:53)=2;        L1=1;       L2=1;
    mu=1;               nu=0.001*255^2;
end
%%

K = fspecial('gaussian',  1 + 4 * Kernel_Sigma, Kernel_Sigma);

figure;
subplot(2,2,1); 
imshow(Img); 
title('Original Image');

subplot(2,2,3); 
imshow(Img);
hold on;
contour(phi, [0 0], 'y','LineWidth',1);
hold off;
title('Contour');

subplot(2,2,2); 
imshow(I,[],'initialmagnification','fit');
hold on;

for i = 1 : Iteration

    H_eps = (1 + (2/pi) * atan(phi ./ Eps)) / 2;
    Delta_eps = (1 / pi) .* (Eps ./ (Eps^2 + phi.^2));
    
    F1 = conv2(I .* H_eps , K , 'same') ./ conv2(H_eps , K , 'same');
    F2 = conv2(I .* (1 - H_eps) , K , 'same') ./ conv2((1 - H_eps) , K , 'same');
    
    T_Region = -Delta_eps .* (I.^2 .* (L1 - L2) - 2 * I .* conv2((L1 * F1 - L2 * F2), K, 'same') + conv2((L1 * F1 .^ 2 - L2 * F2 .^ 2), K, 'same'));
    T_Regulator = nu .* Delta_eps .* kappa(phi) + mu .* (del2(phi) - kappa(phi));
    
    phi = phi + eta .* (T_Region + T_Regulator);
   
    if(mod(i,20)==0)
        imshow(Img,[],'initialmagnification','fit');
        hold on;
        contour(phi,[0 0],'g','LineWidth',1);
        title(strcat('Iteration: ', num2str(i))); 
        drawnow;
    end
end

result = phi <= 0;

subplot(2,2,4); 
imshow(result); 
title('Segmentation');