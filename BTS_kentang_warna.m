clc; clear; close all;
%1. read  
I = imread('bts-kentang.png');
%figure, imshow(I);
%2. RGB vs HSV 
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

Rn = cat(3,R,G*0,B*0);
Gn = cat(3,R*0,G,B*0);
Bn = cat(3,R*0,G*0,B);

figure,imshow(Rn);
figure,imshow(Gn);
figure,imshow(Bn);

HSV = rgb2hsv(I);
%figure, imshow(HSV);

H = HSV(:,:,1);
S = HSV(:,:,2);
V = HSV(:,:,3);
figure,imshow(H);
figure,imshow(S);
figure,imshow(V);

%3. tresholding saturation
bw = im2bw(S,.18); %putih=1 ; hitam=0 --> scala 0,4 terlalu besar, --> 0,2
figure, imshow(bw);

%4. morfologi
bw = imfill(bw,'holes');
bw = bwareaopen(bw,100); %Remove objects containing fewer than ... pixels using bwareaopen function
str = strel('square',1); %creates a square structuring element whose width is (w) pixels --> kalo kebesaran gk halus luarnya
bw = imopen(bw,str);
figure, imshow(bw);

%5. tampilkan RGB aslinya lagi
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);
  
R(~bw) = 0;
G(~bw) = 0;
B(~bw) = 0;
  
RGB = cat(3,R,G,B);
figure, imshow(RGB);

%6. labeling
[L,num] = bwlabel(bw);
for n = 1:num
    bw2 = L==n;
 
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
     
    R(~bw2) = 0;
    G(~bw2) = 0;
    B(~bw2) = 0;
    RGB = cat(3,R,G,B);
 
    [a,b] = find(bw2==1);
    Hue = 0;
 
    for m = 1:numel(a)
        Hue = Hue+double(H(a(m),b(m)));
    end
     
    Hue = Hue/numel(a);
     
    if Hue < 11/255       % merah
        Warna = 'merah';
    elseif Hue < 32/255   % jingga
        Warna = 'jingga';
    elseif Hue < 54/255   % kuning
        Warna = 'kuning';
    elseif Hue < 116/255  % hijau 
        Warna = 'hijau';
    elseif Hue < 141/255  % cyan
        Warna = 'cyan';
    elseif Hue < 185/255  % biru
        Warna = 'biru';
    elseif Hue < 202/255  % ungu
        Warna = 'ungu';
    elseif Hue < 223/255  % magenta
        Warna = 'magenta';
    elseif Hue < 244/255  % merah muda
        Warna = 'merah muda';
    else
        Warna = 'merah';
    end
         
    [B,~] = bwboundaries(bw2,'noholes');
    boundary = B{1};
    position = [boundary(1,2),boundary(1,1)-80;boundary(1,2),boundary(1,1)-40;...
        boundary(1,2),boundary(1,1)];
    box_color = {'yellow','yellow','yellow'};
     
    text_str = cell(2,1);
    text_str{1} = ['Label: ' num2str(n)];
    text_str{2} = ['Hue: ' num2str(Hue,'%0.2f')];
    text_str{3} = ['Warna: ' Warna];
         
    RGB2 = insertText(I,position,text_str,'FontSize',20,'BoxColor',box_color,'BoxOpacity',0.8,'TextColor','white');
    figure, imshow(RGB2);
end


