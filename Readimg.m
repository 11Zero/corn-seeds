function [B ,source]= Readimg(filename)
str = fullfile('C:\Users\Administrator\Desktop\����\��������ʶ��',filename);
I=imread(str);
source  = I;
I0=I;
% I=imresize(I,[696 928]);

% ��ʾ
%figure
%imshow(I);
%title('ԭͼ');
%% ��ֵ������

[M,N,C]=size(I);

% ת�Ҷ�ͼ
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end

% ��ʾ
%figure;
%hold on;
%imshow(I_gray);
%title('�Ҷ�ͼ');

I_bw=im2bw(I_gray,0.25);
%figure
%imshow(I_bw);
%title('��ֵͼ');

%% ��̬ѧ����

I_bw=bwareaopen(I_bw,150);

%figure
%imshow(I_bw);
%title('ȥ��');
%figure
%imshow(I_bw);
%title('�궨');


% %% ��Ե����
% 
% 
% BW1=edge(I_bw,'sobel'); %��SOBEL���ӽ��б�Ե���
% BW2=edge(I_bw,'roberts');%��Roberts���ӽ��б�Ե���
% BW3=edge(I_bw,'prewitt'); %��prewitt���ӽ��б�Ե���
% BW4=edge(I_bw,'log'); %��log���ӽ��б�Ե���
% BW5=edge(I_bw,'canny'); %��canny���ӽ��б�Ե���
% h=fspecial('gaussian',8);
% BW6=edge(I_bw,'canny');
% subplot(2,3,1), %imshow(BW1);
% %title('sobel edge check');
% subplot(2,3,2), %imshow(BW2);
% %title('sobel edge check');
% subplot(2,3,3), %imshow(BW3);
% %title('prewitt edge check');
% subplot(2,3,4), %imshow(BW4);
% %title('log edge check');
% subplot(2,3,5), %imshow(BW5);
% %title('canny edge check');
% subplot(2,3,6), %imshow(BW6);
% %title('gasussian&canny edge check');%��Ϊ�ø�˹�˲���Canny���ӱ�Ե�����
% %figure
% %imshow(BW6);
% %title('gasussian&canny edge check');%��Ϊ�ø�˹�˲���Canny���ӱ�Ե�����

%% ��ǲ���
% ���
[B,L]=bwboundaries(I_bw,'noholes');
