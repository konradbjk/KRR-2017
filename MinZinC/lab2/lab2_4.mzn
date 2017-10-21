%%%%%%%%%%%%%% 
% PARAMETERS        
int: n =  120;
set of int: range = 0..n-1;
array[0..n-1] of var range: magic;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Length of the sequence

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% 
% VARIABLES        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The sequence itself
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%%%%%%%%%%%%%
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
constraint forall(i in 0..n-1) 
(
    magic[i] = sum(j in range) (bool2int(magic[j] == i))
%  magic[i] = sum([bool2int(i == magic[j]) | j in range])
);
% Tips:                                 
% - sum(array) return sum of the array's elements 
% - you can use bool's like integers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
solve satisfy;
  
%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE OUTPUT   
%%%%%%%%%%%%%%%%%%%%%%%%
output [ "magic sequence = ", show(magic),";\n"];
