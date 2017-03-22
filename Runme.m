clear all; clc

%%
%read input file
[file_name,file_folder]=uigetfile('.bmp','select test image');
file_name=strcat(file_folder,file_name);

%%
%positive image processing
a=Image_processing_main;
a.Img=(imread(file_name));
[a.Img_hsi,a.H,a.S,a.I]=rgb2hsi(a);
IE = histeq(a.I);
SE = histeq(a.S);
a.positive_processing = cat(3,a.H,SE,IE);
a.positive_processing_outcome = hsi2rgb(a);

%%
%Negative domain image processing
b=Image_processing_main;
b.Img=(imread(file_name));
b.cmy=rgb2cmy(b);
[b.Img_hsi,b.H,b.S,b.I]=rgb2hsi(b);
IE_N =histeq(b.I);
SE_N = histeq(b.S);
b.negative_processing= cat(3,b.H,SE_N,IE_N);
b.rgb = hsi2rgb(b);
b.negative_processing_outcome=cmy2rgb(b);

%%
%synthetic part combination of +ve & -ve side
[row,column,slice]=size(a.positive_processing_outcome);
Synthetic_part=zeros(row,column,slice);%pre-allocating memory 
for kk=1:slice
    for ii=1:(row)
        for jj=1:(column)
            if IE(ii,jj)<0.5
                Synthetic_part(ii,jj,kk)=a.positive_processing_outcome(ii,jj,kk);
            else
                Synthetic_part(ii,jj,kk)=b.negative_processing_outcome(ii,jj,kk);
            end
        end
    end
end

%%
%Dispaly result
figure('units','normalized','outerposition',[0 0 1 1])
subplot(1,2,1)
imshow(a.Img),title('Original Image')
% subplot(2,2,2)
% imshow(a.positive_processing_outcome),title('Positive processing outcome')
% subplot(2,2,3)
% imshow(b.negative_processing_outcome),title('Negative processing outcome')
subplot(1,2,2)
imshow(uint8(Synthetic_part)),title('Synthetic combination & final enhaced Image')

