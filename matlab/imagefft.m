V = load_nii('Brain_T1_MRI.nii');
F = fftn(double(V.img));
FS = fftshift(F);
meanFmag = mean(mean(mean(abs(FS))))
FSL = FS(size(FS,1)/4:size(FS,1)*3/4,size(FS,2)/4:size(FS,2)*3/4,size(FS,2)/4:size(FS,2)*3/4);
meanFmag = mean(mean(mean(abs(FSL))))