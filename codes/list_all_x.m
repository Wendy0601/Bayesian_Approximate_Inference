function [all_x] = list_all_x( index, state, all_pa,domain_counts,sample, all_x )
    if size(sample,2 ) == numel(all_pa)
        all_x =[all_x; sample] ;  
        return
    end
    domain_counts(index) = 1;
    domain_counts(15) = 1;
    domain_counts(18) = 1;
    domain_counts(19) = 1;
    for j=1:domain_counts(all_pa(size(sample,2)+1)) 
            if all_pa(size(sample,2)+1) == 15 || all_pa(size(sample,2)+1) == 18
                sample = [sample 1]; 
            elseif all_pa(size(sample,2)+1) == 19 
                sample = [sample 3]; 
            elseif all_pa(size(sample,2)+1) == index 
                sample = [sample state]; 
            else
                sample = [sample j]; 
            end 
            if size(sample,2 ) <= numel(all_pa)
                [all_x] = list_all_x(index, state, all_pa,domain_counts,sample, all_x );
                sample(end) = [];
            end 
    end 
end

