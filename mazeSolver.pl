:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

:- dynamic(visited/2).
visited(-1,-1).


%------------------------------------------------------------------------------
print_list(_File,[]) :- !.
print_list(File, [[X,Y]|Tail]) :-
  write(File, [X,Y]),
  write(File, '\n'),
  print_list(File, Tail).

write_list(Filename, List) :-
  open(Filename, write, File),
  print_list(File, List),
  close(File).

print_list_to_console([]).
print_list_to_console([[X,Y]|T]) :-
  write([X,Y]), nl,
  print_list_to_console(T).

%----------------------------------------------------------------------------
find_exit(X, Y, List) :-
  goal(EndX, EndY),
  (X=:=EndX, Y =:=EndY) ->
    % print_coor(X, Y),
    % write('Done!'),
    reverse([[X,Y]|List], List2),
    write_list('path-solution.txt',List2)
  ; %else, not done
    info(Xmax, Ymax, _),
    (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    % write('out: '), print_coor(X,Y), nl %debug
    write('')
    ; asserta(visited(X, Y)),
      % print_coor(X,Y),
      % append(List, [X,Y], List2),
      Xup is X+1, Xdown is X-1, Yup is Y+1, Ydown is Y-1,
      find_exit(Xup, Y, [[X,Y]|List]),
      find_exit(Xdown, Y, [[X,Y]|List]),
      find_exit(X, Yup, [[X,Y]|List]),
      find_exit(X, Ydown, [[X,Y]|List]).
%------------------------------------------------------------------------------------------
% press button takes 4 args: num buttons left, x coordinate, and y coordinate,
  %current button Id to be pressed(starts at 1)
% if no buttons left, call find_goal to go from current x, y towards the goal
press_button(0, X, Y, _, List) :-
  % write('found all buttons'), nl,
  retractall(visited(_,_)),
  find_exit(X, Y, List).
press_button(N, X, Y, Id, List) :-
  info(Xmax, Ymax, _),
  %if out of bounds, or if we've visited here, or if this is a wall, return.
  (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    % write('out: '), print_coor(X,Y), nl %debug
    write('')
    ; asserta(visited(X, Y)),
      % print_coor(X,Y),
      % write('hey2'), nl,
      %if this is the next button to press, do so, clear visited, and recurse
      button(X, Y, Id) ->
      Num_Left is N - 1,
      retractall(visited(_,_)),
      press_button(Num_left, X, Y, succ(Id), List)
        %else, recurse to all nearby areas
      ; Xup is X+1, Xdown is X-1, Yup is Y+1, Ydown is Y-1,
        press_button(N, Xup, Y, Id, [[X,Y]|List]),
        press_button(N, Xdown, Y, Id, [[X,Y]|List]),
        press_button(N, X, Yup, Id, [[X,Y]|List]),
        press_button(N, X, Ydown, Id, [[X,Y]|List]).
%--------------------------------------------------------------------------------------
print_coor(X, Y) :-
  write([X,Y]), nl. %TODO print to file, not console

main :-
  %call press_button. num_buttons to begin with, the X and Y coordinates, and the
  %current button ID to be pressed (starts at 1).
  start(X,Y),
  num_buttons(N),
  press_button(N, X, Y, 1, []),
  retractall(visited(_,_)).
