go :- hypothesize(Problem),
      write('The problem is: '),
      write(Problem),
      nl,
      undo.

% hypotheses to be tested
% software problems
hypothesize(virus) :- virus, !. % the answer can either be true or not
hypothesize(broken_drivers) :- broken_drivers, !.
hypothesize(broken_os) :- broken_os, !.
% hardware problems
hypothesize(dead_cpu)     :- dead_cpu, !.
hypothesize(dead_netcard)   :- dead_netcard, !.
hypothesize(dead_ram) :- dead_ram, !.

hypothesize(unknown). % no diagnosis if all other conditions are not met

% problem identification rules
virus :-
          software,
          verify(frequent_ads),
          verify(broken_os),
          verify(bsod),
          verify(system_freezes).
broken_drivers :-
          software,
          verify(bsod),
          verify(software_incompatibility),
          verify(drivers_outdated),
          verify(system_freezes).
broken_os :-
          software,
          verify(infinite_os_loading),
          verify(no_internet),
          verify(crashes).
dead_cpu :-
          hardware,
          verify(power_but_black_screen),
          verify(system_glitches),
          verify(system_freezes).
dead_netcard :-
          hardware,
          verify(cant_connect_to_internet),
          verify(no_internet).
dead_ram :-
          hardware,
          verify(memory_errors),
          verify(corrupted_files),
          verify(system_freezes),
          verify(bsod).


% classification rules
software    :- verify(software_problem), !. % can be either true or not
hardware    :- verify(hardware_problem), !.



% question asking
ask(Question) :-
    write('Does the problem have the following attribute: '),
    write(Question),
    write('? '),
    read(Response),
    nl,
    ((Response == yes ; Response == y) -> assert(yes(Question)) ;
       assert(no(Question)), fail).

:- dynamic yes/1,no/1.

% Verification
verify(S) :-
   (yes(S)
    ->
    true ;
    (no(S)
     ->
     fail ;
     ask(S))).

% undo all yes/no assertions
undo :- write('Cleaning up and exiting...').
undo :- retract(yes(_)),fail.
undo :- retract(no(_)),fail.
undo.
