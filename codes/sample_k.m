function x = sample_k(prob)
% the prob should include all k possiblity of x 
	u = rand;  
	prob0 = [0; prob]; 
	for i = 1:numel(prob0)  
	   if sum(prob0(1:i )) > u 
			x = i-1 ; 
			break
	   end 
	end
end
