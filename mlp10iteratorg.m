clc;
%% iterator function which repeatedly calls the tester function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
    A2=mlp10traing(incx);
    A3=[A3;A2];
    incx=incx+40;
end
 
tar=0;far=0;trr=0;frr=0;
% To calculate the TAR,FRR,TRR and FAR based on the testing
for i=1:19
    for j=1:20
        if(A3(i,j)<=0.6000)
            tar=tar+1;
        elseif( A3(i,j)>0.6000)
            frr=frr+1;
        
        end
    end
end
%calculating the pecentage accuracies
tarp=tar/380;


frrp=frr/380;
TAR10mg=tarp*100;

FRR10mg=frrp*100;

resimg1=[100,100];
%h=msgbox(message);
for s=1:100
    for w=1:100
        resimg1(s,w)=1;
    end
end

figure,imshow(resimg1);
hold on;
text(10,10,'TAR:')
text(50,10,num2str(TAR10mg))
text(10,50,'FRR:')
 text(50,50,num2str(FRR10mg))
% saving the result
save('result10mlpg.mat','A3','TAR10mg','FRR10mg');
        