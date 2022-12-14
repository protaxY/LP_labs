#№ Отчет по лабораторной работе №2
## по курсу "Логическое программирование"

## Решение логических задач

### студент: Федоров А. С.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |     4         |

## Введение

  Существует несколько подходов к решению задач на Prolog: построение таблицы истинности, рассуждения и логика высказываний.
  Построение таблицы истинности - это ничто иное, как перебор всех возможных значений. Подставляя их в заранее подготовленные высказывания, получаем ложный или истинный вывод, для всех возможных комбинаций значений. Подобный перебор не очень эффективен по времени, но его можно ускорить, заранее указав точно неверные или бессмысленные комбинации, тем самым сократить область поиска ответа.
  Метод рассуждений подразумевает получение ответа из исходного набора утверждений. Здесь явно не используются элементы алгебры логики. Это скорее похоже на рассуждение на пальцах на манер: "Если это, то вот это и т.д".
  Логика высказываний сопоставляет задаче формулы алгебры логики. Их можно связать и в конечном итоге построить по ним таблицу истинности.
  Так как Prolog построен на ограниченной логике предикатов и условие задачи в нем задается набором правил, то на него хорошо ложатся все три метода решения логических задач. В конечном итоге все сводится к явному (для таблиц истинности) или неявному (как в метода рассуждений) перебору. Однако, Prolog также предоставляет не логические инструменты, такие как отсечение, что позволяет строить более сложные условия. Таким образом можно описать большой класс логических задач.

## Задание

Вариант 27

  Тренер команды пятиборцев решил устроить для своих воспитанников отборочные соревнования. В программу состязаний он включил все пять видов спорта: плавание, кросс, фехтование, стрельбу и верховую езду. В итоге соревнований по сумме набранных баллов на первое место вышел Ачкасов, затем шли Боровский, Колоколов, Дикушин и на последнем месте оказался Емельянов. Система оценки результатов была такая: занявший первое место в состязании по тому или другому виду спорта получал 5 баллов, следующий за ним 4 балла и т.д. Ачкасов закончил соревнования, набрав 24 балла. Колоколов получил по четырем видам спорта одинаковые баллы. Емельянов завоевал первенство в соревнованиях по стрельбе, а по верховой езде вышел на третье место. Какое место на соревнованиях по стрельбе занял Боровский?

## Принцип решения

  Помимо информации о распределении мест между участниками, в условии указано еще три факта.
"Ачкасов закончил соревнования, набрав 24 балла." Формализую это условие в Prolog в таокм виде:
```prolog
check('Ачкасов', A, B, C, D, E):- S is A + B + C + D + E, S == 24.
```
  Реализация "Колоколов получил по четырем видам спорта одинаковые баллы.":
```prolog
check('Колоколов', Y, X, X, X, X):- X =\= Y,!.
check('Колоколов', X, Y, X, X, X):- X =\= Y,!.
check('Колоколов', X, X, Y, X, X):- X =\= Y,!.
check('Колоколов', X, X, X, Y, X):- X =\= Y,!.
check('Колоколов', X, X, X, X, Y):- X =\= Y,!.
```
  Реализация "Емельянов завоевал первенство в соревнованиях по стрельбе, а по верховой езде вышел на третье место." Однако, не вижу смысла добавлять это в программу, так как это можно учесть во время перебора, тем самым уменьшив время работы.
```prolog
check('Емельянов', _, _, _, 5, 3).
```
Для нахождения ответа программа перебирает все возможные результаты для пяти состязаний.
```prolog
L =[5,4,3,2,1],
    permutation([5,4,3,2,1], [A1,A2,A3,A4,A5]),
    permutation([5,4,3,2,1], [B1,B2,B3,B4,B5]),
    permutation([5,4,3,2,1], [C1,C2,C3,C4,C5]),
    %Емельянов завоевал первенство в соревнованиях по стрельбе,
    permutation([5,4,3,2,1], [D1,D2,D3,D4,5]),
    %а по верховой езде вышел на третье место.
    permutation([5,4,3,2,1], [E1,E2,E3,E4,3]),
```
Для всех перестановок проверяет три вышеописанных предиката и сравнивает суммы баллов для всех участников
```prolog
(A1+B1+C1+D1+E1) > (A2+B2+C2+D2+E2), (A2+B2+C2+D2+E2) > (A3+B3+C3+D3+E3), (A3+B3+C3+D3+E3) > (A4+B4+C4+D4+E4), (A4+B4+C4+D4+E4) > (A5+B5+C5+5+3),
```

Поиск ответа инициализируется вызовом предиката `solve(X).`

Ответ на `solve(X)` - `X=1` баллов, значит и изначальная программа в процессе перебора дойдет до правильного ответа, но это займет больше времени. Так как Боровский получил за стрельбу всего 1 балл, в этом соревновании он занял последнее место.

## Выводы

Я составил программу для решения логической задачи на языке Prolog. Так как программа перебирает конечное число вариантов (примерно 2.5*10^10), то она рано или поздно найдет верный ответ. Сложность перебора `O(n!^m)`, где `n` - число участников, а `m` - число видов спорта, в сложности перебора не учтены две фиксированные переменные, которые были взяты из факта "Емельянов завоевал первенство в соревнованиях по стрельбе, а по верховой езде вышел на третье место." Их фиксация уменьшит время работы двух из пяти `permutation` с 5! до 4!. Для поиска ответа я сначала использовал 25 циклов for от 0 до 5, но потом понял, что количество перебираемых вариантов слишком велико. Поэтому вместо этого я использовал permutation для подбора вариантов для каждого из соревнований, тем самым не рассматривая массу вариантов с повторяющимися баллами (например, за плаванье все получили по пять баллов и тому подобные бессмысленные варианты). Долгий перебор такого большого количества вариантов заставил меня задуматься о возможном распараллеливании программы для более эффективной работы. На ум сразу приходит костыльный метод: просто разбить на части общий список возможных вариантов перебора и дать по части каждой из программ, запущенных одновременно. Работа показала мне, что отсекая заранее неверные варианты, можно добиться значительного ускорения работы программы.
