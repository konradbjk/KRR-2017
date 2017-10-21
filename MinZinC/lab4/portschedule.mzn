int: nr; % machines' number
         % rails' number = nr for the A,B,C,D,E stages
         % rails' number = (nr + 1) div 2 for the stage F
set of int: RECLAIMER = 1..nr; % set of reclaiming machines (reclaiming machine loads coal on the ship, we don't care about machines stacking coal on the platform 
bool: stageF; % is it the F stage?

int: ns; % coal piles' number
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size of the coal pile (unit = 10000 t)
array[STOCKPILE] of SHIP: ship; % which ship should take te pile

constraint forall(sh in SHIP)
                 (assert(exists(s in STOCKPILE)(ship[s] = sh),
                 "Ship " ++ show(sh) ++ " has no cargo!")); % every ship should have a cargo!
 
int: maxtime; % the time bound
set of int: TIME = 0..maxtime;

int: nsh; % how many ships do we have 
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when the ship arrives

int: len; % how long is the platform
set of int: POSITION = 0..len;

int: stack_time; % time needed to stack a pile on the platform 
int: reclaim_time; % time needed to put a pile on the platform
int: reclaim_speed; %  how quickly does the reclaiming machine move

% west end of the pile on the platform 
array[STOCKPILE] of var POSITION: westend;
% east end of the pile on the platform 
array[STOCKPILE] of var POSITION: eastend;
% when the pile was started being stacked on the platform
array[STOCKPILE] of var TIME: stack;
% when stacking on the platform finished
array[STOCKPILE] of var TIME: endstack;
% when the pile was started being stacked on the ship 
array[STOCKPILE] of var TIME: reclaim;
% when stacking on the ship finished
array[STOCKPILE] of var TIME: finished;
% which machine was stacking a pile on a ship
array[STOCKPILE] of var RECLAIMER: which;

%%%%%%%%%%%%%
% stage A    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Every stack should be processed in a specific order within time limits
% + search annotation (see: goal definition)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Helpful structures :)
% total time needed to load a pile on the ship
array[STOCKPILE] of TIME: reclaim_duration = [size[s] * reclaim_time | s in STOCKPILE];
% total time needed to stack a pile on the platform
array[STOCKPILE] of TIME: stack_duration = [size[s] * stack_time | s in STOCKPILE];
% total time needed to process a pile
array[STOCKPILE] of var TIME: duration;

% Constraints
% 1) endstack = ?
% 2) finished = ?
% 3) duration = ?
% 4) what is the relation between westend, eastend and size?
% 5) what is the relation between reclaim and endstack?
% 6) rectangles defined by numbers:
%    x = westend
%    y = stackend
%    height = duration
%    width = size
%  should not overlap (diffn).
% 7) redundant cumulative constraints:
%  - coal stacking shouldn't use more platform than there is available
%  - coal loading shouldn't use more time than there is available
%
%%%%%%%%%%


%%%%%%%%%%%%%
% stage B    %
%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% One reclaimer machiner can't load two piles at the same time
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Your own predicate! Uncomment and complete
% predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2)
% says that loading s1 on ship ends before loading s2 (or s2 ends before s1)

% Constraints
% 1) for every two different piles, 
%    if they are processed by the same machine
%    the loading can't overlap (predicate not_overlap)
% 2) use cumulative constraint, so there shouldn't work more machines
%    than there is available 


%%%%%%%%%%%%%%
% stage C    %
%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Every pile has to be loaded on the correct ship
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Constraints
% 1) loading coal can start only when stacking is done and aslo ship is in the port
% 2) if two pile are meant to be loaded on the same ship, 
%     their loading can't overlap (not_overlap)



%%%%%%%%%%%%%%
% stage D    %
%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The reclaiming machines move with a finite speed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% You have to rewrite the not_overlap to consider time needed for the machine
% to move from one pile to another (distance = abs(westend[s1] - westend[s2]).
% I recommend using local variables ( let {... } in - check the cheatsheet)


%%%%%%%%%%%%%%
% stage E    %
%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%
% Change the goal definition to minimize the total time spent by the ships in the port 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% when the last pile for the ship was loaded on the ship
array[SHIP] of var TIME: last_finish;

% how long was the ship waiting in the port
array[SHIP] of var TIME: ship_waited;

% Constraints
% 1) last finish = ?
% 2) ship_waited = ?

%%%%%%%%%%%%%%%%%%%%%%%
% stage F (bonus million points)   
%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reclaimers can't  pass each other if they wokr on the same rail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This is a bonus, no help here :)

%%%%%%%%%%%%%%%
% Search (Stage A)
% We want first to set values of westend and stack for the biggest piles
% 1) create an array sorted_westend with wested variables sorted according to the pile size
% 2) create an analogous sorted_stack array
% 3) create a search_order array, wich contents
%    [sorted_westend[1], sorted_stack[1], sorted_westend[2], sorted_westend[3]]
% 4) use search anntotation ::int_search(search_order, input_order, indomain_min, complete)
%%%%%%%%

% Goal (Stage E)
% Change goal to minimize the time ships spend in the port
%%%%%%
solve satisfy;

%output for submission
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"]
;

%output for solution visualization
%warning: this is an experimental feature.  Feedback and suggestions are encouraged.

% include "portschedule_viz.mzn";
% output [portschedule_viz(westend,eastend,stack,endstack,reclaim,finished,which)];
