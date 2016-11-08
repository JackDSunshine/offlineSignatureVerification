clc;
%% iterator function which repeatedly calls the tester function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
    A2=tester(incx);
    A3=[A3;A2];
    incx=incx+40;
end
 
tar=0;far=0;trr=0;frr=0;
% To calculate the TAR,FRR,TRR and FAR based on the testing
for i=1:19
    for j=1:20
        if(j<11 && A3(i,j)<=0.6000)
            tar=tar+1;
        elseif(j<11 && A3(i,j)>0.6000)
            frr=frr+1;
        elseif(j>=11 && A3(i,j)<=0.6000)
            far=far+1;
        else
            trr=trr+1;
        end
    end
end
%calculating the pecentage accuracies
tarp=tar/190;
farp=far/190;
trrp=trr/190;
frrp=frr/190;
TAR10m=tarp*100;
FAR10m=farp*100;
TRR10m=trrp*100;
FRR10m=frrp*100;

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
text(50,10,num2str(TAR10m))
text(10,50,'FRR:')
 text(50,50,num2str(FRR10m))
 text(10,90,'TRR:')
text(50,90,num2str(TRR10m))
 text(10,130,'FAR:')
text(50,130,num2str(FAR10m))
% saving the result
save('result10mlp.mat','A3','TAR10m','FAR10m','TRR10m','FRR10m');
        