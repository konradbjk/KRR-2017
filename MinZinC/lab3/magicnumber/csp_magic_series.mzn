int: n = 94;
set of int: range = 0..n-1;
array[range] of var range: magic;
  
constraint forall(i in range)(
  magic[i] = sum([bool2int(i == magic[j]) | j in range])
);

% tutaj należy wstawić nadmiarowe ograniczenia

constraint 
  sum(magic) == n /\ 
  sum(i in range)(magic[i] * i) == n;

solve satisfy;
  
output [ "magiczny ciag = ", show(magic),";\n"];