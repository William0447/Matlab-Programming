clear all;close all;clc
ors1 = imread('093.jpg');
ors2 = imread('094.jpg');
[H L M] = size(ors1);
if M == 3
    im1 = rgb2gray(im2double(ors1));
    im2 = rgb2gray(im2double(ors2));
else
    im1 =  im2double(ors1) ;
    im2 =  im2double(ors2) ;    
end
%%
%%参数设置 
intervals = 3;
scl = 1.5;
dist_ratio = 0.8;
octaves1 = floor(log(min(size(im1)))/log(2)- 2);
octaves2 = floor(log(min(size(im2)))/log(2)- 2);%%参数设置
object_mask1  = ones(size(im1));
object_mask2  = ones(size(im2));
contrast_threshold = 0.02;
curvature_threshold = 10;
interactive = 2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%特征检测
[pos1 scale1 orient1 desc1 ] = features_detection( im1, octaves1, intervals, object_mask1, contrast_threshold, curvature_threshold, interactive);
[pos2 scale2 orient2 desc2 ] = features_detection( im2, octaves2, intervals, object_mask2, contrast_threshold, curvature_threshold, interactive);
db = add_features_db( im1, pos1, scale1, orient1, desc1 );
%%%%%%%%特征匹配
[pt1,pt2]= features_matching( db, desc2, dist_ratio , pos1 , pos2);
%%%显示粗匹配结果

im3 = zeros(size(im1,1),size(im1,2) + size(im2,2) + 10,3);
im3(:,1:size(im1,2),1:3)    = im2double(ors1(:,:,1:3));
im3(:,size(im1,2)+ 11:size(im1,2)+size(im2,2) + 10 ,1:3) = im2double(ors2(:,:,1:3));
figure,imshow(im3),title('粗匹配结果')
[h1 l1] = size(im1);
%[h2 l2] = size(im2);
%h3 = max(h1,h2);l3 = max(l1,l2);
%im3 = zeros(h3,l3+10);
%im3(1:h1,1:l1,) = ors1;
%im3(1:h2,l1+10:l1+10+l2-1) = ors2;
[hh ll] = size(pt1);


for i=1:hh
    line([pt1(i,1) l1+10+pt2(i,1)], [pt1(i,2) pt2(i,2)],'Color',[1 0 0],'LineWidth',1)
end
%%%%%RANSAC算法去错匹配
[corners1 corners2] = Ransac(pt1,pt2,200,1);
figure,imshow(im3),hold on,colormap gray,title('Ransac算法去错结果')
 for n = 1:length(corners2);
     line([corners1(n,1) corners2(n,1) + 10 + l1], [corners1(n,2) corners2(n,2)],'Color',[1 1 0])
 end
 %%图像拼接
 ImageBlenging = LMBlending(ors1,ors2,corners1,corners2);
figure,imagesc(ImageBlenging),title('LM加权融合结果'),colormap gray



