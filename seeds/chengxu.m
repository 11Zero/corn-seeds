clc; 
clear ;  
%% ѵ���׶�  
ReadList1  = textread('good\123.txt','%s','delimiter','\n');%�����������б�  
sz1=size(ReadList1);  
  
label1=ones(sz1(1),1); %��������ǩ  
ReadList2  = textread('bad\123.txt','%s','delimiter','\n');%���븺�����б�  
sz2=size(ReadList2);  
label2=zeros(sz2(1),1);%��������ǩ  
label=[label1',label2']';%��ǩ����  
total_num=length(label);  
data=zeros(total_num,1764);  

%��ȡ������������hog����  
for i=1:sz1(1)  
   name= char(ReadList1(i,1));  
   image=imread(strcat('good\',name)); 
%    im=imresize(image,[64,64]);  
%   img=rgb2gray(im);  
   hog =hogcalculator(image);  
   data(i,:)=hog;  
end  

%��ȡ������������hog����  
for j=1:sz2(1)  
   name= char(ReadList2(j,1));  
   image=imread(strcat('bad\',name));  
   im=imresize(image,[64,64]);  
   img=rgb2gray(im);  
   hog =hogcalculator(img);  
   data(sz1(1)+j,:)=hog;  
end  

[train, test] = crossvalind('holdOut',label);  
cp = classperf(label);  
svmStruct = svmtrain(data(train,:),label(train));  
save svmStruct svmStruct  
classes = svmclassify(svmStruct,data(test,:));  
classperf(cp,classes,test);  
cp.CorrectRate

%% ѵ����ɺ󱣴� svmStruct���ɶ�������Ķ�����з�����������ִ������ѵ���׶δ���  
load svmStruct  
test=imread('001.jpg');  
     
im=imresize(test,[64,64]);  
figure;  
imshow(im);  
img=rgb2gray(im);  
hogt =hogcalculator(img);  
classes = svmclassify(svmStruct,hogt);%classes��ֵ��Ϊ������  