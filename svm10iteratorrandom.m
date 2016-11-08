clc;
%% iterator function which repeatedly calls the train10svm function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
   A2=train10svmrandom(incx);
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
        true=true+1;
    elseif(mod(i,20)~=0&&mod(i,20)<11&&A3(i,j)==1)
        truef=truef+1;
    elseif(mod(i,20)==0||mod(i,20)>=11&&A3(i,j)==0) 
        falsef=falsef+1;
    elseif(mod(i,20)==0||mod(i,20)>=11&&A3(i,j)==1)
        false=false+1;
    end
    end
end
%calculating the pecentage accuracies
TAR10sr=(true/190)*100;
FRR10sr=(truef/190)*100;
TRR10sr=(false/190)*100;
FAR10sr=(falsef/190)*100;

resimg1=[500,500];
%h=msgbox(message);
for s=1:500
    for w=1:500
        resimg1(s,w)=1;
    end
end

figure,imshow(resimg1);
hold on;
text(10,10,'TAR:')
text(50,10,num2str(TAR10sr))
text(10,50,'FRR:')
 text(50,50,num2str(FRR10sr))
 text(10,90,'TRR:')
text(50,90,num2str(TRR10sr))
 text(10,130,'FAR:')
text(50,130,num2str(FAR10sr))
% saving the result
save('result10svmr.mat','A3','TAR10sr','FRR10sr','TRR10sr','FAR10sr');
 
