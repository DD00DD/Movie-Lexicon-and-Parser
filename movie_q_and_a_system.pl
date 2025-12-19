% for selecting hte current year
currentYear(1975).

% import movie database
:- [movie_kb].

% lexicon_and_helpers

% --- Helpers ---
% q2a --- Movies ---
movie(Name) :-
    releaseInfo(Name, _, _).

% --- Actors ---
actor(X) :-
    actedIn(X, _, _).

% --- Directors ---
director(X) :-
    directedBy(_, X).

% --- Characters ---
character(X) :-
    actedIn(_, _, X).

% --- Genres ---
genre(X) :-
    movieGenre(_, X).

% --- Release Years ---
releaseYear(X) :-
    releaseInfo(_, X, _).

% --- Movie Lengths ---
movieLength(X) :-
    releaseInfo(_, _, X).

% q2b--- New Director ---
newDirector(Name) :-
    currentYear(Y),
    directedBy(Movie, Name),
    releaseInfo(Movie, Y, _),      
    not((
        directedBy(OldMovie, Name),
        releaseInfo(OldMovie, OldYear, _),
        OldYear < Y
    )).

% q2c --- New Actor ---
newActor(Name) :-
    currentYear(Y),
    actedIn(Name, Movie, _),
    releaseInfo(Movie, Y, _),      
    not((
        actedIn(Name, OldMovie, _),
        releaseInfo(OldMovie, OldYear, _),
        OldYear < Y
    )).

% q2d --- Genre Director ---
genreDirector(Name, Genre) :-
   directedBy(Movie1, Name),
   movieGenre(Movie1, Genre),
   directedBy(Movie2, Name),
   movieGenre(Movie2, Genre),
   not(Movie1 = Movie2).

% q2e --- Genre Actor ---
genreActor(Name, Genre) :-
   actedIn(Name, Movie1, _),
   movieGenre(Movie1, Genre),
   actedIn(Name, Movie2, _),
   movieGenre(Movie2, Genre),
   not(Movie1 = Movie2).


% q3 --- Lexicon ---
article(a).
article(an).
article(the).
article(any).

common_noun(movie, X) :- movie(X).
common_noun(film, X) :- movie(X).
common_noun(actor, X) :- actor(X).
common_noun(director, X) :- director(X).
common_noun(character, X) :- character(X).
common_noun(length, X) :- movieLength(X).
common_noun(running_time, X) :- movieLength(X).
common_noun(genre, X) :- genre(X).
common_noun(release_year, X) :- releaseYear(X).

adjective(three_hour, X) :- releaseInfo(X, _, Y), Y >= 180.
adjective(short, X) :- releaseInfo(X, _, Y), Y < 60.

adjective(new, X) :- currentYear(Y), releaseInfo(X, Y, _).
adjective(new, X) :- newActor(X).
adjective(new, X) :- newDirector(X).

adjective(Genre, Movie) :- movieGenre(Movie, Genre). 
adjective(Genre, Director) :- genreDirector(Director, Genre).
adjective(Genre, Actor) :- genreActor(Actor, Genre).

adjective(Name, Movie):- actedIn(Name, Movie, _).
adjective(Name, Movie):- directedBy(Movie, Name).

proper_noun(W) :- movie(W).
proper_noun(W) :- actor(W).
proper_noun(W) :- director(W).
proper_noun(W) :- character(W).
proper_noun(W) :- number(W).

%proper_noun(W) :- not movie(W), not actor(W), not director(W), not character(W), not number(W).

% need to check if this works
preposition(by, X, Y) :- movie(X), directedBy(X, Y).

% this should work (also double check if all preposition works)
preposition(with, X, Y) :- actor(Y), actedIn(Y, X, _).
preposition(with, X, Y) :- character(Y), actedIn(_, X, Y).

preposition(in, X, Y) :- actedIn(X, Y, _).
preposition(in, X, Y) :- actedIn(_, Y, X).

preposition(from, X, Y) :- releaseInfo(X, Y, _).

preposition(released_in, X, Y) :- releaseYear(Y), releaseInfo(X, Y, _).

preposition(played_by, X, Y) :- actedIn(Y, _, X).

preposition(of, X, Y) :- releaseYear(X), releaseInfo(Y, X, _).
preposition(of, X, Y) :- movieLength(X), releaseInfo(Y, _, X).
preposition(of, X, Y) :- movieGenre(Y, X).

% parser import
% :- [original_parser].
:- [q5_parser].




what(Words, Ref) :- is_list(Words), np(Words, Ref).

% Allows for queries like 'what("the steven_spielberg movie from 2022", X)'
what(WordsString, Ref) :- string(WordsString),
   atom_list_from_string(WordsString, Words), what(Words, Ref).

% Convers a list of strings to a list of atoms
strings_to_atoms([], []).
strings_to_atoms([String | RestStrings], [Atom | RestAtoms]) :-
   atom_string(Atom, String), strings_to_atoms(RestStrings, RestAtoms).

% Takes in a string where words are separated by spaces, and finds a list
% of atoms corresponding to that string.
% ie. " hello    world how are  you   " becomes [hello, world, how, are, you]
atom_list_from_string(WordsString, AtomList) :-
   split_string(WordsString, " ", " ", WordList), strings_to_atoms(WordList, AtomList).
   



