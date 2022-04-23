clc;
clear all;
close all;

%% Parameters
sigma = 32;    alpha = 0.1;    beta = 0.5;     mu = 1;
n = 500;       Xcenter = 94;   Ycenter = 82;   r = 30;
iter = 200;

%% 
img = im2double(imread('tile.tif'));

smooth_img = img;

imshow(smooth_img,'InitialMagnification','fit');
hold on;

A = zeros(n);
for i = 0:n-1
    A(i+1 ,:) = circshift([(-2*alpha - 6*beta) (alpha + 4*beta) (-beta) zeros(1,n-5) (-beta) (alpha + 4*beta)] ,i);
end

I = eye(n);

%% draw cyrcle curve
teta =  linspace(0,360,n);
X(:, 1) = r .* cosd(teta) + Xcenter;
X(:, 2) = r .* sind(teta) + Ycenter;

plot(X(:,1), X(:,2), 'b' , 'LineWidth',8);

%% Evolution
while sigma >= 1
    
    smooth_img = imgaussfilt(img, sigma);
    
    %potential energy
    [XX, YY] = imgradientxy(smooth_img);
    P = 1 ./ (1 + mu .* sqrt(XX.^2 + YY.^2));
    
    [Fext_x, Fext_y] = imgradientxy(P);

    Fext_x = -Fext_x;
    Fext_y = -Fext_y;

    %quiver(Fext_x, Fext_y);

    for i = 1:iter

        X = SnakeImp(A,X,sigma,I,Fext_x,Fext_y);
        plot(X(:,1), X(:,2),'Color', [0.3 0.3 0.3]);
        drawnow;
        Text = ['Sigma:', num2str(sigma) , '   ' ,'ITR: ',num2str(i)];
        title(Text);
    end
    sigma = sigma / 2;
end

%% Result
plot(X(:,1), X(:,2), 'r.', 'LineWidth',8);