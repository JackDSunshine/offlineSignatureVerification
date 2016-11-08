function [classes]=train10svmf(incx)
%% code to train using svm and test the samples
% here we take 10 genuine and 10 forgeries to train using svm
load feature.mat;
clc;
train7=cell(2,20);
j=1;
i=incx;
% loop to generate training matrix
while i<=incx+39
    
    if(i==incx+10)
        i=i+10;
       
    end
    if(i==incx+30)
        break;
    end
    cc11=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    B5=reshape(cc11,864,1);
    train7{1,j}=[B5; ];
    j=j+1;
    i=i+1;
end

train7(2,1)={0};train7(2,2)={0};train7(2,3)={0};train7(2,4)={0};train7(2,5)={0};train7(2,6)={0};train7(2,7)={0};train7(2,8)={0};train7(2,9)={0};train7(2,10)={0};train7(2,11)={1};train7(2,12)={1};train7(2,13)={1};train7(2,14)={1};train7(2,15)={1};train7(2,16)={1};train7(2,17)={1};train7(2,18)={1};train7(2,19)={1};train7(2,20)={1};
%extract training matrix
P11 = cell2mat(train7(1,:));
T11 = cell2mat(train7(2,:));
[R,Q] = size(P11);
[S2,Q] = size(T11);
options = optimset('maxiter',100000);

%training using svm
net = svmtrain(P11',T11','Kernel_Function','linear','Polyorder',2,'quadprog_opts',options);
train8=cell(2,20);
j=1;
i=incx+20;
%=================Testing using 15 genuine and 15 forgery samples=================%
while i<=incx+39
   cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
   B6=reshape(cc,864,1);
    train8{1,j}=[B6; ];
    j=j+1;
    i=i+1;
end

P12 = cell2mat(train8(1,:));
classes = svmclassify(net,P12');

 