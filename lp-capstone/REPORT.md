# Отчет по курсовому проекту
## по курсу "Логическое программирование"

### студент: Федоров А.С.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |      5         |
| Левинская М.А.|              |               |

> *Парсер на F# (хотя в императивном стиле). Хорошая реализация 5 задания.*

## Введение

В ходе выполнения курсового проекта изучу синтаксис стандарта для обмена данными о генеалогических деревьях GEDCOM. Получу базовые знания синтаксиса языка F# и научусь писать простые парсеры на нем. Преобразую GEDCOM-файл в базу фактов для языка Prolog и использую на практике алгоритмы поиска в графе. Также получу навыки реализации естественно-языкового интерфейса на практике.

## Задание

 1. Создать родословное дерево своего рода на несколько поколений (3-4) назад в стандартном формате GEDCOM с использованием сервиса MyHeritage.com  
 2. Преобразовать файл в формате GEDCOM в набор утверждений на языке Prolog, используя следующее представление: ...
 3. Реализовать предикат проверки/поиска ....
 4. Реализовать программу на языке Prolog, которая позволит определять степень родства двух произвольных индивидуумов в дереве
 5. [На оценки хорошо и отлично] Реализовать естественно-языковый интерфейс к системе, позволяющий задавать вопросы относительно степеней родства, и получать осмысленные ответы.

## Получение родословного дерева

Для курсового проекта возьму уже готовое древо семейства Шекспиров с сайта `webtreeprint.com` в разделе `Famous GEDCOMs`. В дереве содержиться 30 человек и 4 поколения.

## Конвертация родословного дерева

Для конвертиации выбрал язык F#. Так как он изначально был разработан для удобной работы с базами данных. Стандарт GEDCOM является своего рода структурированием данных генеалогического дерева, поэтому считаю F# хорошим выбором.

Для распознавания слов использовал отдельную функцию `Len`. Данная функция устанавливает границы слова, считая разделяющим элементом пробел.

```F#
let mutable Pos=0 // начало слова
let mutable EPo=0 // конец слова
let Len() = // установить границы на слове
            let mutable ch=true
            while  EPo+2<String.length Pro && ch do
                    if Pro.[EPo+1]=' ' then ch<-false   
                    else EPo<-EPo+1
            if EPo+2=String.length Pro then EPo<-EPo+1
            EPo
```

Переход к следующему слову осуществляется сбросом границ прошлого слова и пропуском разделяющего пробела.

```f#
let Next() = Pos<-EPo+2;EPo<-Pos; // перейти к следующему слову
```

Для удобного хранения данных используя составной тип 'person'. Он хранит в себе имя и фамилию человека.

```F#
type person = // запись для члена семьи
        {name: string
         surname: string}
```

Для удобного хранения результатов парсинга использую стандартный контейнер `Map` и храню по ключу, которым является уникальный идентификатор из GEDCOM-файла, готовую строку с именем и фамилией.

```F#
let mutable family = Map.empty // мапа для всего древа
```

В мейне программа последовательно читает строки, пока не встретит терминирующую строку `0 TRLR`. Часть информации меня не интересует, программа реагирует только при встрече следующих слов:
 1. `GIVN` - программа запоминает следующее за 'GIVN' слово как имя.
 2. `SURN` - запоминает следующее за 'SURN' слово как фамилию.
 3. `SEX` - пишет в выходной файл предикат 'male' с текущими именем и фамилией, если следующим словом оказалось 'M', иначе 'female'.
 4. `FAM` - сброс переменных матери и отца, поднятие для записи предиката 'marriage'.
 5. `CHIL` - распознавание ребенка и печать предикатов 'father', если ключ отца не пустой и 'mother', если ключ матери не пустой. 

Затем передаю результат работы программы в скрипт на языке `bash`, который сортирует строки и выдает готовый список фактов.

```bash
#bin/bash

touch tmp.pl
cat shakespeare.ged | dotnet fsi fs_parsing.fsx | cat > tmp.pl
touch out.pl
sort -o out.pl tmp.pl
rm tmp.pl
```

Выходной список фактов содержит некоторые неточности. Так у людей с одинаковыми именами были заменены оные. Убраны все упоминания имени `Not Unknown`.

## Предикат поиска родственника

Изначально в базе, полученной при конвертации есть только 5 предикатов: `father`, `mother`, `male`, `female` и `marriage`. Допишу дополнительные предикаты для сына, дочери, брата, сестры, бабушки, дедушки и тещи реализую на основе имеющихся. Все предикаты отношения следует читать слева направо. То есть `son(X,Y)` значит: "X является сыном Y".

Сын - это можно сказать предикат `father` или `mother` наоборот плюс предикат мужского пола.

```prolog
son(X,Y):- male(X),father(Y,X).
son(X,Y):- male(X),mother(Y,X).
```

Аналогично сыну, но предикат `male` надо заменить на `female`.

```prolog
daughter(X,Y):- female(X),father(Y,X).
daughter(X,Y):- female(X),mother(Y,X).
```

Братья - люди, для которых в предикате `father` или `mother` первое поле одинаковое. Считаю, что сам себе человек не может быть братом, поэтому проверяю на неравенство поля. Так как отношение брата, то есть: "X является братом для Y.", то X должен быть мужского пола.

```prolog
brother(X,Y):- X \== Y,father(Z,X),father(Z,Y),male(X).
brother(X,Y):- X \== Y,mother(Z,X),mother(Z,Y),male(X).
```

Отношение сестры реализовано аналогично брату, только проверки пола изменена на женский.

```prolog
sister(X,Y):- X \== Y,father(Z,X),father(Z,Y),female(Y).
sister(X,Y):- X \== Y,mother(Z,X),mother(Z,Y),female(Y).
```

Отношение дедушки - это отец отца или отце матери. Так и пишу.

```prolog
grandfather(X,Y):- father(X,Z),father(Z,Y).
grandfather(X,Y):- father(X,Z),mother(Z,Y).
```

Бабушка аналогично: мать отца, мать матери.

```prolog
grandmother(X,Y):- mother(X,Z),father(Z,Y).
grandmother(X,Y):- mother(X,Z),mother(Z,Y).
```

Теща - мать жены. При парсинге определил, что на втором месте в предикате `marriage` стоит жена. Соответственно, реализация следующая:

```prolog
mother_in_law(X,R):- marriage(X,Y),mother(R,Y).
```

Протокол работы:
```prolog
?- mother_in_law(X, 'John Shakespeare').
X = 'Agnes Webbe'.

?- brother('William Shakespeare',X).
X = 'Anne Shakespeare' ;
X = 'Edmund Shakespeare' ;
X = 'Gilbert Shakespeare' ;
X = 'Joan Shakespeare' ;
X = 'Margaret Shakespeare'.

?- son('John Shakespeare', 'William Shakespeare').
false.

?- son('William Shakespeare', 'John Shakespeare').
true ;
false.

?- sister(X,'Hamnet Shakespeare').
X = 'Judith Shakespeare' ;
X = 'Susanna Shakespeare' ;
X = 'Judith Shakespeare' ;
X = 'Susanna Shakespeare' ;
false.
```

Предикаты могут давать одинаковые ответы, так как я нигде не ставил отсечение. Не делал этого для того, чтобы оставить универсальность применения. Такие предикаты можно использовать для поиска решения и для проверки утверждения.

## Определение степени родства

Для поиска использую метод с итерационными углублениями. Считаю его наиболее подходящим, так как он не требует памяти `O(n)`, где `n` - длина пути. И обладает временной сложностью `O(b\')`, где `b\'` - степень ветвления дерева. Ограничу глубину поиска до 30, так как в дереве больше нет человек. Оригинальный алгоритм заработал почти без изменений, только в виду ограничения глубины, не использую для ее генерации предикат 'int', а использую 'between'.

```prolog
relative(X,Y,P):- dls(X,Y,P).

dls(X,Y,P):-
    between(1,30,D),
    dls(X,Y,P,D).
dls(X,Y,P,D):- dls1([X],Y,P,D).
dls1([Y|_],Y,[],0).
dls1(P,Y,[Z|R],D):-
    D>0,
    prolong(P,P1,Z),
    D1 is D-1,
    dls1(P1,Y,R,D1).  
```

В качестве отношения родства будет возвращаться список . Поэтому предикаты `prolong` и `move` отличаются от стандартных. Теперь они добавляют в список отношения, а не имена. Выглядят это следущим образом:

```prolog
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
move(X,Y,'mother in law'):- mother_in_law(X,Y).
```

Протокол работы:

```prolog
?- relative('John Shakespeare', 'Susanna Shakespeare', X).
X = [grandfather] ;
X = [father, father] ;
X = [grandfather, brother] ;
X = [grandfather, brother] ;
X = [grandfather, sister] ;
X = [grandfather, sister] ;
X = [father, sister, father] .

?- relative('John Shakespeare', X, [father, father]).
X = 'Hamnet Shakespeare' ;
X = 'Judith Shakespeare' ;
X = 'Susanna Shakespeare' ;
false.

?- relative(X, 'John Shakespeare jr', [father]).
X = 'Richard Shakespeare' ;
false.
```

## Естественно-языковый интерфейс

Для разбора предложения использую GCD нотацию. Она значительно упрощает код и делает его более понятным. Всего программе можно задать 6 типов вопросов:
 1. `Is Peter brother of Mary?` - проверка отношения.
 ```prolog
 sentence --> auxiliary_verb,subject_phrase(Name1),relative_phrase(Rel),object_phrase(Name2),['?'],{relative(Name1,Name2,Rel),set_value(Name2),!}.
 ```
 2. `Whose brother is Peter?` - поиск людей с запрошенным отношением.
 ```prolog
 sentence --> question_word,relative_phrase(Rel),auxiliary_verb,subject_phrase(Name2),['?'],{relative(Name1,Name2,Rel),write(Name1),nl,set_value(Name2)}.
 ```
 3. `Who is brother of Mary?` - аналогично второму, но отношение перевернуто.
 ```prolog
 sentence --> question_word,auxiliary_verb,relative_phrase(Rel),object_phrase(Name1),['?'],{relative(Name1,Name2,Rel),write(Name2),nl,set_value(Name1)}.
 ```
 4. `How relate Peter and Mary?` - запрос отношения между людьми.
 ```prolog
 sentence --> question_word,verb_phrase,subject_phrase(Name1),[and],subject_phrase(Name2),['?'],{relative(Name1,Name2,Rel),write(Rel),nl,set_value(Name2)}.
 ```
 5. `Does Mary have 5 brothers?` - проверка количества людей, подпадающих под данное отношение.
 ```
 sentence --> auxiliary_verb,subject_phrase(Name1),verb_phrase,[Num],relative_phrase(Rel),['?'],{count_relative(Name1,Rel,Num),set_value(Name1),!}.
 ```
 6. `How many brothers does Mary` - запрос количества людей, подпадающих под данное отношение.
 ```prolog
 sentence --> question_word,relative_phrase(Rel),auxiliary_verb,subject_phrase(Name),verb_phrase,['?'],{count_relative(Name,Rel,Num),write(Num),nl,set_value(Name),!}.
 ```
 
 Для распознавания ключевой информации добавил поля для 'subject_phrase', 'object_phrase' и 'relative_phrase'.
 
 `subject_phrase'`- разделяется на артикль, набор прилагательных и имя. Набор прилагательных разбирается рекурсивным отделение от набора по-одному слову.
 
```prolog
subject_phrase(Name) --> det,adjective_phrase,noun(Name).

det --> [the].
det --> [a].
det --> [].

adjective_phrase --> [].
adjective_phrase --> adjective, adjective_phrase.

noun(Name) --> [his],{nb_getval(he,Name),!}.
noun(Name) --> [her],{nb_getval(she,Name),!}.
noun(Name) --> [Name].
```

`verb_phrase` - разделяется на набор наречий и глагол. Набор наречий обрабатывается аналогично набору прилагательных.

```
verb_phrase --> adverb_phrase,verb.

verb --> [relate].
verb --> [has].
verb --> [have].

adverb_phrase --> [].
adverb_phrase --> adverb, adverb_phrase.

adverb --> [probably].
adverb --> [].
```

`relative_phrase` - получает из предложения список отношений путем рекурсивного разбора части фразы.

```prolog
relative_phrase([Rel]) --> rel(Rel).
relative_phrase([Rel1|Rel2]) --> rel(Rel1),[of],relative_phrase(Rel2).
```

`object_phrase` - аналогичен `subject_phrase` но с приставокой "of" впереди.

```prolog
object_phrase(Name) --> [of],subject_phrase(Name).
```
Используя глобальные переменные для запоминания предыдущих имен. Для мужского и женского пола они разные. В переменных всегда будет храниться последнее упоминание, поэтому в случаях, когда в предложении два женских или мужских имени, запоминаться будут последние. При вводе нового вопроса переменная тоже перепишется, если найдет упоминание женского или мужского имени на вотрой позиции. После отработки каждого вопроса происходит переназначение гобальных переменных. За это отвечает предикат `set_value`. Работатет от следующим образом.

```prolog
:-nb_setval(he,nothing).
:-nb_setval(she,nohting).

set_value(Name):- male(Name),nb_setval(he,Name).
set_value(Name):- female(Name),nb_setval(she,Name).
```

Так как программа распознает небольшое количество вопросов, то оставлю возможность ввода грамматически неверного предложения, так как считаю, что это своего рода устойчивость программы к некорректному вводу. Конечно, можно было написать строгие правила, но основной задачей для выполнения в этом задании посчитал реализацию обобщенного разбора грамматики.

Протокол работы:

```prolog
?- sentence([does, 'Margaret Shakespeare', has, 2, sisters, ?],[]).
true.

?- sentence([how, many, sisters, does, 'Margaret Shakespeare', have, ?],[]).
2
true.

?- sentence([how, many, brothers, does, she, have, '?'],[]).
5
true.

?- sentence([how, relate, 'Margaret Shakespeare', and, 'William Shakespeare', ?],[]).
[sister]
true ;
[sister]
true ;
[sister,sister]
true ;
[sister,sister]
true ;
[sister,brother]
true ;
[sister,brother]
true .

?- sentence([who, is, brother, of, 'William Shakespeare', ?],[]).
Anne Shakespeare
true ;
Edmund Shakespeare
true ;
Gilbert Shakespeare
true ;
Joan Shakespeare
true ;
Margaret Shakespeare
true ;
Richard Shakespeare jr
true ;
Anne Shakespeare
true ;
Edmund Shakespeare
true ;
Gilbert Shakespeare
true ;
Joan Shakespeare
true ;
Margaret Shakespeare
true .

?- sentence([is, 'William Shakespeare', son, of, 'John Shakespeare', '?'],[]).
true.

?- sentence([is, 'William Shakespeare', brother, of, 'Richard Shakespeare jr', '?'],[]).
true.

?- sentence([is, 'William Shakespeare', brother, of, he, '?'],[]).
true.

?- sentence([whose, brother , is, 'William Shakespeare', '?'],[]).
Edmund Shakespeare
true ;
Gilbert Shakespeare
true ;
Richard Shakespeare jr
true ;
Edmund Shakespeare
true ;
Gilbert Shakespeare
true ;
Richard Shakespeare
true ;
false.
```

## Выводы

В ходе выполнения курсового проекта я применил на практике навыки, полученные в течении курса "Логическое программирование". В частности, использовал знания алгоритмов поиска в графе и описании правил перехода. Также применил на практике навыки обработки естественного языка на языке `Prolog`.

Получил базовые знания языка F#, изучил синтаксис стандарта GEDCOM, изучил некоторые новые возможности языка 'Prolog', в частности, узнал о поддержке GCD нотации.

В ходе работы над проектом задумался о базовых принципах работы информационных систем. Так как, по сути, курсовой проект - маленькая информационная система, где стоит задача работы с базой знаний. Сделал вывод, что логическое программирование - хороший инструмент для решения подобной проблемы. Очень понравилась простота и удобство работы с естественным языком на языке 'Prolog'. Поддержка DCG нотации значительно упрощает написание и понимание кода.



