clc
clear all

%===================================================================%
%           Load Data                                               %
%===================================================================%
load=xlsread("C:\Users\HP\Downloads\Load.xlsx");
%===================================================================%

%===================================================================%
%           Data Normalization                                      %
%===================================================================%
for i=1:size(load,2)
    load(:,i)=(load(:,i)-min(load(:,i)))/(max(load(:,i))-min(load(:,i)));
end
%===================================================================%

%===================================================================%
%           Samples Shuffle                                         %
%===================================================================%
n=size(load,1);
R = randperm(n);
load = load(R, :);
inputs=load(:,1:10)';
targets=load(:,11)';
%===================================================================%


%===================================================================%
%           Model Building                                          %
%===================================================================%
%trainFcn = 'trainbr'; %Bayesian Regularization
%trainFcn = 'trainscg'; % Scaled Conjugate Gradient
trainFcn = 'trainlm'; %Levenburg Margart Algorithm
%net = feedforwardnet(10,trainFcn);
net = fitnet([45,45,45],trainFcn);
net.layers{1}.transferFcn = 'tansig'; %logsig %relu
net.layers{2}.transferFcn = 'tansig';
net.layers{3}.transferFcn = 'tansig';
%net.layers{4}.transferFcn = 'tansig';
net.layers{4}.transferFcn = 'purelin';
view(net)
%===================================================================%

%===================================================================%
%           Data Division                                           %
%===================================================================%
RandStream.setGlobalStream(RandStream('mt19937ar','seed',1)); 
net.divideFcn = 'divideblock'; 
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
%===================================================================%


%===================================================================%
%           Training Parameters                                     %
%===================================================================%
net.trainParam.lr=0.05;  %learning rate
net.trainParam.epochs=5;  %max epochs
net.performFcn='mse';  %Name of a network performance function 
%===================================================================%

%===================================================================%
%           Train Neural Networks                                   %
%===================================================================%
[net,var] = train(net,inputs,targets);
%===================================================================%


%===================================================================%
%           Train Neural Networks                                   %
%===================================================================%
output = net(inputs);
error = gsubtract(targets,output);
performance = perform(net,targets,output);
%===================================================================%

fprintf("Predicted output:%0.2f\n",output);
fprintf("Actual output:%0.2f\n",targets(:,1));
fprintf("Error:%0.2f\n",error);
fprintf("MSE:%0.2f\n",performance);





