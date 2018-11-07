function [ P_index ] = P_node( variable_names, domain_counts,index, dag,   X  )
    CPT = variable_names{1,index};
    Pa_num = sum(dag(:,index)); 
    if Pa_num == 0 
        prob = CPT;
    elseif Pa_num == 1
        Pa = find(dag(:, index)==1);
        Pa_state = X(Pa);
        prob = CPT(:,Pa_state);
    elseif Pa_num == 2 
        all_pa = find(dag(:,index)==1);
        Pa1 = all_pa(1); Pa2 = all_pa(2);
        Pa_state = (X(Pa1)-1)*(domain_counts(Pa2) ) + X(Pa2);
        prob = CPT(:,Pa_state);
    end  
    P_index = prob(X(index));

end

