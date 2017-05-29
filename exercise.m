clear ;  
%% ѵ���׶�  
ReadList1  = textread('seeds\good\list.txt','%s','delimiter','\n');%�����������б�  
sz1=size(ReadList1);  
  
label1=ones(sz1(1),1); %��������ǩ  
ReadList2  = textread('seeds\bad\list.txt','%s','delimiter','\n');%���븺�����б�  
sz2=size(ReadList2);  
label2=zeros(sz2(1),1);%��������ǩ  
label=[label1',label2']';%��ǩ����  
total_num=length(label);  
data=zeros(total_num,1764);  

%��ȡ������������hog����  
for i=1:sz1(1)  
   name= char(ReadList1(i,1));  
   %path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\',imgfilename);
   image=imread(strcat('seeds\good\',name)); 
   im=imresize(image,[64,64]);  
%   img=rgb2gray(im);  
   hog =hogcalculator(im);  
   data(i,:)=hog;  
end  

%��ȡ������������hog����  
for j=1:sz2(1)  
   name= char(ReadList2(j,1));  
   image=imread(strcat('seeds\bad\',name));  
   im=imresize(image,[64,64]);  
   %img=rgb2gray(im);  
   hog =hogcalculator(im);  
   data(sz1(1)+j,:)=hog;  
end  

[train, test] = crossvalind('holdOut',label);  
cp = classperf(label);  
svmStruct = svmtrain(data(train,:),label(train));  
%save svmStruct svmStruct  
save('svmStruct.mat','svmStruct');
classes = svmclassify(svmStruct,data(test,:));  
classperf(cp,classes,test);  
cp.CorrectRate

