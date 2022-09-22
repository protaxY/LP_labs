# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Федоров А. С.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |      5-       |

## Введение

В списках на prolog отсутствует явня работа с указателями. Поэтому, в отличии от традиционных языков, невозможны итераторы, однако, можно реализовать предикат, который будет его эмулировать. Как следствие отсутствия явонй работы с указателяим, списки в пологе не могут быть двунаправлеенными или замкнутыми. Доступ к элементам осуществляется рекурсивным вызовом предиката для этого же списка, но без головного элемента. Эта черта делает списки на прологе похожими на стек в традиционных императивных языках программирования. 

## Стандартные предикаты

`myLength`
Пример использования:
```prolog
?- myLength([1,2,3,4,5,6,7],X).
X = 7.
```
Реализация:
```prolog
myLength([], 0).
myLength([_|Tail], X):- myLength(Tail, Y), X is Y + 1. 
```

`myMember`
Пример использования:
```prolog
?- myMember(2,[1,2,3,4,5]).
true .

?- myMember(-3,[1,2,3,4,5]).
false.
```
Реализация:
```prolog
myMember(X, [X|_]).
myMember(X, [_|Tail]):- myMember(X, Tail).
```

`myAppend`
Пример использования:
```prolog
?- myAppend([1,2,4],[1,3],R).
R = [1, 2, 4, 1, 3].
```
Реализация:
```prolog
myAppend([], X, X).
myAppend([Head|Tail], X, [Head|Z]) :- myAppend(Tail, X, Z).
```

`myRemove`
Пример использования:
```prolog
?- myRemove([1,2,3,4,3,3],3,R).
R = [1, 2, 4, 3, 3] 
```
Реализация:
```prolog
myRemove([X|Tail], X, Tail).
myRemove([Head|Tail], X, [Head|Y]):- myRemove(Tail, X, Y).
```

`myPermute`
Пример использования:
```prolog
?- myPermute([1,2,3],R).
R = [1, 2, 3] ;
R = [1, 3, 2] ;
R = [2, 1, 3] ;
R = [2, 3, 1] ;
R = [3, 1, 2] ;
R = [3, 2, 1] ;
false.
```
Реализация:
```prolog
myPermute([], []).
myPermute(List, [Head|Tail]):- myRemove(List, Head, Y), myPermute(Y, Tail).
```

`mySublist`
Пример использования:
```prolog
?- mySublist([2,3],[1,2,3,4]).
true .

?- mySublist(X,[1,2,3,4]).
X = [] ;
X = [1] ;
X = [1, 2] ;
X = [1, 2, 3] ;
X = [1, 2, 3, 4] ;
X = [2] ;
X = [2, 3] ;
X = [2, 3, 4] ;
X = [3] ;
X = [3, 4] ;
X = [4] ;
false.
```
Реализация:
```prolog
mySublist([], _).
mySublist([X|Tail], [X|Y]):- myNext(Tail, Y).
mySublist([Head|Tail], [X|Y]):- mySublist([Head|Tail], Y), Head\=X.
myNext([], _).
myNext([Head|Tail], [Head|Y]):- myNext(Tail, Y).
```
## Задание 1.1: Предикат обработки списка

`myGetElem` - предикат находит элемент в списке по его номеру.

Примеры использования:

```prolog
?- myGetElem(3,[1,2,3,4,5],X).
X = 4 ;
false.

?- myGetElem(0,[1,2,3,4,5],X).
X = 1 ;
false.

?- myGetElem(10,[1,2,3,4,5],X).
false.

?- myGetElem(-2,[1,2,3,4,5],X).
false.

?- myGetElem(0,[],X).
false.
```

Реализация:

```prolog
myGetElem(0, [Head|_], Head).
myGetElem(N, [_|Tail], X):- R is N - 1, myGetElem(R, Tail, X).
```

Реализация со стандартными предикатами:

```prolog
getElem(N, List, H):- append(A,[H|_],List), length(A, N).
```

Предикат спускается в рекурсию, посотянно отделая голову списка и уменьшая индекс для поиска на единицу. Таким образом, найти элемент по номеру равносильно нахожению этого же элемента в списке без первого элемента и номером на единицу меньше. Условием остановки рекурсии является правило, что при номере равном нулю голова является ответом.

## Задание 1.2: Предикат обработки числового списка

`myMin` - предикат находит минимальный элемент списка.

Примеры использования:

```prolog
?- myMin([3,4,2,-1,0],X).
X = -1 ;
false.

?- myMin([],X).
false.

?- myMin([0,2,4,3],X).
X = 0 ;
false.
```

Реализация:

```prolog
myMin([Head|[]], Head).
myMin([Head|Tail], X):- myMin(Tail, Y), Head < Y, X = Head.
myMin([Head|Tail], X):- myMin(Tail, Y), Head >= Y, X = Y.
```
Предикат рекурсивно вызывает себя для хвоста. Если вернувшийся из рекрсии результат меньше, чем голова, то минимальный элемент переопределяется на результат из рекурсии, если нет, то минимальный элемент это и есть голова.

## Пример совместного использования предикатов 1.1 и 1.2
`myMinIndex` - предикат надодит номер минимального элемента.

Примеры использования:

```prolog
?- myMinIndex([4,2,1,3,4],X).
X = 2 ;
false.

?- myMinIndex([4,1,1,3,4],X).
X = 1 ;
X = 2 ;
false.

?- myMinIndex([-3,1,1,3,4],X).
X = 0 ;
false.
```

Реализация:

```prolog
myMinIndex(List, R):- myMin(List, Min), getElem(R, List, Min).
```

Предикат находит минимальный элемент (`myMin`) и находит для него номер (`getElem`), по его значению. Так как минимальных элементов может быть несколько, то и номеров для минимальных может быть несколько. Поэтому `myMinIndex` спсосбен выводить альтернативные решения.

## Задание 2: Реляционное представление данных
Тип представления данных: 4
Задание: 2

`task21` - предикат печатает средний балл для каждого предмета

```prolog
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
```

Предикат вызывает список предметов и с помощью рекурсивного обхода списка `getAllAverageGrades` вызывает `getAverageGrade` для каждого его элемента. `getAverageGrade` получает список оцнок по предмету (`getListGrades`), рекурсивно обходит этот список и подсчитывает сумму (`getSum`) и делит ее на размер списка из `getListGrades`.

`task22` - предикат для каждой группы печатает количество несдавших студентов

```prolog
getGroupList(L):- findall(X,group(X,_),L).

notPassedGroup(Group, R):- findall(X,(subject(_,L), member(grade(X,2),L), group(Group,N), member(X, N)),List), length(List,R).

getAllNotPassedGroup([]).
getAllNotPassedGroup([Head|Tail]):- notPassedGroup(Head,R), write(Head), write(' '), writeln(R), getAllNotPassedGroup(Tail).
task22:- getGroupList(List), getAllNotPassedGroup(List).
```

`task22` получает список групп (`getGroupList`) и обходит его (`getAllNotPassedGroup`), вызывая для каждого элемента `notPassedGroup`. Этот предикат находит все элементы из списка предиката `subject`, чьи оцнки равны два и выдает их список. Из полученного списка `getAllNotPassedGroup` печатает фамилии.

`task23` - предикат печатает количество не сдавших студентов для каждого из предметов.

```prolog
getSubjectList(L):- findall(X,subject(X,_),L).

notPassedSubject(Subject, R):- findall(X,(subject(Subject,L), member(grade(X,2),L)), R).

getAllNotPassedSubject([]).
getAllNotPassedSubject([Head|Tail]):- notPassedSubject(Head,R), length(R,N), write(Head), write(' '), writeln(N), getAllNotPassedSubject(Tail).

task23:- getSubjectList(List), getAllNotPassedSubject(List).
```

`task23` опять же вызывает `getSubjectList`, чтобы получить список предметов и затем вызывает для этого списка `getAllNotPassedSubject`. Он, в свою очередь, для каждого элемента списка вызвает `notPassedSubject` и печатает результат. `notPassedSubject` находит по предикату subject для данного предмета все элементы списка с оценкой 2. Результатом является длина этого списка.

## Выводы

Для выполнения лаборатороной работы я познакомился с реляционным представнением данных, в частности со списками в языке Prolog. Осутствие явной работы с памятью и указателями сначала показались мне страннми, но потом я понял, что для такого представления писать обработку легче. Также я познакомился с унификацией. Хоть она очень упрощает жизнь программисту, но значительно замедляет работу программы, особенно, когда нужно перебрать факты для целго множества аргументов предиката. Еще унификация позволяет решить разные задачи, в зависимости от унифицированных аргументов. Однако это работает не всегда, к примеру, невозможно построить список, зная только его минимальный аргумет (хотя можно попытаться перебать бескоенчное множество рещений)). Еще узнав о for в Prolog я задумался о сложностной оценке в декларативных языках программирования. Каждая простенькая для программиста программа, может заставлять компьютер перебирать огромоне число случаев, что может иметь смысл только если затраты на программистов несравнимо больше, чем стоимость вычислительных мощностей. 





