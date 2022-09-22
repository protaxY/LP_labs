:-include('out.pl').

prolong([X|T],[Y,X|T],Z):- move(X,Y,Z),
    not(member(Y,[X|T])). 

move(X,Y,'father'):- father(X,Y).
move(X,Y,'mother'):- mother(X,Y).
move(X,Y,'brother'):- brother(X,Y).
move(X,Y,'sister'):- sister(X,Y).
move(X,Y,'grandfather'):- grandfather(X,Y).
move(X,Y,'grandmother'):- grandmother(X,Y).
move(X,Y,'son'):- son(X,Y).
move(X,Y,'daughter'):- daughter(X,Y).

relative(X,Y,P):- dls(X,Y,P).
count_relative(X,R,C):- length(R,D),setof(Y,dls(Y,X,R,D),List),!,length(List,C).
count_relative(_,_,0).

dls(X,Y,P):- 
    between(1,30,D),
    dls(X,Y,P,D).
dls(X,Y,P,D):- dls1([X],Y,P,D).
int(1).
int(M):- 
    int(N),
    M is N+1.
dls1([Y|_],Y,[],0).
dls1(P,Y,[Z|R],D):- 
    D>0,
    prolong(P,P1,Z),
    D1 is D-1,
    dls1(P1,Y,R,D1).  

son(X,Y):- male(X),father(Y,X).
son(X,Y):- male(X),mother(Y,X).

daughter(X,Y):- female(X),father(Y,X).
daughter(X,Y):- female(X),mother(Y,X).

brother(X,Y):- X \== Y,father(Z,X),father(Z,Y),male(X).
brother(X,Y):- X \== Y,mother(Z,X),mother(Z,Y),male(X).

sister(X,Y):- X \== Y,father(Z,X),father(Z,Y),female(X).
sister(X,Y):- X \== Y,mother(Z,X),mother(Z,Y),female(X).

grandfather(X,Y):- father(X,Z),father(Z,Y).
grandfather(X,Y):- father(X,Z),mother(Z,Y).

grandmother(X,Y):- mother(X,Z),father(Z,Y).
grandmother(X,Y):- mother(X,Z),mother(Z,Y).

mother_in_law(R,X):- marriage(X,Y),mother(R,Y).
