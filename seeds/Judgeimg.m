function result = Judgeimg(imgfilename)
%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
svmStruct = load('C:\Users\Administrator\Desktop\corn-seeds\svmStruct.mat');
svmStruct = svmStruct.svmStruct;
path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds\good',imgfilename);
img=imread(path);
im=imresize(img,[64,64]);
figure;  
imshow(im);  
%img=rgb2gray(im);  
hogt =hogcalculator(im);  
result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  
%% ����good����

ReadList1  = textread('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\list.txt','%s','delimiter','\n');%�����������б�  
sz1=size(ReadList1);
count = 0;
for i=1:sz1(1)  
   name= char(ReadList1(i,1));
   %path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\',imgfilename);
   image=imread(strcat('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\',name)); 
   im=imresize(image,[64,64]);  
%   img=rgb2gray(im);  
   hogt =hogcalculator(im);  
   result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  
   %disp(result);
   if(result==1)
        count = count+1;
   end
end  
disp(count/sz1(1));

%% ����bad����
ReadList2  = textread('C:\Users\Administrator\Desktop\corn-seeds\seeds\bad\list.txt','%s','delimiter','\n');%�����������б�  
sz2=size(ReadList2);
count = 0;
for i=1:sz2(1)  
   name= char(ReadList2(i,1));  
   %path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\',imgfilename);
   image=imread(strcat('C:\Users\Administrator\Desktop\corn-seeds\seeds\bad\',name)); 
   im=imresize(image,[64,64]);  
%   img=rgb2gray(im);  
   hogt =hogcalculator(im);  
   result = svmclassify(svmStruct,hogt);%result��ֵ��Ϊ������  
   %disp(result);
   if(result==0)
        count = count+1;
   end
end  
disp(count/sz2(1));
