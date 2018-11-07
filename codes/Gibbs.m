clc; close all; clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gibbs Sampling Method to compute P(X|E)
%% load datasets
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\parameter.mat');
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\structure.mat');
%% parameters
iter_num = 10000000;
total_num = 20;
unknown_num = 17;
burn_in = 10000  ;
skip = 100;
sample_num = 100000   ;
times = 1;
X = zeros(1,total_num); 
unknown_ind = [1:14, 16:17, 20];
variable_names = {BirthAsphyxia, Disease, Age, LVH, DuctFlow, CardiacMixing, LungParench,...
    LungFlow, Sick, HypDistrib, HypoxiaInO2, CO2, ChestXray, Grunting, LVHreport, LowerBodyO2,...
    RUQO2, CO2Report, XrayReport, GruntingReport  };  

%% initialize 
for k = 1: total_num
    X(k) = randi(domain_counts(k));
end
X(18) = 1; X(15) = 1; X(19) = 3; 
samples = [];
for i = 1:iter_num
    %% randomly pick one state
    j = randi(unknown_num);
    index = unknown_ind(j); 
    %% update X(index)
    prob = zeros(domain_counts(index),1); 
    children = find (dag( index,:) == 1);
    child_num = sum(dag( index,:)); 
    for s = 1:domain_counts(index)
        X(1,index) = s;
        [ P_index ] = P_node(variable_names,domain_counts, index, dag,  X  );
        temp =1; 
        for l=1:child_num
            [ P_child] = P_node(variable_names,domain_counts,  children(l) , dag,    X );
            temp = temp * P_child;
        end
        prob(s) = P_index * temp;
    end
    prob = prob./sum(prob); 
    X(1,index) = sample_k(prob); 
    
    %% sample after t burn-in period with skip time k
    if i == burn_in+skip*times
        samples = [samples; X];
        times = times + 1; 
    end
    if size(samples, 1) == sample_num
        display('Samples are enough!')
        break
    end 
end

Infer = numel(find(samples(:,1) == 1))/ size(samples,1)
 
MAP_Infer = zeros(1,6);
for k =1:6
MAP_Infer(k) = numel(find(samples(:,2) == k))/ size(samples,1);
end
find(MAP_Infer == max(MAP_Infer))

   
    
