//
//  Logic.swift
//  WordleApp
//
//  Created by Riley Koo on 5/25/24.
//

import Foundation
import LoremSwiftum
import UIKit

class game {
    var answerWord: String
    var guesses: [guess]
    init() {
        answerWord = ""
        while answerWord.count != 5 {
            answerWord = Lorem.word
        }
        guesses = []
    }
    func submit(_ word: String) -> Bool {
        guesses.append(guess(answerWord: answerWord, guessWord: word))
        return word == answerWord
    }
    func green() -> String {
        var ret = ""
        for x in 0..<guesses.count {
            ret += guesses[x].green()
        }
        return ret
    }
    func yellow() -> String {
        var ret = ""
        for x in 0..<guesses.count {
            ret += guesses[x].yellow()
        }
        return ret
    }
    func gray() -> String {
        var ret = ""
        for x in 0..<guesses.count {
            ret += guesses[x].gray()
        }
        return ret
    }
    func reset() {
        answerWord = ""
        while answerWord.count != 5 {
            answerWord = Lorem.word
        }
        guesses = []

    }
}
struct guess: Equatable {
    var answerWord: String
    var guessWord: String
    func green() -> String {
        var ret = ""
        for x in 0..<guessWord.count {
            if answerWord[x] == guessWord[x] {
                ret += answerWord[x]
            }
        }
        return ret
    }
    func yellow() -> String {
        var ret = ""
        for x in 0..<guessWord.count {
            if answerWord.contains(guessWord[x]) && answerWord[x] != guessWord[x] {
                ret += guessWord[x]
            }
        }
        return ret
    }
    func gray() -> String {
        var ret = ""
        for x in 0..<guessWord.count {
            if !answerWord.contains(guessWord[x]) {
                ret += guessWord[x]
            }
        }
        return ret
    }
}

func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

    return misspelledRange.location == NSNotFound
}
