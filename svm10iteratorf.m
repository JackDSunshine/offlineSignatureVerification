clc;
%% iterator function which repeatedly calls the train10svm function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
   A2=train10svmf(incx);
    A3=[A3;A2];
    incx=incx+40;
end
true=0;
truef=0;
false=0;
falsef=0;
% To calculate the TAR,FRR,TRR and FAR based on the testing
for i=1:380
    for j=1
    if(A3(i,j)==0) 
        falsef=falsef+1;
    elseif(A3(i,j)==1)
        false=false+1;
    end
    end
end
%calculating the pecentage accuracies
TRR10sf=(false/380)*100;
FAR10sf=(falsef/380)*100;
resimg=[100,100];
%h=msgbox(message);
for s=1:100
    for w=1:100
        resimg(s,w)=1;
    end
end

figure,imshow(resimg);
text(10,10,'TRR:');
text(50,10,num2str(TRR10sf));
text(10,50,'FAR:');
text(50,50,num2str(FAR10sf));

% saving the result
save('result10svmf.mat','A3','TRR10sf','FAR10sf');
 
