clc;
%% iterator function which repeatedly calls the train10svm function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
   A2=train10svmfg(incx);
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
    if(mod(i,20)~=0&&mod(i,20)<11&&A3(i,j)==0)
        falsef=falsef+1;
    elseif(mod(i,20)~=0&&mod(i,20)<11&&A3(i,j)==1)
        false=false+1;
    elseif(mod(i,20)==0||mod(i,20)>=11&&A3(i,j)==0) 
        
        true=true+1;
    elseif(mod(i,20)==0||mod(i,20)>=11&&A3(i,j)==1)
        
        truef=truef+1;
    end
    end
end
%calculating the pecentage accuracies
TAR10sfg=(true/190)*100;
FRR10sfg=(truef/190)*100;
TRR10sfg=(false/190)*100;
FAR10sfg=(falsef/190)*100;
% saving the result
save('result10svmfg.mat','A3','TAR10sfg','FRR10sfg','TRR10sfg','FAR10sfg');
 
