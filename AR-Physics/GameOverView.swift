//
//  GameOverView.swift
//  AR-Physics
//
//  Created by Fatih Emre Sarman on 12.07.2024.
//

import SwiftUI

struct GameOverView: View {
    let currentScore: Int
    @Binding var highScores: [(String, Int)]
    @State private var playerName = ""
    var onRestart: () -> Void
    
    var body: some View {
        VStack {
            Text("Game Over")
                .font(.largeTitle)
                .padding()
            
            if currentScore > (highScores.last?.1 ?? 0) {
                Text("You made it to the top 10!")
                    .font(.headline)
                TextField("Enter your name", text: $playerName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Button("Save Score") {
                    saveScore()
                }
                .padding()
            } else {
                Text("Your Score: \(currentScore)")
                    .font(.headline)
            }
            
            Button("Restart") {
                onRestart()
            }
            .padding()
            
            List {
                Text("High Scores")
                    .font(.headline)
                ForEach(highScores, id: \.0) { score in
                    Text("\(score.0): \(score.1)")
                }
            }
        }
        .onAppear {
            highScores.sort { $0.1 > $1.1 }
        }
    }
    
    func saveScore() {
        highScores.append((playerName, currentScore))
        highScores.sort { $0.1 > $1.1 }
        if highScores.count > 10 {
            highScores.removeLast()
        }
        UserDefaults.standard.set(highScores, forKey: "highScores")
        onRestart()
    }
}
