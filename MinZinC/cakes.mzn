include "cakes.dzn";

% parameters
int: flour;
int: bananas;
int: cocoa;
int: sugar;

% Production costs
int: pFlour;
int: pBananas;
int: pCocoa;
int: pSugar;


% variables
var 0..100:A; % Banana cakes
var 0..100:B; % Cocoa cakes

% Receipt
constraint 
  100*A + 150*B <= flour /\ 
  200*A + 100*B <= sugar /\
  2* A <= bananas /\
  300*B <= cocoa;

% fixed costs  
var int: cFlour= (100*A + 150*B) * pFlour;
var int: cSugar= (200*A + 100*B) *pSugar;
var int: cBananas=2*A*pBananas;
var int: cCocoa=300*B*pCocoa;

% goal
solve maximize 30000*A+35000*B-cFlour- cSugar- cBananas-cCocoa;

% Output
output [
  "no. of banana cakes: ",show(A),"\n",
  "no. of cocoa cakes: ",show(B),"\n",
  "Gain: ", show(30000*A+35000*B-cFlour- cSugar- cBananas-cCocoa)
];
