:- consult('prolog/wn_s.pl').
:- use_module(library(clpfd)).

% five_letter_words gives all words in WordNet that are 5 characters long
five_letter_words(X) :- s(_, _, X, _, _, _), string_length(X, 5).

% green takes a letter and the corresponding index to the letter
% this is a letter you KNOW is in the word at that particular index
% green gives all 5 letter words that contain that letter at that particular index
green(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, Index, 1, _, Letter1), Letter1 == Letter.