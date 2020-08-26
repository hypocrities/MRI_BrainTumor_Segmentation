clear
org=imread('./label/result.jpg');
org=imresize(org,[256 256]);
noisy= imnoise(org,'gaussian',0,0.001);%  % add noise of mean 0, variance 0.005
figure;
subplot(2,3,1), imshow(org,[]), title('Original Image');
%subplot(3,3,2), imshow(noisy,[]), title('Noisy Image');

% start of calling normal shrink denoising algorithm

ns_r = normal_shrink(noisy(:,:,1)); 
ns_g = normal_shrink(noisy(:,:,1));
ns_b = normal_shrink(noisy(:,:,1));
ns_r= uint8(ns_r);
ns_g= uint8(ns_g);
ns_b= uint8(ns_b);
ns = cat(3, ns_r, ns_g, ns_b);
%subplot(3,3,4), imshow(ns,[]), title('normal shrink');

% end of calling normal shrink denoising algorithm

% start of calling bilateral filter

ns2gray = rgb2gray(ns);
ns2gray = double(ns2gray);
B = bilateral(ns2gray);
subplot(2,3,2), imshow(B,[]), title('bilateral');

% end of calling bilateral filter

%enhanced image
%enha_imadj = imadjust(uint8(B));
%enha_histeq = histeq(uint8(B));
%enha_adapthisteq = adapthisteq(uint8(B));

% start of edge based segmentation

%kirsch operator
%kris = krisch(B);
%subplot(3,3,7), imshow(kris,[]), title('krisch');
%extended kirsch operator
% kris55 = krisch55(B);
% subplot(5,5,3), imshow(kris55,[]), title('krisch');
% %extended sobel operator
% sob55 = sobel55(B);
% subplot(5,5,4), imshow(sob55,[]), title('sobel');

% end of  edge based segmentation

% start of threshold based segmentation

%ostu threshold
ostu_img = ostu(B);
subplot(2,3,3),imshow(ostu_img,[]),title('ostu');

% end of threshold based segmentation

% kmeans clustering
%figure;
 [k, class, img_vect]= kmeans(B, 5);
clust = 4;
cluster = reshape(class(1:length(img_vect),clust:clust), [256,256] );
subplot(2,3,4), imshow(cluster,[]), title('k-means cluster ');


 %adaptive clustering
 [k, class, img_vect, noOfIter]= adaptive_kmeans(B);
 %title(['adaptive kmeans- total iteration' num2str(noOfIter)]);
 %figure;
clust = 4;
cluster = reshape(class(1:length(img_vect),clust:clust), [256,256] );
subplot(2,3,5), imshow(cluster,[]), title({'adaptivekmeans:';['iteration ' num2str(noOfIter)]});

 
 %fuzzy c means
 img = double(B);
 k = 5;
 [ Unew, centroid, obj_func_new ] = fuzzyCMeans( img, k );
 %figure;
subplot(2,3,6);
imshow(Unew(:,:,4),[]), title('fuzzy Cmeans');
 
 % watershed algorithm
% figure;
% watershedSeg(B, sob55);
 