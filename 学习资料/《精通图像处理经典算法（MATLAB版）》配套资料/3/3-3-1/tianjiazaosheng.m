I = imread('coins.png');
imshow(I);
title('ԭͼ');
figure;
K1 = imnoise(I,'gaussian',0.03,0.02);
subplot(221);imshow(K1);
title('��˹������');
K2 = imnoise(I,'poisson');
subplot(222);imshow(K2);
title('��������');
K3 = imnoise(I,'salt & pepper',0.03);
subplot(223);imshow(K3);
title('��������');
K4 = imnoise(I,'speckle',0.04);
subplot(224);imshow(K4);
title('�˷�����');
