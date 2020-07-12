close all;
clear
clc



sss = 0.1768;        % Kernel parameter£ºsss
xxx = 2;             % The number of training samples

% Temp£ºx1*x2 cell data, where x1 represents the number of classes of training samples, x2 represents the number of samples in each class.
load('Temp.mat');    
Temp = Temp(1:10,:); % Using the first 10 classes.
sigma = [1,sss];     % Kernel parameter£¬where sigma(1) is mostly used for the Poly kernel.
opt = optimset('LargeScale', 'off', 'Algorithm', 'active-et','display','off');

tic
[acc]=main(Temp,xxx,opt,sigma);
toc
