% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

max(X,Y,Z) :-
    (  X =< Y
    -> Z = Y
    ;  ( Z = X,
       T is Z +1,
       write(T))
     ).
