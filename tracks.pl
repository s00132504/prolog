% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

:- dynamic userer/1, song/1, likeses/2.

clear :-
	retractall(userer(_)),
	retractall(song(_)),
	retractall(likeses(_,_)).

%user(larry).
%user(mo).
%user(curly).
%likes(larry, [s1,s2,s3,s4,s5,s6,s7]).
%likes(mo,    [s1,s2,s3,s24,s25,s26,s27]).
%likes(curly, [s1,s2,s3,s4,s5,s6,s27]).

assa(Users, L) :-
	clear,
	assa_users(Users),
	same_taste(L).

assa_users([]).
assa_users([[H|[M]]|T]) :-
	assert(userer(H)),

	assert(likeses(H, M)),
	assa_users(T).

asa :-
	findall(X, (user(X)) ,Lst),
	ass_users(Lst).


same_taste(L) :-
	findall(X, (likeses(X, Trks),checkk(L, Trks)) ,Lst),
	write(Lst).

checkk(L, L1) :-
	inter(L, L1, Rl),
	length(Rl, Rlc),
	Rlc > 1, !.

lngth([],0).
lngth([_|L],N) :-
	lngth(L,N1),
	N is N1 + 1,!.


ass_users([]).
ass_users([H|T]) :-
	assert(userer(H)),
	setof(X, (likes(H, X)) , L),
	flatten(L, L1),
	assert(likeses(H, L1)),
	ass_users(T).

flatten(X,[X]) :- not(is_list(X)).
flatten([],[]).
flatten([X|Xs],Zs) :-
	flatten(X,Y),
	flatten(Xs,Ys),
	append(Y,Ys,Zs).


inter([], _, []).

inter([H1|T1], L2, [H1|Res]) :-
    member(H1, L2),
    inter(T1, L2, Res).

inter([_|T1], L2, Res) :-
    inter(T1, L2, Res).

test(X):-
        inter([1,3,5,2,4], [6,1,2], X), !.

%test(X).
%X = [1, 2].
