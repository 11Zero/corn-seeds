%1.��ȡͼ�񡣴������£� 
close all;
I = imread('C:\Users\Administrator\Desktop\corn-seeds\seeds\adjoin_pics_items\adjoin\060.jpg');%��ȡͼ��
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
% imshow(I);%��ʾԭͼ�� 
% %2.��������ͼ�񡣴������£� 
% E = entropyfilt(I);%��������ͼ�� 
% Eim = I;%mat2gray(E);%ת��Ϊ�Ҷ�ͼ�� 
% figure(2),imshow(Eim);%��ʾ�Ҷ�ͼ�� 
% BW1 = im2bw(Eim, .8);%ת��Ϊ��ֵͼ�� 
% figure(3), imshow(BW1);%��ʾ��ֵͼ�� 
% %3.�ֱ���ʾͼ��ĵײ�����Ͷ��������������£� 
% BWao = bwareaopen(BW1,2000);%��ȡ�ײ����� 
% figure(4), imshow(BWao);%��ʾ�ײ�����ͼ�� 
% nhood = true(9); 
% closeBWao = imclose(BWao,nhood);%��̬ѧ�ز��� 
% figure(5), imshow(closeBWao)%��ʾ��Ե�⻬���ͼ�� 
% roughMask = imfill(closeBWao,'holes');%������ 
% figure(6),imshow(roughMask);%��ʾ�����ͼ�� 
% I2 = I; 
% I2(roughMask) = 0;%�ײ�����Ϊ��ɫ 
% figure(7), imshow(I2);%ͻ����ʾͼ��Ķ��� 
% %4.ʹ��entropyfilt�����˲��ָ�������£� 
% E2 = entropyfilt(I2);%��������ͼ�� 
% E2im = mat2gray(E2);%ת��Ϊ�Ҷ�ͼ�� 
% figure(8),imshow(E2im);%��ʾ����ͼ�� 
% BW2 = im2bw(E2im,graythresh(E2im));%ת��Ϊ��ֵͼ�� 
% figure(9), imshow(BW2)%��ʾ��ֵͼ�� 
% mask2 = bwareaopen(BW2,1000);%��ȡͼ�񶥲���������Ĥ 
% figure(10),imshow(mask2);%��ʾ����������Ĥͼ�� 
% texture1 = I; texture1(~mask2) = 0;%�ײ�����Ϊ��ɫ 
% texture2 = I; texture2(mask2) = 0;%��������Ϊ��ɫ 
% figure(11),imshow(texture1);%��ʾͼ�񶥲� 
% figure(12),imshow(texture2);%��ʾͼ��ײ� 
% boundary = bwperim(mask2);%��ȡ�߽� 
% segmentResults = I; 
% segmentResults(boundary) = 255;%�߽紦����Ϊ��ɫ 
% figure(13),imshow(segmentResults);%��ʾ�ָ��� 
% %5.ʹ��stdfilt��rangefilt�����˲��ָ�������£� 
% S = stdfilt(I,nhood);%��׼���˲� 
% figure(14),imshow(mat2gray(S));%��ʾ��׼���˲����ͼ�� 
% R = rangefilt(I,ones(5));%rangefilt�˲� 
% background=imopen(R,strel('disk',15));%��ԭʼͼ���Ͻ�����̬ѧ���� 
% Rp=imsubtract(R,background);%�������� 
% figure(15),imshow(Rp,[]);%ͼ����ʾ������ 



% %1.��ȡͼ����ȡͼ��ı߽硣 
% clc; 
% clear all; 
% rgb = imread('060.jpg');%��ȡԭͼ�� 
% imshow(rgb); 
% I = rgb;%ת��Ϊ�Ҷ�ͼ�� 
% % text(732,501,'Image courtesy of Corel',...
% % 'FontSize',7,'HorizontalAlignment','right') ;
% hy = fspecial('sobel');%sobel���� 
% hx = hy'; 
% Iy = imfilter(double(I), hy,'replicate');%�˲���y�����Ե 
% Ix = imfilter(double(I), hx,'replicate');%�˲���x�����Ե 
% gradmag = sqrt(Ix.^2 + Iy.^2);%���� 
% L = watershed(gradmag);%ֱ��Ӧ�÷�ˮ���㷨 
% Lrgb = label2rgb(L);%ת��Ϊ��ɫͼ�� 
% figure; 
% imshow(Lrgb), %��ʾ�ָ���ͼ�� 
% title('ֱ��ʹ���ݶ�ģֵ���з�ˮ���㷨') 
% %3.�ֱ��ǰ���ͱ������б�ǣ�������ʹ����̬ѧ�ؽ�������ǰ��������б�ǣ�����ʹ�ÿ�������������֮�����ȥ��һЩ��С��Ŀ�ꡣ 
% se = strel('disk', 20);%Բ�νṹԪ�� 
% Io = imopen(I, se);%��̬ѧ������ 
% Ie = imerode(I, se);%��ͼ����и�ʴ 
% Iobr = imreconstruct(Ie, I);%��̬ѧ�ؽ� 
% Ioc = imclose(Io, se);%��̬ѧ�ز��� 
% Iobrd = imdilate(Iobr, se);%��ͼ��������� 
% Iobrcbr = imreconstruct(imcomplement(Iobrd),... 
% imcomplement(Iobr));%��̬ѧ�ؽ� 
% Iobrcbr = imcomplement(Iobrcbr);%ͼ���� 
% fgm = imregionalmax(Iobrcbr);%�ֲ�����ֵ 
% I2 = I; 
% I2(fgm) = 255;%�ֲ�����ֵ������ֵ��Ϊ255 
% se2 = strel(ones(5,5));%�ṹԪ�� 
% fgm2 = imclose(fgm, se2);%�ز��� 
% fgm3 = imerode(fgm2, se2);%��ʴ 
% fgm4 = bwareaopen(fgm3, 20);%������ 
% I3 = I; 
% I3(fgm4) = 255;%ǰ��������Ϊ255 
% bw = im2bw(Iobrcbr, graythresh(Iobrcbr));%ת��Ϊ��ֵͼ�� 
% %4. ���з�ˮ��任����ʾ�� 
% D = bwdist(bw);%������� 
% DL = watershed(D);%��ˮ��任 
% bgm = DL == 0;%��ȡ�ָ�߽� 
% gradmag2 = imimposemin(gradmag, bgm | fgm4);%����Сֵ 
% L = watershed(gradmag2);%��ˮ��任 
% I4 = I; 
% I4(imdilate(L == 0, ones(3, 3)) | bgm | fgm4) = 255;%ǰ�����߽紦��255 
% figure; 
% subplot(121) 
% imshow(I4)%ͻ��ǰ�����߽� 
% title('Markers and object boundaries') 
% Lrgb = label2rgb(L,'jet','w','shuffle');%ת��Ϊα��ɫͼ�� 
% subplot(122); imshow(Lrgb)%��ʾα��ɫͼ�� 
% title('Colored watershed label matrix') 
% figure; 
% imshow(I), 
% hold on 
% himage = imshow(Lrgb);%��ԭͼ����ʾα��ɫͼ�� 
% set(himage,'AlphaData', 0.3); 
% title('Lrgb superimposed transparently on original image') 