function result = Judgeimg(imgfilename)
%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
load svmStruct  
path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds',imgfilename);
img=imread(path); 
im=imresize(img,[64,64]);  
figure;  
imshow(im);  
%img=rgb2gray(im);  
hogt =hogcalculator(im);  
result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  