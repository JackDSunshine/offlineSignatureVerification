clc;
clear;
load feature.mat
trcarr=cell(190,1);
trcarr1=cell(190,1);
%sample=cell(20,1);
k=0;
i=1;
while i<=760
    if(mod(i,40)==11)
        k=round(i/40)*10+11;
        i=i+30;
    else
        k=k+1;
    end
    
    if(i<761)
        trcarr{k,1}=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6} ; ];
        
    end
    i=i+1;
end

l=21;

while l<=760
    if(mod(i,40)==31)
        l=round(i/40)*10+1;
        i=i+30;
    end
    
    if(i<761)
        trcarr1{l,1}=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6} ; ];
    end
    l=l+1;
end

%trmatrix=cell2mat(trcarr);
%trmatrix1=cell2mat(trcarr1);
