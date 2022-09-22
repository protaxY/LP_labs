:-include('task3,4.pl').

:-nb_setval(he,nothing).
:-nb_setval(she,nohting).

% Is Peter brother of Mary?
sentence --> auxiliary_verb,subject_phrase(Name1),relative_phrase(Rel),object_phrase(Name2),['?'],{relative(Name1,Name2,Rel),set_value(Name2),!}.

% Whose brother is Peter?
sentence --> question_word,relative_phrase(Rel),auxiliary_verb,subject_phrase(Name2),['?'],{relative(Name1,Name2,Rel),write(Name1),nl,set_value(Name2)}.

% Who is brother of Mary?
sentence --> question_word,auxiliary_verb,relative_phrase(Rel),object_phrase(Name1),['?'],{relative(Name1,Name2,Rel),write(Name2),nl,set_value(Name1)}.

% How relate Peter and Mary?
sentence --> question_word,verb_phrase,subject_phrase(Name1),[and],subject_phrase(Name2),['?'],{relative(Name1,Name2,Rel),write(Rel),nl,set_value(Name2)}.

% Does Mary have 5 brothers?
sentence --> auxiliary_verb,subject_phrase(Name1),verb_phrase,[Num],relative_phrase(Rel),['?'],{count_relative(Name1,Rel,Num),set_value(Name1),!}.

% How many brothers does Mary have?
sentence --> question_word,relative_phrase(Rel),auxiliary_verb,subject_phrase(Name),verb_phrase,['?'],{count_relative(Name,Rel,Num),write(Num),nl,set_value(Name),!}.


subject_phrase(Name) --> det,adjective_phrase,noun(Name).

verb_phrase --> adverb_phrase,verb.

relative_phrase([Rel]) --> rel(Rel).
relative_phrase([Rel1|Rel2]) --> rel(Rel1),[of],relative_phrase(Rel2).

object_phrase(Name) --> [of],subject_phrase(Name).

set_value(Name):- male(Name),nb_setval(he,Name).
set_value(Name):- female(Name),nb_setval(she,Name).

rel(father) --> [fathers],!.
rel(mother) --> [mothers],!.
rel(brother) --> [brothers],!.
rel(sister) --> [sisters],!.
rel(grandfather) --> [grandfathers],!.
rel(grandmother) --> [grandmothers],!.
rel(son) --> [sons],!.
rel(daughter) --> [daughters],!.
rel(Name) --> [Name].

noun(Name) --> [he],{nb_getval(he,Name),!}. 
noun(Name) --> [she],{nb_getval(she,Name),!}. 
noun(Name) --> [Name].

det --> [].
det --> [the].
det --> [a].

adjective_phrase --> [].
adjective_phrase --> adjective, adjective_phrase.

adjective --> [little].
adjective --> [old].
adjective --> [magnificent].

auxiliary_verb --> [is].
auxiliary_verb --> [are].
auxiliary_verb --> [does].

question_word --> [whose].
question_word --> [who].
question_word --> [how].
question_word --> [how,many].

verb --> [relate].
verb --> [has].
verb --> [have].

adverb_phrase --> [].
adverb_phrase --> adverb, adverb_phrase.

adverb --> [probably].
