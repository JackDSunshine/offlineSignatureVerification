clear all
%fprintf('The simple local features of the signature before thinning and cropping are:');
%imfinfo('s1.jpg')
fm=[];
for e=54:54

f=strcat('IMG_00',num2str(e),'/');
f1=f;
for x=0:19
    im=[];
    
    f=strcat(f1,num2str(x),'.tiff');
    %disp(f);
    I=imread(f); % Load the image file and store it as the variable I. 
    %figure,imshow(I);
    imf=imfinfo(f);
    h=imf.Height;
    w=imf.Width;
    %I2=imresize(I,[h/2 ,w/2]);
    
    %I2 = wiener2(I,[15 15]);
    %I3=rgb2gray(I2);
    %I3=im2double(I2);
    %I3=im2bw(I2);                       %converting image to black and white
%I3 = bwmorph(~I3, 'thin', inf);                   %thining the image
%I3=~I3;
    %figure,imshow(I3);
    

    xstart=w;
    xend=1;
    ystart=h;
    yend=1;

    for r=1:h
        for c=1:w
            if((I(r,c)==0))
                if (r<ystart)
                    ystart=r;
                end
                if((r>yend))
                    yend=r; 
                end
                if (c<xstart)
                    xstart=c;
                end
                if (c>xend)
                    xend=c;
                end     
            end  
        end
    end
%cutting the image and copying it to another matrix        
    for i=ystart:yend
        for j=xstart:xend
            im((i-ystart+1),(j-xstart+1))=I(i,j);
        end
    end
    
    name=strcat(f1,'crop',num2str(x),'.tiff');
    %figure,imshow(im);     %cropped image
    imwrite(im,name);
%fprintf('The simple local features of the signature after thinning and cropping are:');
%imwrite(im,'crop1.jpg');
%imfinfo('crop1.jpg')

    J=dct2(im);

    for i=1:8
        for j=1:8
            mat(i,j)=J(i,j);
        end
    end
    
    mat;
    f=reshape(mat',1,64);
    fm=[fm ; f];
end

%fm


%result=mean(fm(1:5,1:64))

%for sig=5:19
%    name=strcat('crop',num2str(sig),'.jpg');
%    imfinfo(name);
%    width=imf.Width;
%    for col=1:width
    
%result(1,1)

%for sig=5:19
 %   reject=0;
  %  for col=1:64
        
   %         pos=result(1,col)+(.75*result(1,col));
    %        neg=result(1,col)-(.75*result(1,col));
           
        
    
     %         if(fm(sig,col)<neg || fm(sig,col)>pos)
      %          reject=reject+1;
            
        
     %end  
        
    %end
    %if(reject>30)
     %   disp('reject');
    %end
    
end
save('kb8.mat','fm');
%end
