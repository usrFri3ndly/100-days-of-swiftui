//
//  ContentView.swift
//  project2
//
//  Created by Sc0tt on 05/02/2020.
//  Copyright © 2020 Sc0tt. All rights reserved.
//

import SwiftUI

enum ActiveAlert {
    case correct, incorrect
}

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            // render original image pixels
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black
            , lineWidth: 1))
            .shadow(color: .black, radius: 2)
            
    }
}

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe back, middle stripe red, bottom stripe yellow.",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red.",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top stripe red, middle stripe yellow, bottom stripe red. Coat of arms on the middle stripe",
        "UK": "The flag for this country is the union jack.",
        "USA": "50 starts and 13 stripes."
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var playerGuess = 0
    @State private var playerCorrectGuess = false
    
    @State private var buttonOpacity = false
    
    @State private var score = 0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var activeAlert: ActiveAlert = .correct
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                        }
                    }) {
                        FlagImage(country: self.countries[number])
                        .accessability(label: Text(self.labels[self.countries[number]]))
                    }
                        
                    .rotation3DEffect(.degrees(self.playerCorrectGuess && self.playerGuess == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(Double(self.buttonOpacity && self.playerGuess != number ? 0.25 : 1))
                    //.scaleEffect(self.playerCorrectGuess && self.playerGuess == number ? 1 : 1)
                }
                Spacer()
                    .frame(height: 30)
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            switch activeAlert {
            case .correct:
                return Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                        self.askQuestion()
                    })
            case .incorrect:
                return Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                    self.askQuestion()
                })
            }
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            playerGuess = number
            playerCorrectGuess = true
            buttonOpacity = true
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(score)"
            self.activeAlert = .correct
        } else {
            scoreTitle = "Incorrect"
            scoreMessage = "Thats the flag of \(countries[number])\n Your score is \(score)"
            self.activeAlert = .incorrect
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        self.playerCorrectGuess = false
        buttonOpacity = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

