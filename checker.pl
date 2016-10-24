% GrammarChecker.pl
/*

-------------- One concret sentences example ---------------------------

1. XX eat food:

Plural:
	We/They/People/Dogs/A group of students

	(same as singular):
	ate/didn't eat/will(not) eat/would(not) eat/can(not) eat/
	could(not) eat/may(not) eat/might(not) eat/
	shall(not) eat/should(not) eat

	(different from singular):
	(don't) eat/were (not) eating/are (not)eating/
	are (not) going to eat/are (not) gonna eat/
	were(not/about) to eat/are(not/about) to eat/
	have (not) eaten/have (not)been eating

First Person Singular:

	I

	Everything is the same except for:
	am(not) eating/am going to eat/am gonna eat/am to eat/was(not) eating

Third Person Singular:

	She/He/It/A person/Nancy/My dad
	eats/ate/will eat/would eat/was eating/is eating/is going to eat/is gonna eat/
	food.

	(different from plural):
	is(not) eating/is(not) to eat/is(not) going to eat/is(not) gonna eat/
	was(not/about) to eat/was(not) going to eat/was(not) gonna eat/was(not) eating
	has(not) eaten/has(not) been eating/

	(some are the same as plural, see above)

------------------------ Other more complicated examples -------------

It doesn't go through.
I like eating.
I like eating chocolates.
I like eating that kind of chocolates.
I like eating chocolates that my mom bought me.

-----------------------------other linguistic facts -----------------------------------

noun:
pronoun: we(us), I(me), they(them), she(her)....
proper nouns: Kevin, Kevin and Victoria, UBC, Google.....
things: pencil(s), water, a school of fish, brother, her heart...

verb:
auxilary: do, has, shall, can, would....
regular: sing, tends to, played with....

For singular, countable nouns, you have to have determinaters

The table is tall.  ----> yes
Table is tall.  ------> no
Let's find a table. -----> yes
Let's find table. ----> no

*/

:- discontiguous aux_verb/4.


% sentence[]
sentence(T0, T2, Person):-
	noun_phrase(T0, T1, Person),
	verb_phrase(T1, T2, Person).



% A noun phrase is an optional determiner followed by
% an optional adjective followed by a simple noun
noun_phrase(T0,T4, Person) :-
	det(T0,T1),
	adjectives(T1, T2),
    noun(T2,T4, Person).

% Alternatively, a proper noun is a noun phrase
noun_phrase(T0, T1, Person) :-
	proper_noun(T0, T1, Person).

% Also, a pronoun is a noun phrase
noun_phrase(T0, T1, Person) :-
	pronoun(T0, T1, Person).



% Verb phrases could either be just a verb...
verb_phrase(T0,T1, Person):-
	verb(T0,T1, Person, _).

% ...or a verb followed by a noun phrase.
verb_phrase(T0,T2, Person):-
	verb(T0,T1, Person, _),
	noun_phrase(T1, T2, _).


% Determiners (articles) are ignored in this oversimplified example.
% They do not provide any extra constraints.
det([the | T],T).
det([a | T],T).
det([an| T], T).
det(T,T,_).

% preposition phrase (keep it simple for now):
% e.g. I want the bag [in the fridge]. She didn't bring me [with her].
prep_phrase(T, T).
prep_phrase(T0, T2):-
	prep(T0, T1),
	noun_phrase(T1, T2, _).



% Adjectives consist of a sequence of adjectives.
% The meaning of the arguments is the same as for noun_phrase
adjectives(T0,T2) :-
    adj(T0,T1),
    adjectives(T1,T2).
adjectives(T,T).

% An optional modifying phrase / relative clause is either
% a relation (verb or preposition) followed by a noun_phrase or
% 'that' followed by a relation then a noun_phrase or
% nothing

mp(T0,T1, _) :-
    prep_phrase(T0,T1).
mp([that|T0],T1,Person) :-
    verb_phrase(T0,T1,Person).
mp([that|T0],T1, _) :-
    sentence(T0,T1, _).
mp([who|T0],T1,Person) :-
    verb_phrase(T0,T1,Person).
mp([which|T0],T1,Person) :-
    verb_phrase(T0,T1,Person).
mp([whose|T0],T2,Person) :-
	noun(T0,T1, Person),
    verb_phrase(T1,T2,Person).
mp(T,T,_).


noun(T0, T1, Person):- pronoun(T0, T1, Person).
noun(T0, T1, Person):- proper_noun(T0,T1, Person).
noun(T0, T1, Person):- thing(T0,T1, Person).



verb(T0, T1, Person, _):- 
	reg_verb(T0, T1, Person, Tense),
	\+ Tense = pp.
verb(T0, T2, Person, _):- 
	aux_verb(T0, T1, Person, Tense),
	reg_verb(T1, T2, _, Tense).


%Dictionary

% ----------------- auxilary verbs -------------


% pre: present -> so that the verb should be regular form: draw

aux_verb([can| T], T, _, pre).
aux_verb([cannot| T], T, _, pre).
aux_verb([could| T], T, _, pre).
aux_verb([could, not| T], T, _, pre).
aux_verb([will| T], T, _, pre).
aux_verb([will, not| T], T, _, pre).
aux_verb([would| T], T, _, pre).
aux_verb([would, not| T], T, _, pre).
aux_verb([may| T], T, _, pre).
aux_verb([may, not| T], T, _, pre).
aux_verb([might| T], T, _, pre).
aux_verb([might, not| T], T, _, pre).
aux_verb([do| T], T, P, pre):- P = i; P = p. % I do think it's nice.
aux_verb([do, not| T], T, P, pre):- P = i; P = p.
aux_verb([did| T], T, _, pre).
aux_verb([did, not| T], T, _, pre).
aux_verb([shall| T], T, _, pre).
aux_verb([shall, not| T], T, _, pre).
aux_verb([should| T], T, _, pre).
aux_verb([should, not| T], T, _, pre).
aux_verb([ought, to| T], T, _, pre).
aux_verb([ought, not, to| T], T, _, pre).
aux_verb([must| T], T, _, pre).
aux_verb([must, not| T], T, _, pre).
aux_verb([dare, to| T], T, _, pre).
aux_verb([dare, not, to| T], T, _, pre).

aux_verb([are, to| T], T, p, pre).
aux_verb([are, not, to| T], T, p, pre).
aux_verb([is, to| T], T, s, pre).
aux_verb([is, not, to| T], T, p, pre).
aux_verb([were, to| T], T, p, pre).
aux_verb([were, not, to| T], T, p, pre).
aux_verb([was, to| T], T, P, pre):- P = i; P = s.
aux_verb([was, not, to| T], T, P, pre):- P = i; P = s.

aux_verb([am, going, to| T], T, i, pre).
aux_verb([am, gonna| T], T, i, pre).
aux_verb([am, not, going, to| T], T, i, pre).
aux_verb([am, not, gonna| T], T, i, pre).
aux_verb([are, going, to| T], T, p, pre).
aux_verb([are, gonna| T], T, p, pre).
aux_verb([are, not, going, to| T], T, p, pre).
aux_verb([are, not, gonna| T], T, p, pre).
aux_verb([is, going, to| T], T, s, pre).
aux_verb([is, gonna| T], T, s, pre).
aux_verb([is, not, going, to| T], T, s, pre).
aux_verb([is, not, gonna| T], T, s, pre).


aux_verb([was, going, to| T], T, i, pre).
aux_verb([was, gonna| T], T, i, pre).
aux_verb([was, not, going, to| T], T, i, pre).
aux_verb([was, not, gonna| T], T, i, pre).
aux_verb([were, going, to| T], T, p, pre).
aux_verb([were, gonna| T], T, p, pre).
aux_verb([were, not, going, to| T], T, p, pre).
aux_verb([were, not, gonna| T], T, p, pre).
aux_verb([was, going, to| T], T, s, pre).
aux_verb([was, gonna| T], T, s, pre).
aux_verb([was, not, going, to| T], T, s, pre).
aux_verb([was, not, gonna| T], T, s, pre).


% cont: continuous form -> drawing
% pp: past participle -> used for passive voice or perfect tense

% I was attracted to the music.
% The music has attracted the crowd.

aux_verb([are| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([are, not| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([are, being| T], T, p, pp).
aux_verb([are, not, being| T], T, p, pp).
aux_verb([is| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([is, not| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([is, being| T], T, s, pp).
aux_verb([is, not, being| T], T, s, pp).
aux_verb([am, being| T], T, i, pp).
aux_verb([am, not, being| T], T, i, pp).
aux_verb([am| T], T, i, Ten):- Ten = cont; Ten = pp.
aux_verb([am, not| T], T, i, Ten):- Ten = cont; Ten = pp.


aux_verb([am, going, to, be| T], T, i, Ten):- Ten = cont; Ten = pp.
aux_verb([am, gonna, be| T], T, i, Ten):- Ten = cont; Ten = pp.
aux_verb([am, not, going, to, be| T], T, i, Ten):- Ten = cont; Ten = pp. 
aux_verb([am, not, gonna, be| T], T, i, Ten):- Ten = cont; Ten = pp.
aux_verb([are, going, to, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([are, gonna, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([are, not, going, to, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([are, not, gonna, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([is, going, to, be| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([is, gonna, be| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([is, not, going, to, be| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([is, not, gonna, be| T], T, s, Ten):- Ten = cont; Ten = pp.


aux_verb([was, going, to, be| T], T, P, Ten):- (P = i; P= s), (Ten = cont; Ten = pp).
aux_verb([was, gonna, be| T], T, P, Ten):- (P = i; P= s), (Ten = cont; Ten = pp).
aux_verb([was, going, to, be| T], T, P, Ten):- (P = i; P= s), (Ten = cont; Ten = pp).
aux_verb([was, not, going, to, be| T], T, P, Ten):- (P = i; P= s), (Ten = cont; Ten = pp).
aux_verb([was, being| T], T, P, pp):- P = i; P = s.
aux_verb([was, not, being| T], T, P, pp):- P = i; P = s.
aux_verb([were, going, to, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([were, not, going, to, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([were, gonna, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([were, not, gonna, be| T], T, p, Ten):- Ten = cont; Ten = pp.
aux_verb([were, being| T], T, p, pp).
aux_verb([were, not, being| T], T, p, pp).


aux_verb([have| T], T, P, pp):- P = i; P = p.
aux_verb([have, not| T], T, P, pp):- P = i; P = p.
aux_verb([has| T], T, s, pp).
aux_verb([has, not| T], T, s, pp).

aux_verb([have, been| T], T, P, Ten):- (Ten = cont; Ten = pp), (P = i; P = p).
aux_verb([have, not, been| T], T, P, Ten):- (Ten = cont; Ten = pp), (P = i; P = p).
aux_verb([has, been| T], T, s, Ten):- Ten = cont; Ten = pp.
aux_verb([has, not, been| T], T, s, Ten):- Ten = cont; Ten = pp.

aux_verb([had| T], T, _, pp).
aux_verb([had, not| T], T, _, pp).
aux_verb([had, been| T], T, Ten):- Ten = cont; Ten = pp.
aux_verb([had, not, been| T], T, Ten):- Ten = cont; Ten = pp.


aux_verb([could, be| T], T, _, cont).
aux_verb([could, not, be| T], T, _, cont).
aux_verb([may, be| T], T, _, cont).
aux_verb([may, not, be| T], T, _, cont).
aux_verb([might, be| T], T, _, cont).
aux_verb([might, not, be| T], T, _, cont).
aux_verb([must, be| T], T, _, cont).
aux_verb([must, not, be| T], T, _, cont).
aux_verb([ought, to, be| T], T, _, cont).
aux_verb([ought, not, to, be| T], T, _, cont).
aux_verb([would, be| T], T, _, cont).
aux_verb([would, not, be| T], T, _, cont).
aux_verb([will, be| T], T, _, cont).
aux_verb([will, not, be| T], T, _, cont).
aux_verb([shall, be| T], T, _, cont).
aux_verb([shall, not, be| T], T, _, cont).
aux_verb([should, be| T], T, _, cont).
aux_verb([should, not, be| T], T, _, cont).

aux_verb([could, have| T], T, _, pp).
aux_verb([could, not, have| T], T, _, pp).
aux_verb([may, have| T], T, _, pp).
aux_verb([may, not, have| T], T, _, pp).
aux_verb([might, have| T], T, _, pp).
aux_verb([might, not, have| T], T, _, pp).
aux_verb([must, have| T], T, _, pp).
aux_verb([must, not, have| T], T, _, pp).
aux_verb([ought, to, have| T], T, _, pp).
aux_verb([ought, not, to, have| T], T, _, pp).
aux_verb([would, have| T], T, _, pp).
aux_verb([would, not, have| T], T, _, pp).
aux_verb([will, have| T], T, _, pp).
aux_verb([will, not, have| T], T, _, pp).
aux_verb([shall, have| T], T, _, pp).
aux_verb([shall, not, have| T], T, _, pp).
aux_verb([should, have| T], T, _, pp).
aux_verb([should, not, have| T], T, _, pp).

aux_verb([could, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([could, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([may, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([may, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([might, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([might, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([must, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([must, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([ought, to, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([ought, not, to, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([would, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([would, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([will, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([will, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([should, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.
aux_verb([should, not, have, been| T], T, _, Ten):- Ten = cont; Ten = pp.



% ------------------ regular verbs ----------------------

/*
s: singular, p: plural, pre: present, pres: present for singular
p: past, pp: past participle

The verbs are divided into the following subactegories:

1. pre, past, and pp are all the same. e.g. put
2. past and pp are the same. e.g. leave, left, left
3. pre and pp are the same. e.g. become, became, become.
4. pre and past are the same. e.g. bit, bit. bitten
4. All three are different. e.g. take, took, taken
*/

reg_verb([like| T], T, P, pre):- P = i; P = p.
reg_verb([likes| T], T, s, pres). 
reg_verb([liked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([liking| T], T, _, cont).

reg_verb([eats| T], T, s, pres).
reg_verb([eat| T], T, P, pre):- P = i; P = p.
reg_verb([ate| T], T, _, past).
reg_verb([eaten|T ], T, _, pp).
reg_verb([eating| T], T, _, cont).

reg_verb([thinks| T], T, s, pres).
reg_verb([think| T], T, P, pre):- P = i; P = p.
reg_verb([thought| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([thinking| T], T, _, cont).

reg_verb([drinks| T], T, s, pres).
reg_verb([drink| T], T, P, pre):- P = i; P = p.
reg_verb([drank| T], T, _, past).
reg_verb([drunk|T ], T, _, pp).
reg_verb([drinking| T], T, _, cont).

reg_verb([talks| T], T, s, pres).
reg_verb([talk| T], T, P, pre):- P = i; P = p.
reg_verb([talked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([talking| T], T, _, cont).

reg_verb([sees| T], T, s, pres).
reg_verb([see| T], T, P, pre):- P = i; P = p.
reg_verb([saw| T], T, _, past).
reg_verb([seen|T ], T, _, pp).
reg_verb([seeing| T], T, _, cont).

reg_verb([has| T], T, s, pres).
reg_verb([have| T], T, P, pre):- P = i; P = p.
reg_verb([had| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([having| T], T, _, cont).

reg_verb([walks| T], T, s, pres).
reg_verb([walk| T], T, P, pre):- P = i; P = p.
reg_verb([walked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([walking| T], T, _, cont).

reg_verb([puts| T], T, s, pres).
reg_verb([put| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([put| T], T, P, pre):- P = i, P = p.
reg_verb([putting| T], T, _, cont).

reg_verb([gets| T], T, s, pres).
reg_verb([get| T], T, P, pre):- P = i; P = p.
reg_verb([got| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([gotten|T ], T, _, pp).
reg_verb([getting| T], T, _, cont).

reg_verb([lives| T], T, s, pres).
reg_verb([live| T], T, P, pre):- P = i; P = p.
reg_verb([lived| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([living| T], T, _, cont).

reg_verb([takes| T], T, s, pres).
reg_verb([take| T], T, P, pre):- P = i; P = p.
reg_verb([took| T], T, _, past).
reg_verb([taken|T ], T, _, pp).
reg_verb([taking| T], T, _, cont).

reg_verb([goes| T], T, s, pres).
reg_verb([go| T], T, P, pre):- P = i; P = p.
reg_verb([went| T], T, _, past).
reg_verb([gone|T ], T, _, pp).
reg_verb([going| T], T, _, cont).

reg_verb([makes| T], T, s, pres).
reg_verb([make| T], T, P, pre):- P = i; P = p.
reg_verb([made| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([making| T], T, _, cont).

reg_verb([says| T], T, s, pres).
reg_verb([say| T], T, P, pre):- P = i; P = p.
reg_verb([said| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([saying| T], T, _, cont).

reg_verb([knows| T], T, s, pres).
reg_verb([know| T], T, P, pre):- P = i; P = p.
reg_verb([knew| T], T, _, past).
reg_verb([known|T ], T, _, pp).
reg_verb([knowing| T], T, _, cont).

reg_verb([comes| T], T, s, pres).
reg_verb([come| T], T, P, pre):- P = i; P = p.
reg_verb([come| T], T, _, pp).
reg_verb([came| T], T, _, past).
reg_verb([coming| T], T, _, cont).

reg_verb([gives| T], T, s, pres).
reg_verb([give| T], T, P, pre):- P = i; P = p.
reg_verb([gave| T], T, _, past).
reg_verb([given|T ], T, _, pp).
reg_verb([giving| T], T, _, cont).

reg_verb([runs| T], T, s, pres).
reg_verb([run| T], T, P, pre):- P = i; P = p.
reg_verb([run| T], T, _, pp).
reg_verb([ran| T], T, _, past).
reg_verb([running| T], T, _, cont).

reg_verb([wants| T], T, s, pres).
reg_verb([want| T], T, P, pre):- P = i; P = p.
reg_verb([wanted| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([wanting| T], T, _, cont).

reg_verb([uses| T], T, s, pres).
reg_verb([use| T], T, P, pre):- P = i; P = p.
reg_verb([used| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([using| T], T, _, cont).

reg_verb([finds| T], T, s, pres).
reg_verb([find| T], T, P, pre):- P = i; P = p.
reg_verb([found| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([finding| T], T, _, cont).

reg_verb([tells| T], T, s, pres).
reg_verb([tell| T], T, P, pre):- P = i; P = p.
reg_verb([told| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([telling| T], T, _, cont).

reg_verb([asks| T], T, s, pres).
reg_verb([ask| T], T, P, pre):- P = i; P = p.
reg_verb([asked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([asking| T], T, _, cont).

reg_verb([is| T], T, s, pres).
reg_verb([are| T], T, p, pre).
reg_verb([were| T], T, _, past).
reg_verb([been|T ], T, _, pp).
reg_verb([being| T], T, _, cont).

reg_verb([works| T], T, s, pres).
reg_verb([work| T], T, P, pre):- P = i; P = p.
reg_verb([worked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([working| T], T, _, cont).

reg_verb([feels| T], T, s, pres).
reg_verb([feel| T], T, P, pre):- P = i; P = p.
reg_verb([felt| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([feeling| T], T, _, cont).

reg_verb([tries| T], T, s, pres).
reg_verb([try| T], T, P, pre):- P = i; P = p.
reg_verb([tried| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([trying| T], T, _, cont).

reg_verb([calls| T], T, s, pres).
reg_verb([call| T], T, P, pre):- P = i; P = p.
reg_verb([called| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([calling| T], T, _, cont).

reg_verb([does| T], T, s, pres).
reg_verb([do| T], T, P, pre):- P = i; P = p.
reg_verb([did| T], T, _, past).
reg_verb([done|T ], T, _, pp).
reg_verb([doing| T], T, _, cont).

reg_verb([needs| T], T, s, pres).
reg_verb([need| T], T, P, pre):- P = i; P = p.
reg_verb([needed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([needing| T], T, _, cont).

reg_verb([becomes| T], T, s, pres).
reg_verb([become| T], T, P, pre):- P = i; P = p.
reg_verb([become| T], T, _, pp).
reg_verb([became| T], T, _, past).
reg_verb([becoming| T], T, _, cont).

reg_verb([means| T], T, s, pres).
reg_verb([mean| T], T, P, pre):- P = i; P = p.
reg_verb([meant| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([meaning| T], T, _, cont).

reg_verb([keeps| T], T, s, pres).
reg_verb([keep| T], T, P, pre):- P = i; P = p.
reg_verb([kept| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([keeping| T], T, _, cont).

reg_verb([lets| T], T, s, pres).
reg_verb([let| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([let| T], T, P, pre):- P = i, P = p.
reg_verb([letting| T], T, _, cont).

reg_verb([helps| T], T, s, pres).
reg_verb([help| T], T, P, pre):- P = i; P = p.
reg_verb([helped| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([helping| T], T, _, cont).

reg_verb([show| T],T, P, pre):- P = i; P = p.
reg_verb([shows| T], T, s, pres).
reg_verb([showed| T], T, _, past).
reg_verb([shown|T ], T, _, pp).
reg_verb([showing| T], T, _, cont).

reg_verb([happens| T], T, s, pres).
reg_verb([happen| T], T, P, pre):- P = i; P = p.
reg_verb([happened| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([happening| T], T, _, cont).

reg_verb([believes| T], T, s, pres).
reg_verb([believe| T], T, P, pre):- P = i; P = p.
reg_verb([believed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([beieving| T], T, _, cont).

reg_verb([brings| T], T, s, pres).
reg_verb([bring| T], T, P, pre):- P = i; P = p.
reg_verb([brought| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([bringing| T], T, _, cont).

reg_verb([meets| T], T, s, pres).
reg_verb([meet| T], T, P, pre):- P = i; P = p. 
reg_verb([met| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([meeting| T], T, _, cont).

reg_verb([leaves| T], T, s, pres).
reg_verb([leave| T], T, P, pre):- P = i; P = p.
reg_verb([left| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([leaving| T], T, _, cont).

reg_verb([allows| T], T, s, pres).
reg_verb([allow| T], T, P, pre):- P = i; P = p. 
reg_verb([allowed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([allowing| T], T, _, cont).

reg_verb([plays| T], T, s, pres).
reg_verb([play| T], T, P, pre):- P = i; P = p.
reg_verb([played| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([playing| T], T, _, cont).

reg_verb([types| T], T, s, pres).
reg_verb([type| T], T, P, pre):- P = i; P = p.
reg_verb([typed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([typing| T], T, _, cont).

reg_verb([hears| T], T, s, pres).
reg_verb([hear| T], T, P, pre):- P = i; P = p.
reg_verb([heard| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([hearing| T], T, _, cont).

reg_verb([moves| T], T, s, pres).
reg_verb([move| T], T, P, pre):- P = i; P = p.
reg_verb([moved| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([moving| T], T, _, cont).

reg_verb([lives| T], T, s, pres).
reg_verb([live| T], T, P, pre):- P = i; P = p.
reg_verb([lived| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([living| T], T, _, cont).

reg_verb([sits| T], T, s, pres).
reg_verb([sit| T], T, P, pre):- P = i; P = p.
reg_verb([sat| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([sitting| T], T, _, cont).

reg_verb([stands| T], T, s, pres).
reg_verb([stand| T], T, P, pre):- P = i; P = p.
reg_verb([stood| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([standing| T], T, _, cont).

reg_verb([fights| T], T, s, pres).
reg_verb([fight| T], T, P, pre):- P = i; P = p.
reg_verb([fought| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([fighting| T], T, _, cont).

reg_verb([loses| T], T, s, pres).
reg_verb([lose| T], T, P, pre):- P = i; P = p.
reg_verb([lost| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([losing| T], T, _, cont).

reg_verb([adds| T], T, s, pres).
reg_verb([add| T], T, P, pre):- P = i; P = p.
reg_verb([added| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([adding| T], T, _, cont).

reg_verb([pays| T], T, s, pres).
reg_verb([pay| T], T, P, pre):- P = i; P = p.
reg_verb([payed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([paying| T], T, _, cont).

reg_verb([struggles| T], T, s, pres).
reg_verb([stuggle| T], T, P, pre):- P = i; P = p.
reg_verb([struggled| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([struggling| T], T, _, cont).

reg_verb([bothers| T], T, s, pres).
reg_verb([bother| T], T, P, pre):- P = i; P = p.
reg_verb([bothered| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([bothering| T], T, _, cont).

reg_verb([includes| T], T, s, pres).
reg_verb([include| T], T, P, pre):- P = i; P = p.
reg_verb([included| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([including| T], T, _, cont).

reg_verb([continues| T], T, s, pres).
reg_verb([continue| T], T, P, pre):- P = i; P = p.
reg_verb([continued| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([continuing| T], T, _, cont).

reg_verb([starts| T], T, s, pres).
reg_verb([start| T], T, P, pre):- P = i; P = p.
reg_verb([started| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([starting| T], T, _, cont).

reg_verb([begins| T], T, s, pres).
reg_verb([begin| T], T, P, pre):- P = i; P = p.
reg_verb([began| T], T, _, past).
reg_verb([begun|T ], T, _, pp).
reg_verb([beginning| T], T, _, cont).

reg_verb([writes| T], T, s, pres).
reg_verb([write| T], T, P, pre):- P = i; P = p.
reg_verb([wrote| T], T, _, past).
reg_verb([written|T ], T, _, pp).
reg_verb([writing| T], T, _, cont).

reg_verb([speaks| T], T, s, pres).
reg_verb([speak| T], T, P, pre):- P = i; P = p.
reg_verb([spoke| T], T, _, past).
reg_verb([spoken|T ], T, _, pp).
reg_verb([speaking| T], T, _, cont).

reg_verb([breaks| T], T, s, pres).
reg_verb([break| T], T, P, pre):- P = i; P = p.
reg_verb([broke| T], T, _, past).
reg_verb([broken|T ], T, _, pp).
reg_verb([breaking| T], T, _, cont).

reg_verb([grows| T], T, s, pres).
reg_verb([grow| T], T, P, pre):- P = i; P = p.
reg_verb([grew| T], T, _, past).
reg_verb([grown|T ], T, _, pp).
reg_verb([growing| T], T, _, cont).

reg_verb([draws| T], T, s, pres).
reg_verb([draw| T], T, P, pre):- P = i; P = p.
reg_verb([drew| T], T, _, past).
reg_verb([drawn|T ], T, _, pp).
reg_verb([drawing| T], T, _, cont).

reg_verb([does| T], T, s, pres).
reg_verb([do| T], T, P, pre):- P = i; P = p.
reg_verb([did| T], T, _, past).
reg_verb([done|T ], T, _, pp).
reg_verb([doing| T], T, _, cont).

reg_verb([swings| T], T, s, pres).
reg_verb([swing| T], T, P, pre):- P = i; P = p.
reg_verb([swang| T], T, _, past).
reg_verb([swung|T ], T, _, pp).
reg_verb([swinging| T], T, _, cont).

reg_verb([sings| T], T, s, pres).
reg_verb([sing| T], T, P, pre):- P = i; P = p.
reg_verb([sang| T], T, _, past).
reg_verb([sung|T ], T, _, pp).
reg_verb([singing| T], T, _, cont).

reg_verb([studies| T], T, s, pres).
reg_verb([study| T], T, P, pre):- P = i; P = p.
reg_verb([studied| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([studying| T], T, _, cont).

reg_verb([cooks| T], T, s, pres).
reg_verb([cook| T], T, P, pre):- P = i; P = p.
reg_verb([cooked| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([cooking| T], T, _, cont).

reg_verb([sleeps| T], T, s, pres).
reg_verb([sleep| T], T, P, pre):- P = i; P = p.
reg_verb([slept| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([sleeping| T], T, _, cont).

reg_verb([turns| T], T, s, pres).
reg_verb([turn| T], T, P, pre):- P = i; P = p.
reg_verb([turned| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([turning| T], T, _, cont).

reg_verb([holds| T], T, s, pres).
reg_verb([hold| T], T, P, pre):- P = i; P = p.
reg_verb([held| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([holding| T], T, _, cont).

reg_verb([buys| T], T, s, pres).
reg_verb([buy| T], T, P, pre):- P = i; P = p.
reg_verb([bought| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([buying| T], T, _, cont).

reg_verb([jumps| T], T, s, pres).
reg_verb([jump| T], T, P, pre):- P = i; P = p.
reg_verb([jumped| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([jumping| T], T, _, cont).

reg_verb([provides| T], T, s, pres).
reg_verb([provide| T], T, P, pre):- P = i; P = p.
reg_verb([provided| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([providing| T], T, _, cont).

reg_verb([offers| T], T, s, pres).
reg_verb([offer| T], T, P, pre):- P = i; P = p.
reg_verb([offered| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([offerring| T], T, _, cont).

reg_verb([learns| T], T, s, pres).
reg_verb([learn| T], T, P, pre):- P = i; P = p.
reg_verb([learned| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([learning| T], T, _, cont).

reg_verb([changes| T], T, s, pres).
reg_verb([change| T], T, P, pre):- P = i; P = p.
reg_verb([changed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([changing| T], T, _, cont).

reg_verb([leads| T], T, s, pres).
reg_verb([lead| T], T, P, pre):- P = i; P = p.
reg_verb([led| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([leading| T], T, _, cont).

reg_verb([understands| T], T, s, pres).
reg_verb([understand| T], T, P, pre):- P = i; P = p.
reg_verb([understood| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([understanding| T], T, _, cont).

reg_verb([spends| T], T, s, pres).
reg_verb([spend| T], T, P, pre):- P = i; P = p.
reg_verb([spent| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([spending| T], T, _, cont).

reg_verb([texts| T], T, s, pres).
reg_verb([text| T], T, P, pre):- P = i; P = p.
reg_verb([texted| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([texting| T], T, _, cont).

reg_verb([sends| T], T, s, pres).
reg_verb([send| T], T, P, pre):- P = i; P = p.
reg_verb([sent| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([sending| T], T, _, cont).

reg_verb([opens| T], T, s, pres).
reg_verb([open| T], T, P, pre):- P = i; P = p.
reg_verb([opened| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([opening| T], T, _, cont).

reg_verb([closes| T], T, s, pres).
reg_verb([close| T], T, P, pre):- P = i; P = p.
reg_verb([closed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([closing| T], T, _, cont).

reg_verb([includes| T], T, s, pres).
reg_verb([include| T], T, P, pre):- P = i; P = p.
reg_verb([included| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([including| T], T, _, cont).

reg_verb([wins| T], T, s, pres).
reg_verb([win| T], T, P, pre):- P = i; P = p.
reg_verb([won| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([winning| T], T, _, cont).

reg_verb([remembers| T], T, s, pres).
reg_verb([remember| T], T, P, pre):- P = i; P = p.
reg_verb([remembered| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([remembering| T], T, _, cont).

reg_verb([loves| T], T, s, pres).
reg_verb([love| T], T, P, pre):- P = i; P = p.
reg_verb([loved| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([loving| T], T, _, cont).

reg_verb([considers| T], T, s, pres).
reg_verb([consider| T], T, P, pre):- P = i; P = p.
reg_verb([considered| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([considering| T], T, _, cont).

reg_verb([appears| T], T, s, pres).
reg_verb([appear| T], T, P, pre):- P = i; P = p.
reg_verb([appeared| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([appearing| T], T, _, cont).

reg_verb([includes| T], T, s, pres).
reg_verb([include| T], T, P, pre):- P = i; P = p.
reg_verb([included| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([including| T], T, _, cont).

reg_verb([waits| T], T, s, pres).
reg_verb([wait| T], T, P, pre):- P = i; P = p.
reg_verb([waited| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([waits| T], T, _, cont).

reg_verb([dies| T], T, s, pres).
reg_verb([die| T], T, P, pre):- P = i; P = p.
reg_verb([died| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([dying| T], T, _, cont).

reg_verb([expects| T], T, s, pres).
reg_verb([expect| T], T, P, pre):- P = i; P = p.
reg_verb([expected| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([expected| T], T, _, cont).

reg_verb([assumes| T], T, s, pres).
reg_verb([assume| T], T, P, pre):- P = i; P = p.
reg_verb([assumed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([assuming| T], T, _, cont).

reg_verb([includes| T], T, s, pres).
reg_verb([include| T], T, P, pre):- P = i; P = p.
reg_verb([included| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([including| T], T, _, cont).

reg_verb([stays| T], T, s, pres).
reg_verb([stays| T], T, P, pre):- P = i; P = p.
reg_verb([stayed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([staying| T], T, _, cont).

reg_verb([includes| T], T, s, pres).
reg_verb([include| T], T, P, pre):- P = i; P = p.
reg_verb([included| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([including| T], T, _, cont).

reg_verb([reaches| T], T, s, pres).
reg_verb([reach| T], T, P, pre):- P = i; P = p.
reg_verb([reached| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([reachinging| T], T, _, cont).

reg_verb([arrives| T], T, s, pres).
reg_verb([arrive| T], T, P, pre):- P = i; P = p.
reg_verb([arrived| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([arriving| T], T, _, cont).

reg_verb([builds| T], T, s, pres).
reg_verb([build| T], T, P, pre):- P = i; P = p.
reg_verb([built| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([building| T], T, _, cont).

reg_verb([kills| T], T, s, pres).
reg_verb([kill| T], T, P, pre):- P = i; P = p.
reg_verb([killed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([killing| T], T, _, cont).

reg_verb([remains| T], T, s, pres).
reg_verb([remain| T], T, P, pre):- P = i; P = p.
reg_verb([remained| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([reamaining| T], T, _, cont).

reg_verb([watches| T], T, s, pres).
reg_verb([watch| T], T, P, pre):- P = i; P = p.
reg_verb([watched| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([watching| T], T, _, cont).

reg_verb([teachs| T], T, s, pres).
reg_verb([teach| T], T, P, pre):- P = i; P = p.
reg_verb([taught| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([teaching| T], T, _, cont).

reg_verb([serves| T], T, s, pres).
reg_verb([serve| T], T, P, pre):- P = i; P = p.
reg_verb([served| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([serving| T], T, _, cont).

reg_verb([passes| T], T, s, pres).
reg_verb([pass| T], T, P, pre):- P = i; P = p.
reg_verb([passed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([passing| T], T, _, cont).

reg_verb([raises| T], T, s, pres).
reg_verb([raise| T], T, P, pre):- P = i; P = p.
reg_verb([raised| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([raising| T], T, _, cont).

reg_verb([decidees| T], T, s, pres).
reg_verb([decide| T], T, P, pre):- P = i; P = p.
reg_verb([decided| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([deciding| T], T, _, cont).

reg_verb([returns| T], T, s, pres).
reg_verb([returned| T], T, P, pre):- P = i; P = p.
reg_verb([returned| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([returning| T], T, _, cont).

reg_verb([explains| T], T, s, pres).
reg_verb([explain| T], T, P, pre):- P = i; P = p.
reg_verb([explained| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([explaining| T], T, _, cont).

reg_verb([hopes| T], T, s, pres).
reg_verb([hope| T], T, P, pre):- P = i; P = p.
reg_verb([hoped| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([hoping| T], T, _, cont).

reg_verb([cathess| T], T, s, pres).
reg_verb([catch| T], T, P, pre):- P = i; P = p.
reg_verb([caught| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([catching| T], T, _, cont).

reg_verb([agrees| T], T, s, pres).
reg_verb([agree| T], T, P, pre):- P = i; P = p.
reg_verb([agreed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([agreeing| T], T, _, cont).

reg_verb([supports| T], T, s, pres).
reg_verb([support| T], T, P, pre):- P = i; P = p.
reg_verb([supported| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([supporting| T], T, _, cont).

reg_verb([receives| T], T, s, pres).
reg_verb([receive| T], T, P, pre):- P = i; P = p.
reg_verb([received| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([receiving| T], T, _, cont).

reg_verb([forgets| T], T, s, pres).
reg_verb([forget| T], T, P, pre):- P = i; P = p.
reg_verb([forgot| T], T, _, past).
reg_verb([forgotten|T ], T, _, pp).
reg_verb([forgetting| T], T, _, cont).

reg_verb([steals| T], T, s, pres).
reg_verb([steal| T], T, P, pre):- P = i; P = p.
reg_verb([stole| T], T, _, past).
reg_verb([stolen|T ], T, _, pp).
reg_verb([stealing| T], T, _, cont).

reg_verb([chooses| T], T, s, pres).
reg_verb([choose| T], T, P, pre):- P = i; P = p.
reg_verb([chose| T], T, _, past).
reg_verb([chosen|T ], T, _, pp).
reg_verb([choosing| T], T, _, cont).

reg_verb([falls| T], T, s, pres).
reg_verb([fall| T], T, P, pre):- P = i; P = p.
reg_verb([fell| T], T, _, past).
reg_verb([fallen|T ], T, _, pp).
reg_verb([falling| T], T, _, cont).

reg_verb([stops| T], T, s, pres).
reg_verb([stop| T], T, P, pre):- P = i; P = p.
reg_verb([stopped| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([stopping| T], T, _, cont).

reg_verb([follows| T], T, s, pres).
reg_verb([follow| T], T, P, pre):- P = i; P = p.
reg_verb([followed| T], T, _, Ten):- Ten = pp; Ten = past.
reg_verb([following| T], T, _, cont).

reg_verb([cuts| T], T, s, pres).
reg_verb([cut| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([cut| T], T, P, pre):- P = i, P = p.
reg_verb([cutting| T], T, _, cont).

reg_verb([sets| T], T, s, pres).
reg_verb([set| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([set| T], T, P, pre):- P = i, P = p.
reg_verb([setting| T], T, _, cont).

reg_verb([reads| T], T, s, pres).
reg_verb([read| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([read| T], T, P, pre):- P = i, P = p.
reg_verb([reading| T], T, _, cont).

reg_verb([hits| T], T, s, pres).
reg_verb([hit| T], T, _, Ten):- Ten = past; Ten = pp.
reg_verb([hit| T], T, P, pre):- P = i, P = p.
reg_verb([hitting| T], T, _, cont).

reg_verb([bits| T], T, s, pres).
reg_verb([bitten| T], T, _, pp).
reg_verb([bit| T], T, P, pre):- P = i, P = p.
reg_verb([bit| T], T, _, past).
reg_verb([bitting| T], T, _, cont).

reg_verb([beats| T], T, s, pres).
reg_verb([beaten| T], T, _, pp).
reg_verb([beat| T], T, P, pre):- P = i, P = p.
reg_verb([beat| T], T, _, past).
reg_verb([beating| T], T, _, cont).



% ------------ pronouns -----------------------
pronoun([i| T], T, i).
pronoun([we| T], T, p).
pronoun([you| T], T, p).
pronoun([they| T], T, p).
pronoun([he| T], T, s).
pronoun([she| T], T, s).
pronoun([it| T], T, s).

pronoun([us| T], T, p).
pronoun([me| T], T, p).
pronoun([them| T], T, p).
pronoun([her| T], T, s).
pronoun([him| T], T, s).

% -------------- proper nouns --------------

proper_noun([ubc| T], T, s).
proper_noun([google| T], T, s).
proper_noun([facebook| T], T, s).
proper_noun([linkedin| T], T, s).
proper_noun([instagram| T], T, s).
proper_noun([whatsapp| T], T, s).
proper_noun([wechat| T], T, s).
proper_noun([twitter| T], T, s).
proper_noun([youtube| T], T, s).
proper_noun([netflix| T], T, s).

proper_noun([canada| T], T, s).
proper_noun([bc| T], T, s).
proper_noun([vancouver| T], T, s).
proper_noun([usa| T], T, s).
proper_noun([india| T], T, s).
proper_noun([china| T], T, s).
proper_noun([mexico| T], T, s).

proper_noun([victoria| T], T, s).
proper_noun([kevin| T], T, s).
proper_noun([kelvin| T], T, s).
proper_noun([david| T], T, s).
proper_noun([emily| T], T, s).
proper_noun([rui| T], T, s).
proper_noun([alex| T], T, s).
proper_noun([julin| T], T, s).
proper_noun([peter| T], T, s).
proper_noun([anne| T], T, s).
proper_noun([anna| T], T, s).
proper_noun([annie| T], T, s).
proper_noun([rebecca| T], T, s).
proper_noun([ben| T], T, s).
proper_noun([michael| T], T, s).
proper_noun([michelle| T], T, s).
proper_noun([rachael| T], T, s).
proper_noun([lily| T], T, s).
proper_noun([linda| T], T, s).
proper_noun([richard| T], T, s).
proper_noun([john| T], T, s).
proper_noun([james| T], T, s).
proper_noun([eric| T], T, s).
proper_noun([marry| T], T, s).
proper_noun([matthew| T], T, s).
proper_noun([fiona| T], T, s).
proper_noun([crystal| T], T, s).
proper_noun([jessica| T], T, s).
proper_noun([sherry| T], T, s).
proper_noun([grace| T], T, s).
proper_noun([alan| T], T, s).
proper_noun([janet| T], T, s).
proper_noun([jean| T], T, s).

% ---------------------------- thing ----------------
thing([time| T], T, s).
thing([times| T], T, p).

thing([thing| T], T, s).
thing([things| T], T, p).

thing([person| T], T, s).
thing([people| T], T, p).


thing([day| T], T, s).
thing([days| T], T, p).

thing([way| T], T, s).
thing([ways| T], T, p).

thing([man| T], T, s).
thing([men| T], T, p).

thing([guy| T], T, s).
thing([guys| T], T, p).

thing([woman| T], T, s).
thing([women| T], T, p).

thing([life| T], T, s).
thing([lives| T], T, p).

thing([child| T], T, s).
thing([children| T], T, p).

thing([world| T], T, s).

thing([student| T], T, s).
thing([students| T], T, p).

thing([place| T], T, s).
thing([places| T], T, p).

thing([food| T], T, s).

thing([week| T], T, s).
thing([weeks| T], T, p).

thing([school| T], T, s).
thing([schools| T], T, p).

thing([question| T], T, s).
thing([questions| T], T, p).

thing([color| T], T, s).
thing([people| T], T, p).

thing([money| T], T, s).

thing([water| T], T, s).

thing([home| T], T, s).

thing([work| T], T, s).

%---------- prepositions ------------
prep([to| T], T).
prep([with| T], T).
prep([without| T], T).
prep([in| T], T).
prep([inside| T], T).
prep([on| T], T).
prep([by| T], T).
prep([under| T], T).
prep([beside| T], T).
prep([around| T], T).
prep([through| T], T).
prep([above| T], T).
prep([below| T], T).

% --------- adjectives -----------
adj([other| T], T).
adj([new| T], T).
adj([good| T], T).
adj([great| T], T).
adj([high| T], T).
adj([old| T], T).
adj([big| T], T).
adj([small| T], T).
adj([canadian| T], T).
adj([large| T], T).
adj([young| T], T).
adj([different| T], T).
adj([same| T], T).
adj([similar| T], T).
adj([black| T], T).
adj([red| T], T).
adj([white| T], T).
adj([long| T], T).
adj([bad| T], T).
adj([little| T], T).
adj([important| T], T).
adj([only| T], T).
adj([best| T], T).
adj([sure| T], T).
adj([early| T], T).
adj([able| T], T).
adj([human| T], T).
adj([better| T], T).
adj([worse| T], T).
adj([late| T], T).
adj([hard| T], T).
adj([easy| T], T).
adj([free| T], T).
adj([true| T], T).
adj([right| T], T).
adj([available| T], T).
adj([wrong| T], T).
adj([fine| T], T).
adj([okay| T], T).
adj([hot| T], T).
adj([cool| T], T).
adj([cold| T], T).
adj([nice| T], T).
adj([left| T], T).
adj([general| T], T).
adj([simple| T], T).
adj([serious| T], T).
adj([happy| T], T).
adj([sad| T], T).
adj([tall| T], T).
adj([tired| T], T).

/*
To start testing sentences, run the following:
?- q.
*/
q :-
    write("Type a sentence: "),
    readln(Ln),
    maplist(downcase_atom,Ln,Sentence),
    sentence(Sentence, End, _),
    member(End,[[],['?'],['.']]).
