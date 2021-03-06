 //
//  ContentView.swift
//  project5
//
//  Created by Sc0tt on 23/02/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    @State private var playerScore = 0
    
    var body: some View {
        NavigationView {
            VStack (alignment: .leading) {
                
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
        
                
                List(usedWords, id: \.self) { word in
                    HStack {
                        Image(systemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                
                Text("Score: \(playerScore)")
                    .font(.headline)
                    .padding()
            }
         
        .navigationBarTitle(rootWord)
        .navigationBarItems(leading: Button("New Game") {
            self.startGame()
        })
        .onAppear(perform: startGame)
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("Okay")))
            }
        }
    }

     func addNewWord() {
        let answer = newWord.lowercased()
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isShort(word: answer) else { wordError(title: "Word Too Short", message: "Sorry, but that word is too short!")
            return
        }
        
        guard isOriginal(word: answer) else { wordError(title: "Word Used Already", message: "Be more original!")
            return
        }
        
        guard isPossible(word: answer) else { wordError(title: "Word Not Recognised", message: "You can't make '\(answer)' from '\(rootWord)'")
            return
        }
        
        guard isReal(word: answer) else { wordError(title: "Word Not Possible", message: "That isn't a real word!")
            return
        }
        
        
        playerScore += answer.count * 1
        usedWords.insert(answer, at: 0)
        newWord = ""
     }
    
    func startGame() {
        usedWords.removeAll()
        playerScore = 0
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                return
            }
        }
        fatalError("Could not load start.txt from bundle")
    }
    
    func isOriginal(word: String) -> Bool {
        if word == rootWord {
            return false
        }
        
        return !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func isShort(word: String) -> Bool {
        if word.count < 3 {
            return false
        } else {
            return true
        }
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        
        showingError = true
    }
    
 }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
