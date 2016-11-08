function [A1]=tester(incx)
%% code to train using mlp and test the samples
% here we take 10 genuine and 10 forgeries to train using mlp
clc;
load feature.mat;
train1=cell(2,20);
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
    cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    B=reshape(cc,864,1);
    train1{1,j}=[B; ];
    j=j+1;
    i=i+1;
end

train1(2,1)={0};train1(2,2)={0};train1(2,3)={0};train1(2,4)={0};train1(2,5)={0};train1(2,6)={0};train1(2,7)={0};train1(2,8)={0};train1(2,9)={0};train1(2,10)={0};train1(2,11)={1};train1(2,12)={1};train1(2,13)={1};train1(2,14)={1};train1(2,15)={1};train1(2,16)={1};train1(2,17)={1};train1(2,18)={1};train1(2,19)={1};train1(2,20)={1};
%extract training matrix
P = cell2mat(train1(1,:));
T = cell2mat(train1(2,:));
[R,Q] = size(P);
[S2,Q] = size(T);
 
 
S1 = 15;   % hidden layers
net = newff(minmax(P),[S1 S2],{'logsig' 'logsig'},'traingdx');
net.LW{2,1} = net.LW{2,1}*0.01;
net.b{2} = net.b{2}*0.01;

net.performFcn = 'sse';        % Sum-Squared Error performance function
net.trainParam.goal = 0.001;   % Sum-squared error goal.
net.trainParam.show = 20;      % Frequency of progress displays (in epochs).
net.trainParam.epochs = 4500;   % Maximum number of epochs to train.
net.trainParam.mc = 0.95;   
trainParam.min_grad = 1e-5;

net.trainParam.lr = 0.05;
net.trainParam.lr_inc = 1.01;

%training using mlp
[net,tr] = train(net,P,T);

%=================Testing using 10 genuine and 10 forgery samples=================%


train2=cell(2,20);
j=1;
i=incx;

while i<=incx+39
    if(i==incx||i==incx+20)
        i=i+10;
        
    end
   
   cc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
   B=reshape(cc,864,1);
    train2{1,j}=[B; ];
    j=j+1;
    i=i+1;
end

P1 = cell2mat(train2(1,:));

A1 = sim(net,P1);
end
