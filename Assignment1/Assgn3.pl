% This buffer is for notes you don't want to save.
% If you want to create a file, visit that file with C-x C-f,
% then enter the text in that file's own buffer.

:- dynamic group/2, subGroup/1, student/2, teacher/2,
	in_subgroup/2, has_members/2, slot/5	.
% has_members/Group,Subgroup, slot/Room,Teacher,Group,Subject,SlotNo
clear :-
	retractall(group(_,_)),
	retractall(subGroup(_)),
        retractall(student(_,_)),
	retractall(teacher(_,_)),
	retractall(in_subgroup(_,_)),
	retractall(has_members(_,_)).

aGroup(bsc4).
aGroup(bscCommon).
inGroup(bsc4, [hdComp,sdY4] ).
inGroup(bscCommon, [year1Games, year1Web,year1Software, year1Systems ]).

student_count(sdY4, 5).
student_count(hdComp, 12).
student_count(year1Games, 4).
student_count(year1Software, 8).
student_count(year1Web, 14).
student_count(year1Systems, 17).

ateacher(paul).
ateacher(una).

teaches(paul, ai, bsc4).
teaches(paul, game_design, bscCommon).
teaches(una, dotNet, bsc4).

membr_of(T, X , Z ):-
	teaches(T,_, X),
	has_members(X , Y ),
	has_members(Y , Z ).

room(b1041).
room(b2008).
room(a0006).
holds(b1041, 32).
holds(b2008, 32).
holds(a0006, 140).
type_room(b041, lab).

seed_all :-
	findall(X, (aGroup(X)) , L),
	findall(Y, (inGroup(_, Y)) , L2),
	assert_groups(L,L2),!,
	flatten(L2, L3),
	assert_sub_groups(L3),!,
	findall(Z, (ateacher(Z)) , L4),
	assert_teachers('I0000', 0, L4),
	findall(J, (student_count(J,_)) , L5),
	assaa(L5),!,
	enter_member_facts,!.

who(Lecturer, Studentlist) :-
	setof(Z, membr_of(Lecturer, _, Z) , L),
	flatten(L, Studentlist).

assert_groups([],[]).
assert_groups([H|T], [S|L2]) :-
	assert(group(H, S)),
	assert_groups(T, L2).

assert_sub_groups([]).
assert_sub_groups([H|T]) :-
	assert(subGroup(H)),
	assert_sub_groups(T).

assert_teachers(_,_,[]).
assert_teachers(Seed,N,[Y|L]) :-
	N1 is N + 1,
	atom_number(ID,N1),
	atom_concat(Seed,ID,LecturerID),
	assert(teacher(LecturerID, Y)),
	assert_teachers(Seed,N1, L ).

assaa([]).
assaa([H|L]) :-
	findall(X, (student_count(H,X)) , [Count|_]),
	assert_students('s000', H, Count),
	assaa(L).

assert_students(_,_,0).
assert_students(Seed, ClassGroup, N) :-
	get_student_id(Id),
	Oneup is Id + 1,
	atom_number(ID, Oneup),
	Next is N -1,
	atom_concat(Seed,ID,StudentID),
	atom_concat(student,ID,Name),
	assert(student(StudentID, Name)),
	add_student_to_subgroup(ClassGroup, StudentID),
	assert_students(Seed, ClassGroup, Next).

add_student_to_subgroup(ClassGroup, StudentID) :-
	findall(Z, in_subgroup(ClassGroup,Z), Oldlist),
	retractall(in_subgroup(ClassGroup, _)),
        flatten(Oldlist, NewOldList),
	append(NewOldList, [StudentID], Newlist),
	assert(in_subgroup(ClassGroup, Newlist)).


enter_member_facts :-
	findall(X, (teaches(_,_,X) ), L),
	do_subgroups(L).

do_subgroups([]).
do_subgroups([H|T]) :-
	bagof(Subg, (inGroup(H, Subg)), L),
	flatten(L, L1),
	assert_memberFacts(L1, H),
	do_students(L1),
	do_subgroups(T).

do_students([]).
do_students([H|T]) :-
	findall(Y, in_subgroup(H,Y), L),
	assert_memberFacts(L, H),
	do_students(T).

assert_memberFacts([], _).
assert_memberFacts([H|T], Grp) :-
	Clause =.. ['has_members'| [Grp, H ]],
	assert(Clause),
	assert_memberFacts(T, Grp).

%book_a_slot(b2008, paul, sdY4, ai, 2).
book_a_slot(Room, Teacher, Class, Subject, Slot) :-
	findall(X, slot(Room,_,_,_,X), L),
	( not(member(Slot, L))
	->
	(   students_in_class(Class, N),
	check_capacity(Room, N),
	assert(slot(Room,Teacher,Class,Subject,Slot)))
	;
	write('This slot is already booked!')).

students_in_class(Subgroup, N ):-
	in_subgroup(Subgroup, L),
	lngth(L,N).

check_capacity(Room, Studentcount ) :-
	holds(Room, X),
	Studentcount < X.

get_student_id(N) :-
	findall(X, student(X,_), L),
	lngth(L , N).

lngth([],0).
lngth([_|L],N) :-
	lngth(L,N1),
	N is N1 + 1.

flatten(X,[X]) :- \+ is_list(X).
flatten([],[]).
flatten([X|Xs],Zs) :-
	flatten(X,Y),
	flatten(Xs,Ys),
	append(Y,Ys,Zs).


