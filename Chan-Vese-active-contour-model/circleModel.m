function model = circleModel(I,type)

if size(I,3)~=3
    temp = double(I(:,:,1));
else
    temp = double(rgb2gray(I));
end

h = [0 1 0; 1 -4 1; 0 1 0];
T = conv2(temp,h);
T(1,:) = 0;
T(end,:) = 0;
T(:,1) = 0;
T(:,end) = 0;

thre = max(max(abs(T)))*.5;
idx = find(abs(T) > thre);
[cx,cy] = ind2sub(size(T),idx);
cx = round(mean(cx));
cy = round(mean(cy));

[x,y] = meshgrid(1:min(size(temp,1),size(temp,2)));

model = zeros(size(temp));
[p,q] = size(temp);

switch lower (type)
    case 'small'
        r = 10;
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        model(1:size(n,1),1:size(n,2)) = n;
    case 'medium'
        r = min(min(cx,p-cx),min(cy,q-cy));
        r = max(2/3*r,25);
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        model(1:size(n,1),1:size(n,2)) = n;
    case 'large'
        r = min(min(cx,p-cx),min(cy,q-cy));
        r = max(2/3*r,60);
        n = zeros(size(x));
        n((x-cx).^2+(y-cy).^2<r.^2) = 1;
        model(1:size(n,1),1:size(n,2)) = n;
    case 'whole'
        r = 9;
        model = zeros(round(ceil(max(p,q)/2/(r+1))*3*(r+1)));
        siz = size(model,1);
        sx = round(siz/2);       
        i = 1:round(siz/2/(r+1));
        j = 1:round(0.9*siz/2/(r+1));
        j = j-round(median(j)); 
        model(sx+2*j*(r+1),(2*i-1)*(r+1)) = 1;
        se = strel('disk',r);
        model = imdilate(model,se);
        model = model(round(siz/2-p/2-6):round(siz/2-p/2-6)+p-1,round(siz/2-q/2-6):round(siz/2-q/2-6)+q-1); 
end
        tem(:,:,1) = model;
        M = padarray(model,[floor(2/3*r),floor(2/3*r)],0,'post');
        tem(:,:,2) = M(floor(2/3*r)+1:end,floor(2/3*r)+1:end);
        model = tem; 
end