clear ;  
%% 训练阶段  
ReadList1  = textread('seeds\good\list.txt','%s','delimiter','\n');%载入正样本列表  
sz1=size(ReadList1);  
  
label1=ones(sz1(1),1); %正阳本标签  
ReadList2  = textread('seeds\bad\list.txt','%s','delimiter','\n');%载入负样本列表  
sz2=size(ReadList2);  
label2=zeros(sz2(1),1);%负样本标签  
label=[label1',label2']';%标签汇总  
total_num=length(label);  
data=zeros(total_num,1764);  

%读取正样本并计算hog特征  
for i=1:sz1(1)  
   name= char(ReadList1(i,1));  
   %path = fullfile('C:\Users\Administrator\Desktop\corn-seeds\seeds\good\',imgfilename);
   image=imread(strcat('seeds\good\',name)); 
   im=imresize(image,[64,64]);  
%   img=rgb2gray(im);  
   hog =hogcalculator(im);  
   data(i,:)=hog;  
end  

%读取负样本并计算hog特征  
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

