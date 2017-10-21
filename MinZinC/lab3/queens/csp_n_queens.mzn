include "alldifferent.mzn";
include "inverse.mzn";

int: N = 16;
set of int: indexes = 1..N;

array[indexes] of var indexes: rows;

array[indexes] of var indexes: columns;

constraint alldifferent(rows);
constraint alldifferent([rows[i] + i | i in indexes]);
constraint alldifferent([rows[i] - i | i in indexes]);

constraint alldifferent(columns);
constraint alldifferent([columns[i] + i | i in indexes]);
constraint alldifferent([columns[i] - i | i in indexes]);

constraint inverse(rows, columns);

%solve :: int_search(rows, input_order, indomain_min, complete) satisfy; %41 msec
%solve :: int_search(rows, input_order, indomain_median, complete);
%int_search(rows, first_fail, indomain_min, complete);
%int_search(rows, first_fail, indomain_median, complete);

solve satisfy; 
  
output [ if fix(rows[j]) == i then "Q" else "_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N]