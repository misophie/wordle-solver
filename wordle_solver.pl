:- consult('prolog/wn_s.pl').
:- use_module(library(clpfd)).

five_letter_words(X) :- s(_, _, X, _, _, _), string_length(X, 5).

green(Letter, Index, Word) :- five_letter_words(Word), sub_string(Word, Index, 1, _, Letter1), Letter1 == Letter.