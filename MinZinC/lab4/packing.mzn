include "diffn.mzn";
include "cumulative.mzn";

% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares
int: SQUARES_SUM = sum(SQUARES);
% Variables
%%%%%%%%%%%
var n..SQUARES_SUM: height;    % height of the container
var n..SQUARES_SUM: width;     % width of the conainer
var sum([i*i | i in SQUARES])..n*SQUARES_SUM: area = height * width; % container's area
array[SQUARES] of var 0..SQUARES_SUM-1: x; % squares' coordinates in the container
array[SQUARES] of var 0..SQUARES_SUM-1: y; % squares' coordinated in the container
  
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Constraint 1: Squares should fit inside the container
constraint forall(i in SQUARES)(
  x[i] + i <= width /\ y[i] + i <= height
);

% Constraint 2: Squares should not overlap
constraint forall(i, j in SQUARES where i < j)(
  x[i] + i <= x[j] \/ y[i] + i <= y[j] \/
  x[j] + j <= x[i] \/ y[j] + j <= y[i]
);

% Global constraint diifn
constraint diffn(x, y, SQUARES, SQUARES);

% Reduntant cumulative constraints
constraint cumulative(x, SQUARES, SQUARES, height);
constraint cumulative(y, SQUARES, SQUARES, width);

% Symmetry breaking
constraint height < width;

% Array [xn, yn, xn-1, yn-1, ...]
array[1..2*n] of var 0..SQUARES_SUM-1: sorted_coordinates = [
   if i mod 2 == 0 then
     y[n - (i div 2) + 1]
   else
      x[n - (i div 2)]
   endif
  | i in 1..2*n
];

% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve::seq_search([
  int_search([height, width], input_order, indomain_min, complete),
  int_search(sorted_coordinates, input_order, indomain_min, complete)
]) minimize area; 
  
% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)]