% download swi pro log.
%make a .pl file. to open the swi terminal, you can double click the file
%in its directory (Windows)

% to compile this file compile: [db].

%this is a fact. Technically an Atom; recall atoms from PA1
loves(romeo, juliet).

%% rule, fact, or clause. Returns Yes if they love eachother
loves(juliet, romeo) :- loves(romeo, juliet).

%% FACT USAGE:
male(bob).
male(carl).
male(charlie).

female(alice).
female(sophia).

%% type: female(alice).     returns: yes
%% type: listing(male).     returns: list of all males in form male(name).
%% type: male(X), female(Y).  returns: all combos of male and female, hit ";" to cycle through


%% RULES
%% ":-" is equivalent to "if"
%% "," is equivalent to "and"

happy(albert).
happy(alice).
with_albert(alice).

%% rule example:
runs(albert) :-
  happy(albert).

dances(alice) :-
  happy(alice), with_albert(alice).

%% Can define our own PREDICATES:
does_alice_dance :- dances(alice),
  write('when alice is happy and with albert she dances').

%% can create OR by making 2 of same rule:
swims(albert) :- happy(albert).
swimgs(albert) :- near_water(albert).
%% still true even though near_water is never a listed fact

%% IF STATEMENT equivalent
%% define multiple of same predicate

what_grade(5) :-
  write('go to kindergarten'), nl.
what_grade(6) :-
  write('go to 1st grade'), nl.
what_grade(Other) :-   %% where Other is just arbitrary var name
  Grade is Other - 5,   %% defines Grade as Other minus 5
  format('go to grade ~w', [Grade]).

%% Printing: format('~s   ~w   ~n')   s is string, w is variable, n is newline


%% STRUCTURES:
%% similar to HW1.

customer(sally, smith, 120.55).
%% querry: customer(sally, _, Bal).
    %% _ means we do not care about that variable, Bal is the var that is returned.
    %% so returns 120.55

%% define a vertical line:
vertical(line(point(X, Y), point(X, Y2))).
horizontal(line(point(X, Y), point(X2, Y))).  %% horizontal line
%% test: vertical(line(point(5, 10), point(5, 15))).   returns: yes
%% test: vertical(line(point(5,10), X)).               returns: X=point(5,_).


%% TRACE
  %% use trace to debug in terminal.
  %% turn on by typing "trace", off with "notrace", once on just type commands normally

%% MATH
%% use "is" to assign math, = to assign variables
%% in terminal: X is 2+2.     returns: X = 4
%%              X = 2+2.      returns: x = 2 + 2 (string)

%% logic:
    %% 50 > 30.     yes
    %% (3*10) >= (50/2).   yes
    %%  (3*10) =< (50/2).   no     NOTE that less than or equal to is typed flipped
    %% \+ (3 = 10).       yes      this if not, wierd syntax
    %% 5+4 =:= 4+5.       yes     NOTE this is equality
    %% 5+4 =\= 5+4.        no     NOTE this is not equals
    %% 5 > 10 ; 10 < 100   yes    NOTE this is OR, can also be used instead of a comma in rules

%% MATH FUNCTIONS
    %% X is mod(7,2).           1       MODULUS
    %% random(0, 10, X).        X=2     RANDOM
    %% between(0, 3).           X=0; X=1... between function
    %% succ(2, X).              X=3     NEXT
    %% abs(-8).                 X=8    ABSOLUTE VALUE
    %% X is max(10, 5).         X=10   MAX
    %% X is min(10, 5).         X=5   MIN
    %% X is round(10.56).       X=11  ROUND
    %% X is truncate(10.56).    X=10   TRUNCATE
    %% X is 2** 3               X=8.0   POWER, givex 2 to power of 3
    %% X is 5/2.                X=2.5   DIVISION (floats)
    %% X is 5//2                X=2    DIVISION (ints)


  %% OUTPUT
    %% write('hi'), nl.     "nl" gives a newline

  %% INPUT
  say_hi :-
      write('what is your name '),
      read(X),
      write('Hi '), write(X).

write_to_file(File, Text) :-
  open(File, write, Stream),
  write(Stream, Text), nl,
  close(Stream).

read_file(File) :-
  open(File, read, Stream),
  get_char(Stream, Char1),
  process_stream(Char1, Stream),
  close(Stream).

process_stream(end_of_file, _) :- !.
process_stream(Char, Stream) :-
    write(Char),
    get_char(Stream, Char2),
    process_stream(Char2, Stream).
%% Test above with:
/*
  write_to_file('test.txt', 'Random string').
  read_file('test.txt').
*/



%% LOOPING
%% use recursion
%%exmaples:
count_to_10(10) :- write(10), nl.

count_to_10(X) :-
  write(X), nl,
  Y is X+1,
  count_to_10(Y).

count_down(Low, High) :-
  between(Low, High, Y),
  Z is High -Y,
  write(Z), nl.

count_up(Low, High) :-
  between(Low, High, Y),
  Z is Y +Low,
  write(Z), nl.

%% Changing the database

  %% first, make the facts as dynamic:
:- dynamic(father/2). %%means father is dynamic and has 2 attributes.
:- dynamic(death/3).  %% params: dead, killer, method
:- dynamic(visited/2).

father(blaine, charlotte).

death(blaine, chloe, gun).


%% ADD by assertz(father(blaine, isabella)).       returns true
%% then check: father(blaine, isabella)).          returns true
%% NOTE assertz adds to end of that fact's list, asserta adds to beginning

%% DELETE by retract(death(blaine, chloe, gun)).
%% delete all: retractall(father(_,_)).




%% LISTS
  %% add to a list:
  %% write([albert|[alice,bob]]), nl.
  %%gives: [albert, alice, bob]

  %% HEAD AND TAIL:
  %% [H|T] = [a,b,c].
  %%gives:    H=a         T=[b,c]

  %% map to list
  %% [X1, X2, X3, X4 | T] = [1, b, c, d, e, f].
  %% sets that vars to their respective spots, rest to T
    %%  do this with ANONYMOUS vars
    %% [_, X2, _, _|T] = [a,b,c,d,e,f].
    %% X2 = b    and T = [e,f]

  %% 2D LISTS
  %% [_,_, [X|Y], _, Z | Tail] = [a,b, [c,d,e], f, g ,h].
  %% set X= c,      Y = [d,e],      Z=g,        Tail = [h]

  %%membership in a list
    %% List1 = [a,b,c].
    %% member(a, List1).      returns: yes

  %% append 2 lists
    %% append(L1, L2, Result).    returns list Result = L1+L2

  %% Loop through a list:
  write_list([]). %%base case, nothing
  write_list( [Head| Tail]) :-
    write(Head), nl,
    write_list(Tail).


% NOTE IF STATEMENTS
do_thing :-
  %follow form of:
  % (if clause) -> (then clause) ; (else clause)
  5>4 ->
    write('five is greater than four'), nl
    ; %else
    write('whaaat')
  5<4 ->
    write("whaaaaaaa")
    ; %else
    write('five still greater than four'), nl.

%% STRINGS
  %% name('string', X).     x= [list of ascii values of 'string']
  %%convert back:  name(X, list). where list is ascii values

join_str(S1, S2, S3) :- %% S3 is the returned string
  name(S1, SList1),
  name(S2, SList2),
  append(SList1, SList2, SList3),
  name(S3, SList3).

main :-
  write_list([a,b,c,d,e,f,g,h]), nl.
