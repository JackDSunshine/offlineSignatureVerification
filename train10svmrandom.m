function [classes]=train10svmrandom(incx)
%% code to train using svm and test the samples
% here we take 10 genuine and 10 forgeries to train using svm
load feature.mat;
clc;
train7=cell(2,20);
j=1;
i=incx;
gen=randperm(20);
% loop to generate training matrix
for k=1:10
    i=gen(k);
    
    cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    B=reshape(cc,864,1);
    train7{1,j}=[B; ];
    j=j+1;
    if(k==10)
        for l=1:10
            i=gen(l)+20;
            cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
            B=reshape(cc,864,1);
            train7{1,j}=[B; ];
            j=j+1;
        end
    end
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
i=incx;
%=================Testing using 15 genuine and 15 forgery samples=================%
for k=11:20
    i=gen(k);
    
    cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    B=reshape(cc,864,1);
    train8{1,j}=[B; ];
    j=j+1;
    if(k==20)
        for l=11:20
            i=gen(l)+20;
            cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
            B=reshape(cc,864,1);
            train8{1,j}=[B; ];
            j=j+1;
        end
    end
end

P12 = cell2mat(train8(1,:));
classes = svmclassify(net,P12');

 