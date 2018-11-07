function [X ] = gener_sample(domain_counts,unknown_num,unknown_ind,variable_names,dag,X)
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

end 

