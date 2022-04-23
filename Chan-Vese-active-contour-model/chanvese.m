function result = chanvese(Img, Model, iteration, mu)

%Grayscale Image

if size(Img,3) == 3
    I = rgb2gray(Img);
    I = double(I);
else
    I = double(Img);
end

%Create Model

switch lower (Model)
  case 'small'
      Model = circleModel(Img,'small');
  case 'medium'
      Model = circleModel(Img,'medium');
  case 'large'
      Model = circleModel(Img,'large');              
  case 'whole'
      Model = circleModel(Img,'whole');    
end

Model = Model(:,:,1);

%Hyper Parameters
eta = 0.5; %stepsize
lambda1 = 1;
lambda2 = 1;

phi = bwdist(Model) - bwdist(1 - Model);

figure;
subplot(2,2,1); 
imshow(Img); 
title('Original Image');

subplot(2,2,3); 
contour(phi, [0 0], 'b','LineWidth',1); 
title('Contour');

subplot(2,2,2); 
imshow(I,[],'initialmagnification','fit');
hold on;

for i = 1:iteration
  
  H_eps = 0.5 * (1 + (2/pi) * atan(phi./eps));
    
  c1 = sum(sum(I .* H_eps)) / sum(sum(H_eps)); % average inside
  c2 = sum(sum(I .* (1 - H_eps))) / sum(sum((1 - H_eps))); % average outside

  F_int = lambda2 * (I-c2).^2 - lambda1 * (I-c1).^2; 

  F_ext = mu * kappa(phi);
  F_ext = F_ext ./ max(max(abs(F_ext))); % normalize

  F = F_int + F_ext;
  F = F./(max(max(abs(F)))); % normalize

  phi = phi + eta .* F;

  cla;
  imshow(I,[],'initialmagnification','fit');
  contour(phi, [0 0], 'g','LineWidth',2);
  title(strcat('Iteration: ', num2str(i))); 
  drawnow;

end

result = phi <= 0;

subplot(2,2,4); 
imshow(result); 
title('Segmentation');
end