:- consult('prolog/wn_s.pl').
:- use_module(library(clpfd)).

% five_letter_words gives all words in WordNet that are 5 characters long
five_letter_words(X) :- s(_, _, X, _, _, _), string_length(X, 5).

% green takes a letter and the corresponding index to the letter
% this is a letter you KNOW is in the word at that particular index
% green gives all 5 letter words that contain that letter at that particular index
green(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, Index, 1, _, Letter1), Letter1 == Letter.

% yellow(Letter, Index, Word) is true if the Word contains the letter but not at that index
yellow(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, _, 1, _, Letter), not(sub_string(Word, Index, 1, _, Letter)).

% notcontain takes a list of letters and returns all the five-letter words that 
% do not contain those letters at any position. these are letters we
% know don't appear in any position in the word.
notcontain(Letters,Word) :- five_letter_words(Word), forall(member(Letter,Letters),not(sub_string(Word, _, 1, _, Letter))).

% query that combines all of the above
% solve takes a list of letters, list of indices, list of types (0 = green, 1 = yellow, 2 = notcontain)
solve([], [], [], Word) :- five_letter_words(Word).
solve([Letter | Letters], [Index | Indices], [0 | Types], Word) :- green(Letter, Index, Word), solve(Letters, Indices, Types, Word).
solve([Letter | Letters], [Index | Indices], [1 | Types], Word) :- yellow(Letter, Index, Word), solve(Letters, Indices, Types, Word).
% solve([Letter | Letters], [Index | Indices], [2 | Types], Word) :- notcontain(Letter, Word), solve(Letters, Indices, Types, Word).