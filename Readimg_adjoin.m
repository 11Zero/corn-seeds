function [B ,source]= Readimg_adjoin(filename)
str = fullfile('pics_adjoin',filename);
I=imread(str);
source  = I;
I0=I;

%% ��ֵ������

[M,N,C]=size(I);

% ת�Ҷ�ͼ
if C>1
    I_gray=rgb2gray(I);
else
    I_gray=I;
end


I_bw=im2bw(I_gray,0.25);

%% ��̬ѧ����

I_bw=bwareaopen(I_bw,150);

%% ��ǲ���
% ���
[B,L]=bwboundaries(I_bw,'noholes');
