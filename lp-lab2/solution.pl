%вариант 27
%1 swimming
%2 cross
%3 fencing
%4 shooting
%5 horseback_riding

check('Ачкасов', A, B, C, D, E):- S is A + B + C + D + E, S == 24.
% check('Емельянов', _, _, _, 5, 3).
check('Колоколов', Y, X, X, X, X):- X =\= Y,!.
check('Колоколов', X, Y, X, X, X):- X =\= Y,!.
check('Колоколов', X, X, Y, X, X):- X =\= Y,!.
check('Колоколов', X, X, X, Y, X):-X =\= Y,!.
check('Колоколов', X, X, X, X, Y):-X =\= Y,!.

solve(D2):- 
    L =[5,4,3,2,1],
    permutation([5,4,3,2,1], [A1,A2,A3,A4,A5]),
    permutation([5,4,3,2,1], [B1,B2,B3,B4,B5]),
    permutation([5,4,3,2,1], [C1,C2,C3,C4,C5]),
    permutation([5,4,3,2,1], [D1,D2,D3,D4,5]),
    permutation([5,4,3,2,1], [E1,E2,E3,E4,3]),
    (A1+B1+C1+D1+E1) > (A2+B2+C2+D2+E2), (A2+B2+C2+D2+E2) > (A3+B3+C3+D3+E3), (A3+B3+C3+D3+E3) > (A4+B4+C4+D4+E4), (A4+B4+C4+D4+E4) > (A5+B5+C5+5+3),
    check('Колоколов', A3, B3, C3, D3, E3), check('Ачкасов', A1, B1, C1, D1, E1), !.
