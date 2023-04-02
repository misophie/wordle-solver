:- consult('prolog/wn_s.pl').
:- use_module(library(clpfd)).

% five_letter_words gives all words in WordNet that are 5 characters long
five_letter_words(X) :- s(_, _, X, _, _, _), string_length(X, 5).

% green takes a letter and the corresponding index to the letter
% this is a letter you KNOW is in the word at that particular index
% green gives all 5 letter words that contain that letter at that particular index
green(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, Index, 1, _, Letter1), Letter1 == Letter.

% notcontain takes a list of letters and returns all the five-letter words that 
% do not contain those letters at any position. these are letters we
% know don't appear in any position in the word.
notcontain(Letters,Word) :- five_letter_words(Word), forall(member(Letter,Letters),not(sub_string(Word, _, 1, _, Letter))).

% yellow(Letter, Index, Word) is true if the Word contains the letter but not at that index
yellow(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, _, 1, _, Letter), not(sub_string(Word, Index, 1, _, Letter)).