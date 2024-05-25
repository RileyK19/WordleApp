//
//  UI.swift
//  WordleApp
//
//  Created by Riley Koo on 5/25/24.
//

import SwiftUI
struct GameView: View {
    @State var game: game
    @State var curWord: String = ""
    
    let kbRows = ["qwertyuiop", "asdfghjkl", "]zxcvbnm["]
    
    @State var green = ""
    @State var yellow = ""
    @State var gray = ""
    
    @State var kbActivate = false
    var body: some View {
        if game.guesses.count < 6 {
            wordleView
        } else {
            Text("Answer: \(game.answerWord.uppercased())")
            Spacer()
                .frame(height: 25)
            Button {
                game.reset()
                green = ""
                yellow = ""
                gray = ""
                curWord = ""
            } label: {
                Text("Restart")
            }
        }
    }
    var wordleView: some View {
        VStack {
            Text("Wordle")
                .font(.title.bold())
            ForEach(Array(0..<game.guesses.count), id: \.self) { x in
                let row = game.guesses[x]
                HStack {
                    ForEach(Array(0..<row.guessWord.count), id: \.self) { y in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(row.answerWord[y] == row.guessWord[y] ? .green : (row.answerWord.contains(row.guessWord[y]) ? .yellow : .gray))
                            Text("\(row.guessWord[y].uppercased())")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }
            }
            HStack {
                Spacer()
                Button {
                    kbActivate = true
                } label: {
                    ForEach(Array(0..<5), id: \.self) { y in
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .frame(width: 50, height: 50)
                                .foregroundStyle(.gray)
                            Text("\(curWord[y].uppercased())")
                                .foregroundStyle(.white)
                                .bold()
                        }
                    }
                }
                Spacer()
            }
            Spacer()
            if kbActivate {
                
                VStack {
                    ForEach(Array(0..<kbRows.count), id:\.self) { y in
                        let row1 = kbRows[y]
                        HStack {
                            ForEach(Array(0..<row1.count), id:\.self) { x in
                                if row1[x] == "[" {
                                    Button {
                                        curWord = strRemove(curWord, indx: curWord.count - 1)
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 30, height: 50)
                                                .foregroundStyle(.gray)
                                            Text("⌫")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    }
                                } else if row1[x] == "]" {
                                    Button {
                                        if String(row1[x]) == "]" && isReal(word: curWord) && !game.guesses.contains(where: { guess in
                                            guess.guessWord == curWord
                                        }) {
                                            game.submit(curWord)
                                            curWord = ""
                                        }
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 30, height: 50)
                                                .foregroundStyle(.gray)
                                            Text("↵")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    }
                                } else {
                                    Button {
                                        curWord += row1[x]
                                    } label: {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 30, height: 50)
                                                .foregroundStyle(
                                                    green.contains(row1[x]) ? .green :
                                                    yellow.contains(row1[x]) ? .yellow :
                                                    gray.contains(row1[x]) ? .red :
                                                    .gray
                                                )
                                            Text("\(row1[x].uppercased())")
                                                .foregroundStyle(.white)
                                                .bold()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
            Spacer()
                .frame(height: 10)
        }
        .onChange(of: game.guesses) { _, _ in
            green = game.green()
            yellow = game.yellow()
            gray = game.gray()
        }
    }
    func strRemove(_ str: String, indx: Int) -> String {
        var ret = ""
        for x in 0..<str.count {
            if x != indx {
                ret += str[x]
            }
        }
        return ret
    }
}

extension String {
    //https://stackoverflow.com/questions/24092884/get-nth-character-of-a-string-in-swift
    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
