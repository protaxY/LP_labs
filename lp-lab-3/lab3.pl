% (27 mod 8) + 1 = 4

prolong([X|T], [Y,X|T]):- move(X,Y),
    not(member(Y,[X|T])). 

dfs(X,Y,P):- dfs1([X],Y,P).
dfs1([X|T],X,[X|T]).
dfs1(P,Y,R):- 
    prolong(P,P1),
    dfs1(P1,Y,R).

bfs(X,Y,P) :- bfs1([[X]],Y,P).
bfs1([[X|T]|_],X,[X|T]).
bfs1([P|Q1],X,R) :-
    findall(Z, prolong(P,Z),T),
    append(Q1,T,Q0),!,
    bfs1(Q0,X,R).
bfs1([_|T],Y,L) :- bfs(T,Y,L).

%dls(X,Y,P) :- dls1([[X]],Y,P).
dls(X,Y,P):- 
    int(D),
    dls(X,Y,P,D).
dls(X,Y,P,D):- dls1([X],Y,P,D).
int(1).
int(M):- 
    int(N),
    M is N+1.
dls1([Y|T],Y,[Y|T],0).
dls1(P,Y,R,D):- 
    D>0,
    prolong(P,P1),
    D1 is D-1,
    dls1(P1,Y,R,D1).

move(A,B):- move_lr(A,B).
move(A,B):- move_ud(A,B).

move_z(['_',X|T],[X,'_'|T]).
move_z([X,'_'|T],['_',X|T]).
move_z([X|T],[X|R]):- move_z(T,R).

move_lr([A|T],[B|T]):- move_z(A,B).
move_lr([A|T],[A|R]):- move_lr(T,R).

move_h(['_'|T],[A|R],[A|T],['_'|R]).
move_h([A|T],['_'|R],['_'|T],[A|R]).
move_h([X|T],[Y|R],[X|T1],[Y|R1]):- move_h(T,R,T1,R1).

move_ud([A,B],[A1,B1]):- move_h(A,B,A1,B1).

write_path([]).
write_path([[A,B]|T]):- 
    write(A), 
    nl(), 
    write(B), 
    write(','), 
    nl(), 
    nl(),
    write_path(T).

final([[_,_,'Ы'],[_,_,'Ф']]).

start([['П','h','Ф'],['h','_','Ы']]).
