:- consult('prolog/wn_s.pl').
:- use_module(library(clpfd)).

% - read inputs?
% - finish wiki site

% five_letter_words gives all words in WordNet that are 5 characters long
five_letter_words(X) :- s(_, _, X, _, _, _), string_length(X, 5).

% green takes a letter and the corresponding index to the letter
% this is a letter you KNOW is in the word at that particular index
% green gives all 5 letter words that contain that letter at that particular index
green(Letter, Index, Word) :- sub_string(Word, Index, 1, _, Letter1), Letter1 == Letter.

% yellow(Letter, Index, Word) is true if the Word contains the letter but not at that index
yellow(Letter, Index, Word) :- sub_string(Word, _, 1, _, Letter), not(sub_string(Word, Index, 1, _, Letter)).

% notcontain takes a letter and returns all the five-letter words that 
% do not contain that letter at any position. this is a letter we
% know don't appear in any position in the word.
notcontain(Letter, Word) :- not(sub_string(Word, _, 1, _, Letter)).

% notcontain takes a list of letters and returns all the five-letter words that 
% do not contain those letters at any position. these are letters we
% know don't appear in any position in the word.
% notcontain(Letters,Word) :- forall(member(Letter,Letters),not(sub_string(Word, _, 1, _, Letter))).

% query that combines all of the above
% solve takes a list of letters, list of indices, list of types (-1 = initialize, 0 = green, 1 = yellow, 2 = notcontain)
% solve NEEDS to start with initialize for it to work

% we did it this way because five_letter_words can't be used as the base case 
% (green, yellow, notcontain will not work without instantiated words from five_letter_words)
% and five_letter_words cannot be used within green, yellow, or notcontain or else they will generate the same words
% each time each query is called

solve([], [], [], Word).
solve([Letter | Letters], [Index | Indices], [-1 | Types], Word) :- five_letter_words(Word), solve(Letters, Indices, Types, Word).
solve([Letter | Letters], [Index | Indices], [0 | Types], Word) :- green(Letter, Index, Word), solve(Letters, Indices, Types, Word).
solve([Letter | Letters], [Index | Indices], [1 | Types], Word) :- yellow(Letter, Index, Word), solve(Letters, Indices, Types, Word).
solve([Letter | Letters], [Index | Indices], [2 | Types], Word) :- notcontain(Letter, Word), solve(Letters, Indices, Types, Word).

q(Ans) :- 
    write("Have you guessed a word yet? (y/n) "), flush_output(current_output),
    read_line_to_string(user_input, Ans),
    q1(Ans).
q(Ans) :-
    write("No more answers\n Call q(Ans) to go again."). % try to use a y/n option for continuing

q1("n") :-
    solve([x], [0], [-1], Word), flush_output(current_output),
    write("\n\n Try the word: "),
    write(Word).

q1("y") :-
    write("\nWhat are the letters you have currently guessed?: "), flush_output(current_output), 
    read_line_to_string(user_input, Letters), 
    split_string(Letters, ",", " ", Lts), % ignore punctuation
    write("What was the type of each letter? Type: \n 0 -> Green \n 1 -> Yellow \n 2 -> Grey/Word does not contain the letter\n"),
    read_line_to_string(user_input, Types),
    split_string(Types, ",", " ", Tys),
    maplist(number_string, Typenos, Tys), % convert list of substrings to list of atoms (int?)
    write("\nAdd the index of each letter in your guess: "),
    read_line_to_string(user_input, Id),
    split_string(Id, ",", " ", Indices),
    maplist(number_string, Indexnos, Indices),
    solve([x|Lts], [0|Indexnos], [-1|Typenos], Word),
    write("\n \n Try the word: "),
    write(Word).