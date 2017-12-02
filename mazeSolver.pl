:- use_module(mazeInfo, [info/3, wall/2, button/3, num_buttons/1, start/2, goal/2]).

:- dynamic(visited/2). %declare dynamic so these facts can be changed.
visited(-1,-1). %seemed to require one arbitrary inital value in visited.


%------------------------------------------------------------------------------
%print methods. note these are intended for 2D lists of corrdinates (ints)

%prints the list to the given file
print_list(_File,[]) :- !.
print_list(File, [[X,Y]|Tail]) :-
  write(File, [X,Y]),
  write(File, '\n'),
  print_list(File, Tail).

%opens a file and calls print_list to output the list to that file
write_list(Filename, List) :-
  open(Filename, write, File),
  print_list(File, List),
  close(File).

%prints the list to the terminal
print_list_to_console([]).
print_list_to_console([[X,Y]|T]) :-
  write([X,Y]), nl,
  print_list_to_console(T).

%----------------------------------------------------------------------------
find_exit(X, Y, List) :-
  goal(EndX, EndY),
  (X=:=EndX, Y =:=EndY) ->
    %reverse the list so it prints in the right direction
    reverse([[X,Y]|List], List2),
    write_list('path-solution.txt',List2)
  ; %else, not done
    info(Xmax, Ymax, _),
    %if this is an invalid spot, do nothing.
    (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    write('')
    ; %else, add this coordinate to visited and continue looking for the exit
      asserta(visited(X, Y)),
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
  %all done, so clear visited and then find the exit
  retractall(visited(_,_)),
  find_exit(X, Y, List).

press_button(N, X, Y, Id, List) :-
  info(Xmax, Ymax, _),
  %if out of bounds, or if we've visited here, or if this is a wall, return.
  (X>=Xmax; X<0; Y>=Ymax; Y<0; visited(X,Y); wall(X,Y)) ->
    write('')
    ; asserta(visited(X, Y)),
      %if this is the next button to press, do so, clear visited, and recurse
      button(X, Y, Id) ->
      retractall(visited(_,_)),
      Left is N - 1,
      press_button(Left, X, Y, succ(Id), List)

      ;  %else, recurse to all nearby areas
        Xup is X+1, Xdown is X-1, Yup is Y+1, Ydown is Y-1,
        press_button(N, Xdown, Y, Id, [[X,Y]|List]),
        press_button(N, Xup, Y, Id, [[X,Y]|List]),
        press_button(N, X, Ydown, Id, [[X,Y]|List]),
        press_button(N, X, Yup, Id, [[X,Y]|List]).
%--------------------------------------------------------------------------------------
%debug method to print a coordinate
print_coor(X, Y) :-
  write([X,Y]), nl. %TODO print to file, not console
%--------------------------------------------------------------------------
main :-
  %call press_button with N as num_buttons to begin with, the X and Y coordinates, and the
  %current button ID to be pressed (starts at 1), and an empty list (which is printed at the end)
  start(X,Y),
  num_buttons(N),
  press_button(N, X, Y, 1, []),
  retractall(visited(_,_)). %just in case, clear visited for subsequent runs in case it isn't recompiled.
