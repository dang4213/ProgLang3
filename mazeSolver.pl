:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

:- dynamic(visited/2).
visited(-1,-1).


find_exit(X, Y) :-
  goal(EndX, EndY),
  (X=:=EndX, Y =:=EndY) ->
    print_coor(X, Y),
    write('Done!'),
    abort
  ; %else, not done
    info(Xmax, Ymax, _),
    (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    % write('out: '), print_coor(X,Y), nl %debug
    write('')
    ; asserta(visited(X, Y)),
      print_coor(X,Y),
      Xup is X+1, Xdown is X-1, Yup is Y+1, Ydown is Y-1,
      find_exit(Xup, Y),
      find_exit(Xdown, Y),
      find_exit(X, Yup),
      find_exit(X, Ydown).
%------------------------------------------------------------------------------------------
% press button takes 4 args: num buttons left, x coordinate, and y coordinate,
  %current button Id to be pressed(starts at 1)
% if no buttons left, call find_goal to go from current x, y towards the goal
press_button(0, X, Y, Id) :- write('found all buttons'), nl, find_exit(X, Y). %TODO find_goal(X, Y). % also, retractall beforehand
press_button(N, X, Y, Id) :-
  info(Xmax, Ymax, _),
  %if out of bounds, or if we've visited here, or if this is a wall, return.
  (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    % write('out: '), print_coor(X,Y), nl %debug
    write('')
    ; asserta(visited(X, Y)),
      print_coor(X,Y),
      %if this is the next button to press, do so, clear visited, and recurse
      button(X, Y, Id) ->
      Num_Left is N - 1,
      retractall(visited(_,_)),
      press_button(Num_left, X, Y, succ(Id))
        %else, recurse to all nearby areas
      ; Xup is X+1, Xdown is X-1, Yup is Y+1, Ydown is Y-1,
        press_button(N, Xup, Y, Id),
        press_button(N, Xdown, Y, Id),
        press_button(N, X, Yup, Id),
        press_button(N, X, Ydown, Id).
%--------------------------------------------------------------------------------------
print_coor(X, Y) :-
  write([X,Y]), nl. %TODO print to file, not console

main :-
  %call press_button. num_buttons to begin with, the X and Y coordinates, and the
  %current button ID to be pressed (starts at 1).
  start(X,Y),
  num_buttons(N),
  press_button(N, X, Y, 1 ),
  retractall(visited(_,_)).
