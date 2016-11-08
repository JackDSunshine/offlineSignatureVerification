
clc;
%% iterator function which repeatedly calls the train10svm function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
   A2=train10svmg(incx);
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
        true=true+1;
    elseif(A3(i,j)==1)
        truef=truef+1;
    end
    end
end
%calculating the pecentage accuracies
TAR10sg=(true/380)*100;
FRR10sg=(truef/380)*100;
fprintf('\n tar10sg =%f \n',TAR10sg);
%message=['TAR: ',num2str(TAR10sg),'          ','FRR: ',num2str(FRR10sg)];

resimg=[100,100];
%h=msgbox(message);
for s=1:100
    for w=1:100
        resimg(s,w)=1;
    end
end

figure,imshow(resimg);
text(10,10,'TAR:');
text(50,10,num2str(TAR10sg));
text(10,50,'FRR:');
text(50,50,num2str(FRR10sg));

% saving the result
save('result10svmg.mat','A3','TAR10sg','FRR10sg');
 
