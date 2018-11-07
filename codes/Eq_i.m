function [ results ] = Eq_i(total_num, dag, index, state, domain_counts, beta,variable_names  )
    % find all the parents
    results = 0;
    for m =   1: total_num  
        all_pa = find(dag(:,m)==1); 
        all_node = [all_pa;  m];
        [all_x] = list_all_x(index, state, all_node,domain_counts,[], []  ); 
        Eq = 0;   
        for i = 1: size(all_x,1) 
            X = all_x(i,:); 
            %% compute q  
            q_no_i = 1; 
            for n = 1: numel(all_node)
                if all_node(n) ~= index  && X(n) < domain_counts(all_node(n))
                   q_no_i = q_no_i * beta(all_node(n), X(n));
                elseif all_node(n) ~= index  && X(n) == domain_counts(all_node(n))
                   K = domain_counts(all_node(n))-1;
                   q_no_i = q_no_i * (1-sum(beta(all_node(n),1:K )));
                end 
            end
            %% Pm
            CPT = variable_names{1,m};
            Pa_num = sum(dag(:,m)); 
            if Pa_num == 0 
                prob = CPT;
            elseif Pa_num == 1 
                Pa_state = X(1);
                prob = CPT(:,Pa_state);
            elseif Pa_num == 2   
                Pa_state = ( X(1)-1)*(domain_counts(all_pa(2)) ) +  X(2);
                prob = CPT(:,Pa_state);
            end  
            Pm = prob(X(numel(X)));  
            if Pm ==0 
                break
            end
            Eq = Eq + log(Pm) * q_no_i; 
        end 
        results = results + Eq;
    end
end

