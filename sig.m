function sig
clc;
%% code to extract the individual signatures from the scanned sheet which contains 20 samples of an individual person


%loop to extract the samples into a folder
for x=1:38
    f=strcat('IMG_00',num2str(x));
    fname=strcat(f,'.jpg');
    mkdir(f);    
    im=imread(fname); 
    im = im2double(im);
    f_makebw = @(I) im2bw(I.data, double(median(I.data(:)))/1.45);
    I0 = blockproc(im, [128 128], f_makebw);
    imf=imfinfo(fname);
    h=imf.Height;
    w=imf.Width;

    for i=0:9
        r=0;
        for j=(i*round(h/10)+1):((i+1)*round(h/10))
            if(j<=h)
                r=r+1;
                for c=1:w
                    if(c<round(w/2))
                        im1(r,c)=I0(j,c);
                    else
                        c1=c-round(w/2)+1;
                        im2(r,c1)=I0(j,c);
                    end
                end
            end
        end
    %part to save the extracted samples    
        name1=strcat(f,'/',num2str(2*i),'.tiff');
        name2=strcat(f,'/',num2str(2*i+1),'.tiff');
        
        imwrite(im1,name1);
        imwrite(im2,name2);
    end
end
fprintf('\nEnd of sig.m\n');