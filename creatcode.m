function Code=creatcode(B)
%% code to extrac the chain code from the contour
[nr,nc]=size(B{1});
Code=[];
for i=2:nr  
        x=B{1}(i,1)-B{1}(i-1,1);
        y=B{1}(i,2)-B{1}(i-1,2);

    if x==1&y==0
        Code=[Code,0];
    elseif x==1&y==1
        Code=[Code,1];
    elseif x==0&y==1
        Code=[Code,2];
    elseif x==-1&y==1
        Code=[Code,3];
    elseif x==-1&y==0
        Code=[Code,4];
    elseif x==-1&y==-1
        Code=[Code,5];
    elseif x==0&y==-1
        Code=[Code,6];
    elseif x==1&y==-1
        Code=[Code,7];
    end
end
