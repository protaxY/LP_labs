% Task 2: Relational Data

% The line below imports the data
:- ['one.pl'].

:- include('four.pl').
%
getSubjectList(L):- findall(X,subject(X,_),L).

getListGrades(Subject,R):- findall(X,(subject(Subject,L), member(grade(_,X),L)), R).

getSum([H],H).
getSum([H|T],R):- getSum(T,N), R is H + N.

getAverageGrade(Subject,R):- 
    getListGrades(Subject,List),
    getSum(List,Sum),
    length(List,Size),
    R is Sum / Size.

getAllAverageGrades([]).
getAllAverageGrades([Head|Tail]):- getAverageGrade(Head,R), write(Head), write(' '), writeln(R), getAllAverageGrades(Tail).
task21:- getSubjectList(List), getAllAverageGrades(List).
%
getGroupList(L):- findall(X,group(X,_),L).

notPassedGroup(Group, R):- findall(X,(subject(_,L), member(grade(X,2),L), group(Group,N), member(X, N)),List), length(List,R).

getAllNotPassedGroup([]).
getAllNotPassedGroup([Head|Tail]):- notPassedGroup(Head,R), write(Head), write(' '), writeln(R), getAllNotPassedGroup(Tail).
task22:- getGroupList(List), getAllNotPassedGroup(List).
%
notPassedSubject(Subject, R):- findall(X,(subject(Subject,L), member(grade(X,2),L)), R).

getAllNotPassedSubject([]).
getAllNotPassedSubject([Head|Tail]):- notPassedSubject(Head,R), length(R,N), write(Head), write(' '), writeln(N), getAllNotPassedSubject(Tail).

task23:- getSubjectList(List), getAllNotPassedSubject(List).
%
