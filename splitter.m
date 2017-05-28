%1.读取图像。代码如下： 
close all;
I = imread('C:\Users\Administrator\Desktop\corn-seeds\seeds\adjoin_pics_items\adjoin\060.jpg');%读取图像
I_size = size(I);
h = 10;
w = 10;
item_inside = bwfill(I,'holes');
figure;
imshow(item_inside);
h_max_field = zeros(h,w);
h_sec_max_field = zeros(h,w);
pos = [0,0];
sec_pos = [0,0];
for i=1:I_size(1)-h+1
    for j=1:I_size(2)-w+1
        tempfield = I(i:i+h-1,j:j+w-1);
        if(length(find(tempfield==255))>length(find(h_max_field==255)))
            h_sec_max_field = h_max_field;
            sec_pos  = pos;
            h_max_field = tempfield;
            pos = [i,j];
        end
    end
end
I(pos(1):pos(1)+h-1,pos(2):pos(2)+w-1) = ones(h,w).*100;
I(sec_pos(1):sec_pos(1)+h-1,sec_pos(2):sec_pos(2)+w-1) = ones(h,w).*70;
figure;
imshow(I);
% figure(1);
% imshow(I);%显示原图像 
% %2.创建纹理图像。代码如下： 
% E = entropyfilt(I);%创建纹理图像 
% Eim = I;%mat2gray(E);%转化为灰度图像 
% figure(2),imshow(Eim);%显示灰度图像 
% BW1 = im2bw(Eim, .8);%转化为二值图像 
% figure(3), imshow(BW1);%显示二值图像 
% %3.分别显示图像的底部纹理和顶部纹理。代码如下： 
% BWao = bwareaopen(BW1,2000);%提取底部纹理 
% figure(4), imshow(BWao);%显示底部纹理图像 
% nhood = true(9); 
% closeBWao = imclose(BWao,nhood);%形态学关操作 
% figure(5), imshow(closeBWao)%显示边缘光滑后的图像 
% roughMask = imfill(closeBWao,'holes');%填充操作 
% figure(6),imshow(roughMask);%显示填充后的图像 
% I2 = I; 
% I2(roughMask) = 0;%底部设置为黑色 
% figure(7), imshow(I2);%突出显示图像的顶部 
% %4.使用entropyfilt进行滤波分割。代码如下： 
% E2 = entropyfilt(I2);%创建纹理图像 
% E2im = mat2gray(E2);%转化为灰度图像 
% figure(8),imshow(E2im);%显示纹理图像 
% BW2 = im2bw(E2im,graythresh(E2im));%转化为二值图像 
% figure(9), imshow(BW2)%显示二值图像 
% mask2 = bwareaopen(BW2,1000);%求取图像顶部的纹理掩膜 
% figure(10),imshow(mask2);%显示顶部纹理掩膜图像 
% texture1 = I; texture1(~mask2) = 0;%底部设置为黑色 
% texture2 = I; texture2(mask2) = 0;%顶部设置为黑色 
% figure(11),imshow(texture1);%显示图像顶部 
% figure(12),imshow(texture2);%显示图像底部 
% boundary = bwperim(mask2);%求取边界 
% segmentResults = I; 
% segmentResults(boundary) = 255;%边界处设置为白色 
% figure(13),imshow(segmentResults);%显示分割结果 
% %5.使用stdfilt和rangefilt进行滤波分割。代码如下： 
% S = stdfilt(I,nhood);%标准差滤波 
% figure(14),imshow(mat2gray(S));%显示标准差滤波后的图像 
% R = rangefilt(I,ones(5));%rangefilt滤波 
% background=imopen(R,strel('disk',15));%在原始图像上进行形态学运算 
% Rp=imsubtract(R,background);%减法运算 
% figure(15),imshow(Rp,[]);%图像显示清晰化 



% %1.读取图像并求取图像的边界。 
% clc; 
% clear all; 
% rgb = imread('060.jpg');%读取原图像 
% imshow(rgb); 
% I = rgb;%转化为灰度图像 
% % text(732,501,'Image courtesy of Corel',...
% % 'FontSize',7,'HorizontalAlignment','right') ;
% hy = fspecial('sobel');%sobel算子 
% hx = hy'; 
% Iy = imfilter(double(I), hy,'replicate');%滤波求y方向边缘 
% Ix = imfilter(double(I), hx,'replicate');%滤波求x方向边缘 
% gradmag = sqrt(Ix.^2 + Iy.^2);%求摸 
% L = watershed(gradmag);%直接应用分水岭算法 
% Lrgb = label2rgb(L);%转化为彩色图像 
% figure; 
% imshow(Lrgb), %显示分割后的图像 
% title('直接使用梯度模值进行分水岭算法') 
% %3.分别对前景和背景进行标记：本例中使用形态学重建技术对前景对象进行标记，首先使用开操作，开操作之后可以去掉一些很小的目标。 
% se = strel('disk', 20);%圆形结构元素 
% Io = imopen(I, se);%形态学开操作 
% Ie = imerode(I, se);%对图像进行腐蚀 
% Iobr = imreconstruct(Ie, I);%形态学重建 
% Ioc = imclose(Io, se);%形态学关操作 
% Iobrd = imdilate(Iobr, se);%对图像进行膨胀 
% Iobrcbr = imreconstruct(imcomplement(Iobrd),... 
% imcomplement(Iobr));%形态学重建 
% Iobrcbr = imcomplement(Iobrcbr);%图像求反 
% fgm = imregionalmax(Iobrcbr);%局部极大值 
% I2 = I; 
% I2(fgm) = 255;%局部极大值处像素值设为255 
% se2 = strel(ones(5,5));%结构元素 
% fgm2 = imclose(fgm, se2);%关操作 
% fgm3 = imerode(fgm2, se2);%腐蚀 
% fgm4 = bwareaopen(fgm3, 20);%开操作 
% I3 = I; 
% I3(fgm4) = 255;%前景处设置为255 
% bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%转化为二值图像 
% %4. 进行分水岭变换并显示： 
% D = bwdist(bw);%计算距离 
% DL = watershed(D);%分水岭变换 
% bgm = DL == 0;%求取分割边界 
% gradmag2 = imimposemin(gradmag, bgm | fgm4);%置最小值 
% L = watershed(gradmag2);%分水岭变换 
% I4 = I; 
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;%前景及边界处置255 
% figure; 
% subplot(121) 
% imshow(I4)%突出前景及边界 
% title('Markers and object boundaries') 
% Lrgb = label2rgb(L,'jet','w','shuffle');%转化为伪彩色图像 
% subplot(122); imshow(Lrgb)%显示伪彩色图像 
% title('Colored watershed label matrix') 
% figure; 
% imshow(I), 
% hold on 
% himage = imshow(Lrgb);%在原图上显示伪彩色图像 
% set(himage,'AlphaData', 0.3); 
% title('Lrgb superimposed transparently on original image') 