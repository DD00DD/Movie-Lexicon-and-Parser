np([Name], Name) :- proper_noun(Name).
np([Art | Rest], What) :- article(Art), np2(Rest, What).

% Handling Oldest keyword 
np2([oldest | Rest], What) :-
    findOldestCandidate(Rest, What).

np2([Adj | Rest], What) :-
    adjective(Adj, What),
    np2(Rest, What).

np2([Noun | Rest], What) :-
    common_noun(Noun, What),
    mods(Rest, What).

mods([], _).

mods(Words, What) :-
    append(Start, End, Words),
    prepPhrase(Start, What),
    mods(End, What).

/* Part A: Handling Between X and Y */
prepPhrase([Prep | Rest], What) :-
    preposition(Prep, What, Ref),
    np(Rest, Ref).

% "with a Attr" pattern match. 
prepPhrase([with, a, Attr, between, X, and, Y], What) :-
    getAttribute(Attr, What, V),
    compareBetween(V, X, Y).

% "with Attr" pattern match, no a.  
prepPhrase([with, Attr, between, X, and, Y], What) :-
    getAttribute(Attr, What, V),
    compareBetween(V, X, Y).

/* Helpers */
getAttribute(release_year, Movie, Year) :-
    releaseInfo(Movie, Year, _). 

getAttribute(length, Movie, Length) :-
    releaseInfo(Movie, _, Length).

% Exclusive Comparison.
compareBetween(V, X, Y) :-
    findType(X, VX), % x either x, date, len. 
    findType(Y, VY), % y either y, date, len. 
    VX < V, 
    V < VY.

% 
findType(X, V) :- number(X), V is X.     % as x.
findType(X, V) :- releaseInfo(X, V, _).  % as date.
findType(X, V) :- releaseInfo(X, _, V).  % as len. 

/* Part B: Handling "Oldest" Keyword  */
findOldestCandidate(Rest, Movie) :-
    np2(Rest, Movie),
    releaseInfo(Movie, Year, _),
    not((
        np2(Rest, Other),
        releaseInfo(Other, OtherYear, _),
        OtherYear < Year
    )).
