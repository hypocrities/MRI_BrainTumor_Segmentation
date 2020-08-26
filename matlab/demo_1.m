%  ��������ˮƽ���ݻ�(DRLSE)Ӧ���ڱ�Ե����������ģ�ͣ������зβ�CTͼ��ָ�



% info=dicominfo(J:\�Գ�Ѫ\����-8-3\select\No1\2014-4-23-0-07-13\I1600000');
% Img=dicomread('J:\�Գ�Ѫ\����-8-3\select\No1\2014-4-23-0-07-13\I1600000');
% Img=double(Img);
% figure(1),imshow(Img,[]);
% %��������λ��
% wc=(info.WindowCenter-info.RescaleIntercept)/info.RescaleSlope;
% ww=(info.WindowWidth-info.RescaleIntercept)/info.RescaleSlope;
% 
% Inew=mat2gray(Img,[wc-(ww/2),wc+(ww/2)]);
% figure(2),imshow(Inew,[]);
clear
Img=imread('./label/result.jpg');
Img=double(Img(:,:,1));
imshow(Img,[]);
timestep=0.7;  % ʱ�䲽��

iter_inner=10;
iter_outer=20;

alfa=-3;  % ��Ȩ����� A(phi)��ϵ�� 


sigma=1.2;    %  Gaussian kernel�ı�߲���
G=fspecial('gaussian',15,sigma); % Caussian kernel
Img_smooth=conv2(Img,G,'same');  % ��Gaussiin convolutionƽ��ͼ��
[Ix,Iy]=gradient(Img_smooth);
f=Ix.^2+Iy.^2;
g=1./(1+f);  % �߽�ָʾ����

% ��ˮƽ��������ʼ��Ϊ�����ƽ�Ծ����
c0=2;
initialLSF = c0*ones(size(Img));
initialLSF(Img>= 121&Img<=224)=-c0;
initialLSF(1:50,100:190)=c0;
phi=initialLSF;

figure(1);
mesh(-phi);   % Ϊ���õĹ۲죬��ˮƽ������������ʾ
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
title('��ʼˮƽ������');
view([-135 35]);
[nrow, ncol]=size(Img);
axis([1 ncol 1 nrow]);

figure(2);
imagesc(Img,[0, 255]); axis off; axis equal; colormap(gray); hold on;  contour(phi, [0,0], 'r');
title('��ʼ��ˮƽ��������');
pause(0.5);




% ��ʼˮƽ���ݻ�
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
str=['������ˮƽ�������ߣ�', num2str(iter_outer*iter_inner), '�ε���'];
title(str);

figure(4);
mesh(-finalLSF); 
hold on;  contour(phi, [0,0], 'r','LineWidth',2);
view([-37.5 40]);
str=['����ˮƽ�������� ', num2str(iter_outer*iter_inner), '�ε���'];
title(str);
axis on;
axis([0 ncol 0 nrow]);


