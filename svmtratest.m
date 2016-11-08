clear;
clc;
load feature.mat

k=0;
j=1
%sample=cell(20,1);
abc=[];
for i=121:130
    cl1=reshape(clarr{i,1},1,144);
    cl2=reshape(clarr{i,2},1,144);
    cl3=reshape(clarr{i,3},1,144);
    cl4=reshape(clarr{i,4},1,144);
    cl5=reshape(clarr{i,5},1,144);
    cl6=reshape(clarr{i,6},1,144);
     abc=[cl1 cl2 cl3 cl4 cl5 cl6];
     cl7=reshape(clarr{i+20,1},1,144);
    cl8=reshape(clarr{i+20,2},1,144);
    cl9=reshape(clarr{i+20,3},1,144);
    cl10=reshape(clarr{i+20,4},1,144);
    cl11=reshape(clarr{i+20,5},1,144);
    cl12=reshape(clarr{i+20,6},1,144);
    abc1=[cl7 cl8 cl9 cl10 cl11 cl12];
   % abc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    %abc1=reshape(abc,1,864);
       trcarr{j,1}=[abc;]; 
       trcarr{j+1,1}=[abc1;];
       j=j+2;
            %; ];
end
%for i=41:50
    %cl1=reshape(clarr{i+20,1},1,144);
    %cl2=reshape(clarr{i+20,2},1,144);
    %cl3=reshape(clarr{i+20,3},1,144);
    %cl4=reshape(clarr{i+20,4},1,144);
    %cl5=reshape(clarr{i+20,5},1,144);
    %cl6=reshape(clarr{i+20,6},1,144);
    %abc=[cl1 cl2 cl3 cl4 cl5 cl6];
    
   % abc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
 %   abc=[clarr{i+20,1} clarr{i+20,2} clarr{i+20,3} clarr{i+20,4} clarr{i+20,5} clarr{i+20,6}];
%    abc1=reshape(abc,1,864);
     %trcarr1{i,1}=[abc;]; 
           % ; ];
%end

for m=131:140
for i=m
    cl1=reshape(clarr{i,1},1,144);
    cl2=reshape(clarr{i,2},1,144);
    cl3=reshape(clarr{i,3},1,144);
    cl4=reshape(clarr{i,4},1,144);
    cl5=reshape(clarr{i,5},1,144);
    cl6=reshape(clarr{i,6},1,144);
    abc=[cl1 cl2 cl3 cl4 cl5 cl6];
    %abc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    %abc=[clarr{i,1} clarr{i,2} clarr{i,3} clarr{i,4} clarr{i,5} clarr{i,6}];
    %abc1=reshape(abc,1,864);
   sample{m,1}=[abc;]; 
 % ; ];
end
end
i

trmatrix=cell2mat(trcarr);
%trmatrix1=cell2mat(trcarr1);
sampmatrix=cell2mat(sample);


%save('trained.mat','trmatrix','trmatrix1');
save('trained.mat','trmatrix');

load trained.mat



%finaltr=[trmatrix;trmatrix1];



group=[];

for i=1:10
    group=[group;0];
end

for i=1:10
    group=[group;1];
end
options = optimset('maxiter',1000,'largescale','on');
tr = svmtrain(trmatrix,group,'kernel_function','rbf','rbf_sigma',1.2,'quadprog_opts',options);
g=svmclassify(tr,sampmatrix)
