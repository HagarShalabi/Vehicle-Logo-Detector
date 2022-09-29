I=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTestCases\1.jpg");
%%Converts RGB truecolor image to the grayscale image I=(1/3)*I(:,:, 1)+(1/3)*I(:,:, 2)+(1/3)*I(:,:, 3);
% %%Deblurring- Restoring
% PSF = fspecial('motion',21,11);
% Idouble = im2double(I);
% blurred = imfilter(Idouble,PSF,'conv','circular');
% I = deconvwnr(blurred,PSF);

I=rgb2gray(I);
nexttile; imshow(I)
title('Grayscale'); 
%%
%%Cropped Version
%%Checking for the logo in the middle: (Best Case)
targetSize = [150 150];
window = centerCropWindow2d(size(I),targetSize);
Cropped = imcrop(I,window);
nexttile; imshow(Cropped)
title('Cropped');
%%
% Getting the best looking morphological operator on the image- For testing purposes
Canny=edge(uint8(medfilt2(Cropped,[11 11])),'canny');
nexttile;imshow(Canny);
title('Canny Edge Detection');

SE=strel("disk",10);
Closed=imclose(Canny,SE);
nexttile; imshow(Closed);
title('Closed');

Filled =imfill(Closed,'holes');
nexttile; imshow(Filled);
title('Filled');

SE=strel("disk", 50);
Opened=imopen(Filled, SE);
nexttile; imshow(Opened); 
title("Opened");

Extracted=Cropped.* uint8(Opened);
nexttile; imshow(Extracted);
title('Extracted');

%%Threshold the image - Getting the binary image 
B=imbinarize(Extracted); 
nexttile; imshow(B)
title('Binary');

%% 
%%Training for Opel logo 
%1) Read Training Set
A=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\BMW2.jpg");
B=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\HyundaiTest1.jpg");
C=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\HyundaiTest2.jpg");
D=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\HyundaiTest3.jpg");
E= imread("C:\Users\97450\OneDrive\Documents\MATLAB\TrainingSet\KiaTrainingSet\KIA.jpg"); 
F=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\HyundaiTest4.jpg");
G=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\KiaTest.jpeg");
H=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\KiaTest2.jpg");
I=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\Olicit.jpg");
J=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\Skoda.jpg");
K=imread("C:\Users\97450\OneDrive\Documents\MATLAB\TrainingSet\KiaTrainingSet\KiaTest3.jpg");
L=imread("C:\Users\97450\OneDrive\Documents\MATLAB\BonusTrainingSet\Toyota2.jpg");

%2) Convert them to greyscale
A=rgb2gray(A); 
B=rgb2gray(B);
C=im2gray(C);
D=im2gray(D);
E=im2gray(E);
F=rgb2gray(F);
G=rgb2gray(G);
H=im2gray(H);
I=im2gray(I);
J=rgb2gray(J);
K=rgb2gray(K);
L=im2gray(L);

%3) Getting each of their fourier transform features
Aft=fft2(double(A));
Afeatures=abs(Aft(:));
Afeatures=sort(Afeatures,'descend');
Afeatures=Afeatures(1:3);

Bft=fft2(double(B));
Bfeatures=abs(Bft(:));
Bfeatures=sort(Bfeatures,'descend');
Bfeatures=Bfeatures(1:3);

Cft=fft2(double(C));
Cfeatures=abs(Cft(:));
Cfeatures=sort(Cfeatures,'descend');
Cfeatures=Cfeatures(1:3);

Dft=fft2(double(D));
Dfeatures=abs(Dft(:));
Dfeatures=sort(Dfeatures,'descend');
Dfeatures=Dfeatures(1:3);  

Eft=fft2(double(E));
Efeatures=abs(Eft(:));
Efeatures=sort(Efeatures,'descend');
Efeatures=Efeatures(1:3);  

Fft=fft2(double(F));
Ffeatures=abs(Fft(:));
Ffeatures=sort(Ffeatures,'descend');
Ffeatures=Ffeatures(1:3);  

Gft=fft2(double(G));
Gfeatures=abs(Gft(:));
Gfeatures=sort(Gfeatures,'descend');
Gfeatures=Gfeatures(1:3);  

Hft=fft2(double(H));
Hfeatures=abs(Hft(:));
Hfeatures=sort(Hfeatures,'descend');
Hfeatures=Hfeatures(1:3);  

Ift=fft2(double(I));
Ifeatures=abs(Ift(:));
Ifeatures=sort(Ifeatures,'descend');
Ifeatures=Ifeatures(1:3); 

Jft=fft2(double(J));
Jfeatures=abs(Jft(:));
Jfeatures=sort(Jfeatures,'descend');
Jfeatures=Jfeatures(1:3); 

Kft=fft2(double(K));
Kfeatures=abs(Kft(:));
Kfeatures=sort(Kfeatures,'descend');
Kfeatures=Kfeatures(1:3); 

Lft=fft2(double(L));
Lfeatures=abs(Lft(:));
Lfeatures=sort(Lfeatures,'descend');
Lfeatures=Lfeatures(1:3); 
%%Combines all the features to get the min value 
features=[Afeatures,Bfeatures,Cfeatures,Dfeatures, Efeatures, Ffeatures, Gfeatures, Hfeatures, Ifeatures, Jfeatures, Kfeatures, Lfeatures];
Ift=fft2(double(Extracted));
imagefeatures=abs(Ift(:));
imagefeatures=sort(imagefeatures,'descend');
imagefeatures=imagefeatures(1:3);

%%Array to store each image feature value
for i=1:12
Freqs(i)=sqrt((imagefeatures(1)-features(1,i))^2+(imagefeatures(2)-features(2,i))^2+(imagefeatures(3)-features(3,i))^2);
end
Freqs
[MinResult,Index]=min(Freqs);
switch Index
    case 1
        result='BMW'; OUTPUTIMG=A;
    case 2
        result='Hydundai'; OUTPUTIMG=B;
    case 3
        result='Hydundai'; OUTPUTIMG=C;
     case 4
        result='Hydundai'; OUTPUTIMG=D; 
     case 5
        result='Kia'; OUTPUTIMG=E;
     case 6
        result='Hydundai'; OUTPUTIMG=F;
     case 7
        result='Kia'; OUTPUTIMG=G;
      case 8
        result='Kia'; OUTPUTIMG=H;
      case 9
        result='Olicit'; OUTPUTIMG=I;
      case 10
        result='Skoda'; OUTPUTIMG=J;
     case 11
        result='Kia'; OUTPUTIMG=K;
      case 12
        result='Toyota'; OUTPUTIMG=L;
end
%%
%%Features get detected via SURF (function works with greyscale images NOT binary images)
% 1) Reading the images 
LogoImage =OUTPUTIMG;
  Blur = im2double(LogoImage);
  Filter = ones(2)/2.^2;
  LogoImage = imfilter(Blur, Filter,'conv');

CarImage = Cropped;
CarImage=im2gray(CarImage);
[r, c]=size(LogoImage);
CarImage = imresize(CarImage,[r c]) ;

%2) Detect interest points
LogoPoints = detectSURFFeatures(LogoImage);
CarPoints = detectSURFFeatures(CarImage);

figure; imshow(LogoImage); title('Logo Interest Points'); hold on;
plot(selectStrongest(LogoPoints, 50));
figure;
imshow(CarImage); title('Car Interest Points'); hold on;
plot(selectStrongest(CarPoints, 150));
%3) Extract interest points
[lf, LogoPoints] = extractFeatures(LogoImage, LogoPoints);
[cf, CarPoints] = extractFeatures(CarImage, CarPoints);

%4) Match the interest points
MatchedPairs = matchFeatures(lf, cf);
matchedLogoPoints = LogoPoints(MatchedPairs(:, 1), :);
matchedCarPoints = CarPoints(MatchedPairs(:, 2), :);

%5) Display all the matching points
figure;
showMatchedFeatures(LogoImage, CarImage, matchedLogoPoints, ...
    matchedCarPoints, 'montage');

%6) Stating that the brand of the car is Opel
%%If there is matching points within both images, then logo image is vehicle's logo
text(100,30,strcat('\color{black} Brand: ', result))