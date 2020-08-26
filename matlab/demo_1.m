%  距离正则化水平集演化(DRLSE)应用于边缘型主动轮廓模型，来进行肺部CT图像分割



% info=dicominfo(J:\脑出血\数据-8-3\select\No1\2014-4-23-0-07-13\I1600000');
% Img=dicomread('J:\脑出血\数据-8-3\select\No1\2014-4-23-0-07-13\I1600000');
% Img=double(Img);
% figure(1),imshow(Img,[]);
% %调整窗宽窗位；
% wc=(info.WindowCenter-info.RescaleIntercept)/info.RescaleSlope;
% ww=(info.WindowWidth-info.RescaleIntercept)/info.RescaleSlope;
% 
% Inew=mat2gray(Img,[wc-(ww/2),wc+(ww/2)]);
% figure(2),imshow(Inew,[]);
clear
Img=imread('./label/result.jpg');
Img=double(Img(:,:,1));
imshow(Img,[]);
timestep=0.7;  % 时间步长

iter_inner=10;
iter_outer=20;

alfa=-3;  % 加权面积项 A(phi)的系数 


sigma=1.2;    %  Gaussian kernel的标尺参数
G=fspecial('gaussian',15,sigma); % Caussian kernel
Img_smooth=conv2(Img,G,'same');  % 用Gaussiin convolution平滑图像
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % 边界指示函数

% 将水平集函数初始化为二进制阶跃函数
c0=2;
initialLSF = c0*ones(size(Img));
initialLSF(Img>= 121&Img<=224)=-c0;
initialLSF(1:50,100:190)=c0;
phi=initialLSF;

figure(1);
mesh(-phi);   % 为更好的观察，将水平集函数倒置显示
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
title('初始水平集函数');
view([-135 35]);
[nrow, ncol]=size(Img);
axis([1 ncol 1 nrow]);

figure(2);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
title('初始零水平集轮廓线');
pause(0.5);




% 开始水平集演化
for n=1:iter_outer
    phi = drlse_edge(phi, g, alfa, timestep, iter_inner);    
    if mod(n,2)==0
        figure(2);
        imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
    end
end


phi(phi>=10000)=10000;
phi(phi<=-10000)=-10000;
finalLSF=phi;
figure(3);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
hold on;  contour(phi, [0,0], 'r');
str=['最终零水平集轮廓线，', num2str(iter_outer*iter_inner), '次迭代'];
title(str);

figure(4);
mesh(-finalLSF); 
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
view([-37.5 40]);
str=['最终水平集函数， ', num2str(iter_outer*iter_inner), '次迭代'];
title(str);
axis on;
axis([0 ncol 0 nrow]);


