an_morf(L,morf(A,B,C,D)):-
    append(L1,L2,L),
    atomic_list_concat(L1, A1),
    an_prist(A1,A),
    an_end(L2,B,C,D).

an_end(L,A,B,C):- 
    append(L1,L2,L),
    atomic_list_concat(L1, A1),
    atomic_list_concat(L2, A2),
    an_kor(A1,A),
    an_okon(A2,B,C).

an_kor(X,kor(X)):- kor_list(L), member(X, L).
kor_list(['уч']).

an_okon(X,rod(A),chislo(B)):-
    check_male(X,A,B) -> true;
    check_female(X,A,B) -> true;
    check_middle(X,A,B) -> true;
    check_plural(X,A,B) -> true.

check_male(X,'муж','ед'):- okon_male_list(L), member(X,L), writef("aa").
okon_male_list(['ил']).

check_female(X,'жен','ед'):- okon_female_list(L), member(X,L).
okon_female_list(['ила']).

check_middle(X,'ср','ед'):- okon_middle_list(L), member(X,L).
okon_middle_list(['ило']).

check_plural(X,'-','мн'):- okon_plural_list(L), member(X,L).
okon_plural_list(['или']).

an_prist(X,prist(X)):- prist_list(L), member(X, L).
prist_list(['из','вы','об']).
