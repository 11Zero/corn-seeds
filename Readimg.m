function [B ,source]= Readimg(fullfilename,handles)
%str = fullfile('pics',filename);
I=imread(fullfilename);
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

%figure(2001);


axes(handles.axes_origin);
imshow(I_gray);
I_bw=im2bw(I_gray,0.25);

%% ��̬ѧ����

I_bw=bwareaopen(I_bw,150);


%% ��ǲ���
% ���
[B,L]=bwboundaries(I_bw,'noholes');
