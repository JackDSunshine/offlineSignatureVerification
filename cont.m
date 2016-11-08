function cont
clc
%% code to extract contour of the samples and save the contour of the image

% loop to extract and save the contour of the images

figure,imshow('IMG_001.jpg'),title('img');
for e=1:38
f=strcat('IMG_00',num2str(e),'/');
f1=f;
for z=0:19
f=strcat(f1,num2str(z),'.tiff');
I1=imread(f);
x=[];
y=[];
img=imcontour(I1);
set(gca,'xcolor',get(gcf,'color'));
set(gca,'ycolor',get(gcf,'color'));
set(gca,'ytick',[]);
set(gca,'xtick',[]);
name=strcat(f1,'contour',num2str(z));
name1=strcat(f1,'contouru',num2str(z));
savefig(name,'tiff','-gray')    
end
end




    
    
