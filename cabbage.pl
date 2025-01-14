% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

run :- solve([e,e,e,e], [w,w,w,w]).

solve(StartState, GoalState) :-
      move(StartState, NextState),
      safe(NextState),
      solve(NextState, GoalState).
solve(GoalState, GoalState).

move([X,X,G,C], [Y,Y,G,C]) :- opposite(X,Y).
move([X,W,X,C], [Y,W,Y,C]) :- opposite(X,Y).
move([X,W,G,X], [Y,W,G,Y]) :- opposite(X,Y).
move([X,W,G,C], [Y,W,G,C]) :- opposite(X,Y).

opposite(e,w).
opposite(w,e).

safe([F,W,G,C]) :- cabb_safe(F,W,G,C), goat_safe(F,W,G,C).

cabb_safe(B,X,Y,B).
cabb_safe(X,Y,G,C) :- opposite(G,C).

goat_safe(B,X,B,Y).
goat_safe(X,W,G,Y) :- opposite(W,G).
