clc; clear all; close all;
%% mean field method
%% load datasets
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\parameter.mat');
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\structure.mat'); 
%% parameters
thres = 1e-7; 
iter_num = 100 ;
total_num = 20;
unknown_num = 17;   
unknown_ind = [1:14, 16:17, 20]; 
variable_names = {BirthAsphyxia, Disease, Age, LVH, DuctFlow, CardiacMixing, LungParench,...
    LungFlow, Sick, HypDistrib, HypoxiaInO2, CO2, ChestXray, Grunting, LVHreport, LowerBodyO2,...
    RUQO2, CO2Report, XrayReport, GruntingReport  };  

%% initialize 
beta = zeros(total_num, 6);  
err = zeros(total_num, 6);
all_results = [];
for k = 1: total_num
    for i = 1:domain_counts(k)  
            beta(k,i) = rand; 
    end 
    beta(k,:) = beta(k,:)./sum(beta(k,:)); 
end 

all_results = zeros(1,iter_num);
for iter =1:iter_num 
    beta_old = beta;   
    for i =  1:total_num %update the ith node with the state of s 
        Eqi = zeros(1,domain_counts(i));
        for s = 1:domain_counts(i) 
            [ Eqi(s)  ] = Eq_i(total_num, dag, i , s, domain_counts, beta,variable_names  );
        end    
        for k = 1: domain_counts(i)
            beta(i,k) = exp(Eqi(k))/sum(exp(Eqi)) ; 
            err(i,k) = norm(beta(i,k) - beta_old(i,k)); 
        end
    end   
    if min(min(err)) < thres
        break
    end  
    all_results(iter) = beta(1,1) ;
    if mod(iter, 1) ==1
        fprintf('The result is %.4f \n', beta(1,1));
    end
end
Pl_inf  = beta(1,1)
MAP_inference = find(beta(2,:) == max(beta(2,:)))     
