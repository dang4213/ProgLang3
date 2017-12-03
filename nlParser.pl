:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

%current is the current X Y location of einstein
:- dynamic(current/2). %declare dynamic so this can be changed.
current(-1,-1). %seemed to require one arbitrary inital value in visited.


%the datebase of acceptable grammars for this project
article("the").
article("a").

subject("rat").
subject("rodent").
subject("einstein").
subject("he").
subject("it").

verb("ran").
verb("moved").
verb("scurried").

verb("pushed").

object("square").
object("squares").
object("cell").
object("cells").

object("button").

direction("up").
direction("right").
direction("down").
direction("left").

num("1").
num("2").
num("3").
num("4").
num("5").
num("6").
num("7").
num("8").
num("9").



main :-
    open('NL-input.txt', read, Str),
    read_file(Str,Lines),
    %Convert the lines in file to an list of sentences that are lists of words
    lines_to_words(Lines, Words),
    close(Str),
    write(Words), nl,

    %set the current position
    start(X,Y),
    retractall(current(_,_)),
    asserta(current(X,Y)),

    %create and/or clear the file
    open('NL-parse-solution.txt', write, File),
    close(File),

    parse_all_sentences(Words).

%we're done if emtpy
parse_all_sentences([]).
%otherwise, send the first sentece to parse_one_sentence
parse_all_sentences([H|T]) :-
  ( H = "end_of_file" ->
    abort
  ; %else, continue
  parse_one_sentence(H),
  parse_all_sentences(T)
  ).


%take one sentence (gives a list of words), and determine if
%it is a valid sentence
parse_one_sentence([H|T]) :-
  %if first is article or subject
  [H2|T2] = T,
  ( (article(H), subject(H2)) ->
    %continue parsing sentence
    [H3|T3] = T2,
    %if the next word is a verb
    ( verb(H3) ->
      %contine parsing
      %if next spot is a number, then this is a move
      [H4|T4] = T3,
      ( num(H4) ->
        %continute parsing out next object and direction
        [H5|T5] = T4,
        [H6|T6] = T5,
        %if next is an object and last is a direction
        ( object(H5), direction(H6), T6=[] ->
          %this is valid, so move einstein accordingly
          move_einstein(H6, H4) %this method takes in direction, the number

          ;%else, invalid sentence
            not_valid_sentence()
          )

        ; %else, see if this is the other sentence structure
          %also check to ensure that the object is button, otherwise this would be invalid
        [H5|T5] = T4,
        ( article(H4), object(H5), T5=[], H5="button", H3="pushed" ->
          %then call press button
          press_button()
          ; %else, not valid
          not_valid_sentence()
        )

        ; %else not a sentence.
        not_valid_sentence()
      )
      ; %else not valid
        not_valid_sentence()
    )

    ; %else no article, still could be valid
    %This code is just copy and pasted from above
    ( subject(H) ->
     %continue parsing sentence
     [H2|T2] = T,
     %if the next word is a verb
     ( verb(H2) ->
       %contine parsing
       %if next spot is a number, then this is a move
       [H3|T3] = T2,
       ( num(H3) ->
         %continute parsing out next object and direction
         [H4|T4] = T3,
         [H5|T5] = T4,
         %if next is an object and last is a direction
         ( object(H4), direction(H5), T5=[] ->
           %this is valid, so move einstein accordingly
           move_einstein(H5, H3) %this method takes in direction, the number
           ;%else, invalid sentence
             not_valid_sentence()
         )
         ; %else, see if this is the other sentence structure
         [H4|T4] = T3,
         ( article(H3), object(H4), T4=[], H4="button", H2="pushed" ->
           %then call press button
           press_button()
           ; %else, not valid
             not_valid_sentence()
          )
          ; %else not a sentence.
            not_valid_sentence()
        )
       ; %else not valid
         not_valid_sentence()
      )

     ; %else not valid b/c no subject
       not_valid_sentence()
    )
  ).

not_valid_sentence :-
  open('NL-parse-solution.txt', append, Handle),
  write(Handle, 'Not a valid sentence\n'),
  close(Handle).
%  write("Not a valid sentence"), nl.

%see if einstein is standing on a button. if so, print valid_move
%and move on, else invalid and stop parsing.
press_button :-
  current(X,Y),

  %if there is a button here
  button(X,Y,_) ->
    valid_move()
    ; %else,
    invalid_move().

valid_move :-
  open('NL-parse-solution.txt', append, Handle),
  write(Handle, 'Valid move\n'),
  close(Handle).
  %write("Valid move"), nl. %TODO, switch to file

invalid_move :-
  open('NL-parse-solution.txt', append, Handle),
  write(Handle, 'Not a valid move\n'),
  close(Handle),
  %write("Not a valid move"), nl, %switch to file
  abort.

%move einstien in this direction this number of moves if possible.
%if not, then print invalid move and abort.
move_einstein(Direction, Number) :-
  %if direction is up
  ( Direction = "up" ->
    %then try to move einstien up this number of squares
    current(X,Y), %get current position
    info(_, MaxY, _), %get max y
    atom_number(Number, N),
    NewY is Y-N,
    %if Y + number is within bounds
    ( (NewY < MaxY, \+ wall(X, between(NewY, Y))) ->
      %valid move
      retractall(current(_,_)),
      asserta(current(X,NewY)),
      valid_move()
      ; %else invalid move, abort
      invalid_move()
    )

    ; %else if direction is down
    ( Direction = "down" ->
      % try to move him number cells down
      current(X,Y), %get current position
      atom_number(Number, N),
      NewY is Y+N,
      %if Y + number is within bounds
      ( (NewY >= 0, \+ wall(X, between(Y, NewY))) ->
        %valid move
        retractall(current(_,_)),
        asserta(current(X,NewY)),
        valid_move()
        ; %else invalid move, abort
        invalid_move()
      )

      ; %else if right
      ( Direction = "right" ->
        %try to move number towards right
        current(X,Y), %get current position
        atom_number(Number, N),
        info(MaxX, _, _), %get max y
        NewX is X+N,
        %if Y + number is within bounds
        ( (NewX < MaxX, \+ wall(X, between(X, NewX))) ->
          %valid move
          retractall(current(_,_)),
          asserta(current(NewX,Y)),
          valid_move()
          ; %else invalid move, abort
          invalid_move()
        )

        ; %else if left
        ( Direction = "left" ->
          %try to move left
          current(X,Y), %get current position
          atom_number(Number, N),
          NewX is X-N,
          %if Y + number is within bounds
          ( (NewX >= 0, \+ wall(X, between(NewX, X))) ->
            %valid move
            retractall(current(_,_)),
            asserta(current(NewX,Y)),
            valid_move()
            ; %else invalid move, abort
            invalid_move()
          )

          ; %else error
          write("Error, invalid direction"), nl
        )
      )
    )
  ).

% Credit to StackOverflow and author Ishq for file parser
% https://stackoverflow.com/a/4805931
% https://stackoverflow.com/users/577045/ishq
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file(Stream,L).

%Converts sentence to a list of words
lines_to_words([], []).
lines_to_words([H|T], [H2|T2]) :-
	split_string(H, " ", "", H2),
	lines_to_words(T, T2).
