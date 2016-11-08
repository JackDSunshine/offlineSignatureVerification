clc;
%% iterator function which repeatedly calls the tester function for signature of each individual and generates the training matrix and testing for genuine or forgery
% Also here we calculate True acceptance ratio,false acceptance ratio,true
% rejection ratio and false rejection ratio
% loop to generate training and testing matrix for each individual
incx=1;
A3=[];
for iter=1:19
    A2=mlp10trainfg(incx);
    A3=[A3;A2];
    incx=incx+40;
end
 
tar=0;far=0;trr=0;frr=0;
% To calculate the TAR,FRR,TRR and FAR based on the testing
for i=1:19
    for j=1:20
        if(j<11 && A3(i,j)<=0.6000)
            far=far+1;
        elseif(j<11 && A3(i,j)>0.6000)
            trr=trr+1;
        elseif(j>=11 && A3(i,j)<=0.6000)      
             tar=tar+1;
        else     
             frr=frr+1;
        end
    end
end
%calculating the pecentage accuracies
tarp=tar/190;
farp=far/190;
trrp=trr/190;
frrp=frr/190;
TAR10mfg=tarp*100;
FAR10mfg=farp*100;
TRR10mfg=trrp*100;
FRR10mfg=frrp*100;
% saving the result
save('result10mlpfg.mat','A3','TAR10mfg','FAR10mfg','TRR10mfg','FRR10mfg');
        