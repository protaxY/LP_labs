% Первая часть задания - предикаты работы со списками

% Ниже - пример кода, который вы можете удалить.

myAppend([], X, X).
myAppend([Head|Tail], X, [Head|Z]) :- myAppend(Tail, X, Z).

myRemove([X|Tail], X, Tail).
myRemove([Head|Tail], X, [Head|Y]):- myRemove(Tail, X, Y).

myPermute([], []).
myPermute(List, [Head|Tail]):- myRemove(List, Head, Y), myPermute(Y, Tail).
    
mySublist([], _).
mySublist([X|Tail], [X|Y]):- myNext(Tail, Y).
mySublist([Head|Tail], [X|Y]):- mySublist([Head|Tail], Y), Head\=X.
myNext([], _).
myNext([Head|Tail], [Head|Y]):- myNext(Tail, Y).

myGetElem(0, [Head|_], Head).
myGetElem(N, [_|Tail], X):- R is N - 1, myGetElem(R, Tail, X).

getElem(N, List, H):- append(A,[H|_],List), length(A, N).

myMin([Head|[]], Head).
myMin([Head|Tail], X):- myMin(Tail, Y), Head < Y, X = Head.
myMin([Head|Tail], X):- myMin(Tail, Y), Head >= Y, X = Y.

myMinIndex(List, R):- myMin(List, Min), getElem(R, List, Min).

