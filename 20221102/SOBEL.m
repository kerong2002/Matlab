img_take=imread('C:\Users\User\Documents\MATLAB\0928\Wang.jpg');    %hight * width * 3
get=rgb2gray(img_take);             % get 2D image (120 * 160)
Gray_Img=imresize(get,1/2);         % img size / 2 ( 60 * 80)
% imshow(Gray_Img);                 % gray img
[Y_size,X_size] = size(Gray_Img);   % get image size 
%======================<save data to register>=================
rom=fopen('C:\Users\User\Documents\MATLAB\0928\rom.txt','wt');% write data
input=fopen('C:\Users\User\Documents\MATLAB\0928\input.txt','wt');% write databin2dec

for y=1:Y_size
    fprintf(rom,"always @(x or y)begin\n");
    fprintf(rom,"\tcase(y)\n");
    fprintf(rom,'\t\t%d:case(x)\n',y);
    for x=1:X_size
        number = Gray_Img(y,x);
        fprintf(input,"%s\n",dec2bin(number,8));
        fprintf(rom,'\t\t\t%d:data=8''d%d;\n',x,Gray_Img(y,x));
    end
    fprintf(rom,'\t\t\tdefault:data=0;\n\t\tendcase\n\tendcase\n');
    fprintf(rom,'end\n');
end
fclose(input);
fclose(rom);
%====================<transfer INT_32>==================
Img_32=int32(Gray_Img);        %int_8 = 0~255
for y=1:Y_size-2
    for x=1:X_size-2
        Gh_pos(y,x) = Img_32(y,x)+2*Img_32(y,x+1)+Img_32(y,x+2);
        Gh_neg(y,x) = Img_32(y+2,x)+2*Img_32(y+2,x+1)+Img_32(y+2,x+2);
        Gv_pos(y,x) = Img_32(y,x)+2*Img_32(y+1,x)+Img_32(y+2,x);
        Gv_neg(y,x) = Img_32(y,x+2)+2*Img_32(y+1,x+2)+Img_32(y+2,x+2);
        if(Gh_pos(y,x)>=Gh_neg(y,x))
            Gh(y,x) = Gh_pos(y,x) - Gh_neg(y,x);
        else
            Gh(y,x) = Gh_neg(y,x) - Gh_pos(y,x);
        end
        if(Gv_pos(y,x)>=Gv_neg(y,x))
            Gv(y,x) = Gv_pos(y,x) - Gv_neg(y,x);
        else
            Gv(y,x) = Gv_neg(y,x) - Gv_pos(y,x);
        end
    end
end
%======================<add_ans result>=================
for y=1:Y_size-2
    for x=1:X_size-2
        add_ans(y,x) =abs(Gh(y,x)) + abs(Gv(y,x));
    end
end
%======================<power result>=================

for y=1:Y_size-2
    for x=1:X_size-2
        G(y,x) =(Gh(y,x)^2 + Gv(y,x)^2);
    end
end

%===================<sqrt_ans result>==============
for y=1:Y_size-2
    for x=1:X_size-2
        sqrt_ans(y,x) =sqrt(double(G(y,x)));
    end
end