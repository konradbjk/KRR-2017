%%%%%%%%%%%%% 
% VARIABLES 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% add variables with correct domains 
% tip:                       
% var 1..N: x; declares a variable with domain 1..N   
int: N = 8; 
array[1..N] of var 1..N: x;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
%%%%%%%%%%%%%
% CONSTRAINTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% add constraints
% tip:
% row_i = row_j (-/+) (j - i)                 
% matches queens placed on the same diagonal, where:
% - i,j - column index
% - row_n - queen's position in the nth col 
constraint forall (i,j in 1..N where i<j) (x[i] != x[j]);
constraint forall (i,j in 1..N where i<j) (abs(x[i] - x[j]) != abs(j - i));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  
solve satisfy; 
  
%%%%%%%%%%%%%%%%%%%
% OUTPUT EXAMPLE  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% - rows[i] - queen's position in the ith row 
% - N - number of queens                     
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ if (fix(x[j]) == i) then "H" else "." endif ++
  if j == N then "\n" else "" endif | i,j in 1..N]
