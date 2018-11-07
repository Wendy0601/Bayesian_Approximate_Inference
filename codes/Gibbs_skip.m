clc; close all; clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Gibbs Sampling Method to compute P(X|E)
%% load datasets
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\parameter.mat');
load('E:\04_course\23_Probabilistic Graphical Models\Homework\Proj1\codes\structure.mat');
%% parameters 
total_num = 20;
unknown_num = 17;
times = 1;
unknown_ind = [1:14, 16:17, 20];
variable_names = {BirthAsphyxia, Disease, Age, LVH, DuctFlow, CardiacMixing, LungParench,...
    LungFlow, Sick, HypDistrib, HypoxiaInO2, CO2, ChestXray, Grunting, LVHreport, LowerBodyO2,...
    RUQO2, CO2Report, XrayReport, GruntingReport  }; 
%% changeble parameters
burn_in = 10000  ;
skip_time  =[1, 5,10,  50,100,200, 300, 400,500 ,600 ]  ;
sample_num = 20000 ; 
iter_num = 10000000;
set_samplenum = [2000,  50000, 500000]; 
Pl_inf = zeros(size(set_samplenum,2),size(skip_time,2) );
%% Five chains
X1 = zeros(1,total_num); 
X2 = zeros(1,total_num); 
X3 = zeros(1,total_num); 
X4 = zeros(1,total_num); 
X5 = zeros(1,total_num);  
%% initialize 
for k = 1: total_num
    X1(k) = randi(domain_counts(k));
    X2(k) = randi(domain_counts(k));
    X3(k) = randi(domain_counts(k));
    X4(k) = randi(domain_counts(k));
    X5(k) = randi(domain_counts(k));
end
X1(18) = 1; X1(15) = 1; X1(19) = 3; 
X2(18) = 1; X2(15) = 1; X2(19) = 3; 
X3(18) = 1; X3(15) = 1; X3(19) = 3; 
X4(18) = 1; X4(15) = 1; X4(19) = 3; 
X5(18) = 1; X5(15) = 1; X5(19) = 3; 
ini1 = X1; ini2 = X2; ini3 = X3;
ini4 = X4; ini5= X5;  
for s = 1: size(set_samplenum,2)
    sample_num = set_samplenum(s);
    for b = 1: size(skip_time,2)
    skip=skip_time(b);   
    samples1 = [];
    samples2 = [];
    samples3 = [];
    samples4 = [];
    samples5 = [];
    X1 = ini1; X2= ini2;X3= ini3;X4= ini4;X5= ini5; 
    times = 1;
    for i = 1:iter_num
        %% generate one sample
        [X1 ] = gener_sample(unknown_num,unknown_ind,variable_names,dag,X1); 
        [X2 ] = gener_sample(unknown_num,unknown_ind,variable_names,dag,X2); 
        [X3 ] = gener_sample(unknown_num,unknown_ind,variable_names,dag,X3); 
        [X4 ] = gener_sample(unknown_num,unknown_ind,variable_names,dag,X4); 
        [X5 ] = gener_sample(unknown_num,unknown_ind,variable_names,dag,X5);  
        %% sample after t burn-in period with skip time k
        if i == burn_in+skip*times
            samples1 = [samples1; X1];
            samples2 = [samples2; X2];
            samples3 = [samples3; X3];
            samples4 = [samples4; X4];
            samples5 = [samples5; X5];
            times = times + 1; 
            if size(samples1,1) >= sample_num
                    break
            end
        end 
    end  
    total_samples = [samples1; samples2; samples3; samples4; samples5]; 
    Infer = numel(find(total_samples(:,1) == 1))/ size(total_samples,1);
    Pl_inf(s,b) = Infer;
    display(['The inference is' num2str(Pl_inf(s,b )) ', when sample is ' num2str(skip)]);
    end 
end
         
plot(skip_time ,Pl_inf(1,:) ,'-*','lineWidth',2);
hold on; plot(skip_time ,Pl_inf(2,:) ,'-.','lineWidth',2);
plot(skip_time ,Pl_inf(3,:) ,'-o','lineWidth',2); 
legend('sample num is 5000', 'sample num is 50000','sample num is 100000')
xlabel('Skip_time')
ylabel('Inference Results') 
set(gca,'fontName', 'Times New Roman')
 
MAP_Infer = zeros(1,6);
for k =1:6
MAP_Infer(k) = numel(find(total_samples(:,2) == k))/ size(total_samples,1);
end
find(MAP_Infer == max(MAP_Infer))

   
 
