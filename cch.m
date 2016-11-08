function cch
clc
%% code to extract the chain code and apply gaussian filter on the image and generate the feature matrix
fprintf('\nFeature Matrix Extraction Started\n');
fprintf('\n Processing This may take some time please wait......\n');
incr=0;
clarr=cell(760,6);
%loop to read the images
for e=1:38
f=strcat('IMG_00',num2str(e),'/');
f1=f;
for z=0:19
    incr=incr+1;   
    f=strcat(f1,'contour',num2str(z),'.tiff');
    im=imread(f);
    [m n]=size(im);

    w=ceil(m/12);
    x=ceil(n/12);

    m=w*12;
    n=x*12;

    im4=imresize(im,[m,n]);
    [m n]=size(im4);
    c=mat2cell(im4,[m/12 m/12 m/12 m/12 m/12 m/12 m/12 m/12 m/12 m/12 m/12 m/12], [n/12 n/12 n/12 n/12 n/12 n/12 n/12 n/12 n/12 n/12 n/12 n/12]);

    hmat=[];vmat=[];lmat=[];rmat=[];
% loop to find the 8connectivity pixels horizontal,vertical,left diagonal
% and right diagonal to the current pixel H,V,L,R
for i=1:12
    for j=1:12
   
        J=boundaries(c{i,j},8,'cw');
        if(isempty(J))
            hi=0;vi=0;li=0;ri=0;
        else
        Code=creatcode(J);
        
        h=0;v=0;l=0;r=0;
        [m n]=size(Code);
        for p=1:n
            switch Code(p)
                case {0,4}
                    h=h+1;
                case {1,5}
                    r=r+1;
                case {2,6}
                    v=v+1;
                case {3,7}
                    l=l+1;
            end
        end
        
        hi=h/n;
        if(isnan(hi))
            hi=0;
        end
        
        vi=v/n;
        if(isnan(vi))
            vi=0;
        end
        
        li=l/n;
        if(isnan(li))
            li=0;
        end
        
        ri=r/n;
        if(isnan(ri))
            ri=0;
        end
        end
        
        hmat=[hmat,hi];
        vmat=[vmat,vi];
        lmat=[lmat,li];
        rmat=[rmat,ri];
        
    end
   
end
hmat=reshape(hmat,12,12);hmat=hmat';
vmat=reshape(vmat,12,12);vmat=vmat';
rmat=reshape(rmat,12,12);rmat=rmat';
lmat=reshape(lmat,12,12);lmat=lmat';

% create a guassian filter
fil=fspecial('gaussian',[3 3],1.2);
realfil1=imfilter(hmat,fil);
realfil2=imfilter(vmat,fil);
realfil3=imfilter(lmat,fil);
realfil4=imfilter(rmat,fil);

% to find the maximum number value in the horizontal ,vertical,left
% diagonal and right diagonal matrices
 m1=max(max(realfil1));
 m2=max(max(realfil2));
 m3=max(max(realfil3));
 m4=max(max(realfil4));

 % maximum of all the matrices
 allmax=[m1 m2 m3 m4];
 
 maxi=max(allmax);
 
 for i=1:12
     for j=1:12
         realfil1(i,j)=realfil1(i,j)/maxi;
         realfil2(i,j)=realfil2(i,j)/maxi;
         realfil3(i,j)=realfil3(i,j)/maxi;
         realfil4(i,j)=realfil4(i,j)/maxi;
     end
 end
 % addmod=max(H,V)/min(H,V) if max(H,V)~=0 or =0 if max(H,V)=0
 % mulmod=min(L,R)/max(L,R) if max(L,R)~=0 or =0 if max(L,R)=0
 addmod=[];
 mulmod=[];
 for i=1:12
     for j=1:12
         max1=max(realfil1(i,j),realfil2(i,j));
         max2=max(realfil3(i,j),realfil4(i,j));
         min1=min(realfil1(i,j),realfil2(i,j));
         min2=min(realfil3(i,j),realfil4(i,j));
         if(max1==0)
         addmod(i,j)=0;
         else
             addmod(i,j)=max1/min1;
         end
         if(max2==0)
             mulmod(i,j)=0;
         else
             mulmod(i,j)=min2/max2;
         end
         
     end
 end
 
 %appending the features of all images to the feature cell array clarr
 clarr(incr,1)={realfil1};
 clarr(incr,2)={realfil2};
 clarr(incr,3)={realfil3};
 clarr(incr,4)={realfil4};
 clarr(incr,5)={addmod};
 clarr(incr,6)={mulmod};
end

end
% saving the feature matrix
save('feature.mat','clarr');
fprintf('\nFeature matrix generated\n');
 
 


