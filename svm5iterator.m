clc;
%% iterator function which repeatedly calls the train5svm function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
   A2=train5svm(incx);
    A3=[A3;A2];
    incx=incx+40;
end
true=0;
truef=0;
false=0;
falsef=0;
% To calculate the TAR,FRR,TRR and FAR based on the testing
for i=1:570
    for j=1
    if(mod(i,30)~=0&&mod(i,30)<16&&A3(i,j)==0)
        true=true+1;
    elseif(mod(i,30)~=0&&mod(i,30)<16&&A3(i,j)==1)
        truef=truef+1;
    elseif(mod(i,30)==0||mod(i,30)>=16&&A3(i,j)==0) 
        falsef=falsef+1;
    elseif(mod(i,30)==0||mod(i,30)>=16&&A3(i,j)==1)
        false=false+1;
    end
    end
end
%calculating the pecentage accuracies
TAR5s=(true/285)*100;
FRR5s=(truef/285)*100;
TRR5s=(false/285)*100;
FAR5s=(falsef/285)*100;

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
text(50,10,num2str(TAR5s))
text(10,50,'FRR:')
 text(50,50,num2str(FRR5s))
 text(10,90,'TRR:')
text(50,90,num2str(TRR5s))
 text(10,130,'FAR:')
text(50,130,num2str(FAR5s))

% saving the result
save('result5svm.mat','A3','TAR5s','FRR5s','TRR5s','FAR5s');
 
