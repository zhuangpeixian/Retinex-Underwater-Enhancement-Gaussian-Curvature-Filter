%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Cited IEEE ICSIP 2019 paper: Underwater Image Enhancement by Gaussian Curvature Filter, 
%% Jiaying Xiong, Yuxiang Dai, Peixian Zhuang, 2019.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Code written by Peixian Zhuang, Nanjing University of Information Science and Technology
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;  clc; clear all;


gamma = 1; beta  = 100; alpha = 100; 

img1 = double(imread('Ori2.jpg'));

lambta = 1;                 
MaxIteration = 60;    

DataFitOrder = 1.5;    
Lambda = 3;             
FilterType = 0;           

iter=2;
 
img     = double(color(img1,2.5));
cform = makecform('srgb2lab'); 
lab     = applycform(uint8(img), cform);
LL      = lab(:,:,1);
A       = lab(:,:,2);
B       = lab(:,:,3);


img =double(img);
V_S = double(LL); 

[row, col, dim] = size(img);
eigsDtD = getC(V_S);  


lambta = 1;                
MaxIteration = 60;    

DataFitOrder = 1.5;    
Lambda = 3;               
FilterType = 0;          

H  = fspecial('gaussian',51,2);
L1 = filter2(H,V_S); 
x   = L1;
R1 = V_S./L1; 

iter  = 2;

for i = 1 : iter
    
    
    [R1,energy1] = Solver(V_S./(L1 + eps), FilterType, DataFitOrder, Lambda, MaxIteration);

    
    R1 =  max(0.001,min(R1,1));
    
    
    %%   Curvature Filter Solver for Variational Models
    [L1,energy] = Solver(V_S./(R1 + eps), FilterType, DataFitOrder, Lambda, MaxIteration);
    L1  = min(255,max(L1,V_S));

    

end

R = real(R1);     L = real(L1);   

[L11] = illumination_adjust(L,15,230); 
R11  = adapthisteq(R);  

lab(:,:,1)   = L11.*R11;
cform  = makecform('lab2srgb'); 
enhanced2 = applycform(lab, cform);
enhanced2 = cast(enhanced2, 'uint8');

figure, imshow([uint8(img1), enhanced2]);

