I = load_nii('BRATS_531.nii');
img = I.img;
pict = img(:,:,50);
pic = mat2gray(pict);
pict_noise = imnoise(pic,'gaussian');
subplot(1,2,1);
imshow(pic,[]);
subplot(1,2,2);
imshow(pict_noise,[]);
