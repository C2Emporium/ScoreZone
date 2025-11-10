//
//  GameViews.swift
//  ScoreZone
//
//  Created by Taylor Wush on 10/23/25.
//
import SwiftUI
import WebKit
import AVFoundation
import AudioToolbox

// MARK: - GameView avec quiz avancé
struct GameView: View {
   @State private var currentQuestion = 0
   @State private var score = 0
   @State private var showResult = false
   @State private var selectedAnswer: Int? = nil

   @State private var quizQuestions: [Question] = []

   struct Question: Identifiable {
       let id = UUID()
       let question: String
       let options: [String]
       let correctIndex: Int
   }

    
    // Base de questions (ajouter plus de 100 questions ici)
    let allQuestions: [Question] = [
        Question(question: "Which team won the 2022 FIFA World Cup?", options: ["France", "Argentina", "Brazil", "Germany"], correctIndex: 1),
                Question(question: "Cristiano Ronaldo plays for which club in 2025?", options: ["Al Nassr", "Manchester United", "Juventus", "PSG"], correctIndex: 0),
                Question(question: "Which country is known as La Roja in football?", options: ["Spain", "Chile", "Mexico", "Portugal"], correctIndex: 0),
                Question(question: "Who won Ballon d'Or 2023?", options: ["Messi", "Ronaldo", "Mbappe", "De Bruyne"], correctIndex: 2),
                Question(question: "Which country hosted the 2022 FIFA World Cup?", options: ["Qatar", "USA", "Brazil", "Russia"], correctIndex: 0),
                Question(question: "Which team has the most Champions League titles?", options: ["Real Madrid", "AC Milan", "Liverpool", "Barcelona"], correctIndex: 0),
                Question(question: "Who is the top scorer of all time?", options: ["Messi", "Ronaldo", "Pele", "Neymar"], correctIndex: 1),
                Question(question: "Which club won EPL 2022-2023?", options: ["Man City", "Liverpool", "Chelsea", "Arsenal"], correctIndex: 0),
                Question(question: "Which country won Euro 2020?", options: ["Italy", "England", "Spain", "France"], correctIndex: 0),
                Question(question: "Who scored the winning goal in 2022 World Cup final?", options: ["Mbappe", "Messi", "Di Maria", "Hernandez"], correctIndex: 1),
                Question(question: "Which player is known as CR7?", options: ["Messi", "Ronaldo", "Neymar", "Mbappe"], correctIndex: 1),
                Question(question: "Which country is known as Azzurri?", options: ["Italy", "France", "Germany", "Spain"], correctIndex: 0),
                Question(question: "Who won FIFA Best Player 2023?", options: ["Messi", "Mbappe", "Ronaldo", "De Bruyne"], correctIndex: 1),
                Question(question: "Which team won La Liga 2022-23?", options: ["Barcelona", "Real Madrid", "Atletico Madrid", "Sevilla"], correctIndex: 1),
                Question(question: "Which country won Copa America 2021?", options: ["Argentina", "Brazil", "Chile", "Colombia"], correctIndex: 0),
                Question(question: "Who is PSG's star forward 2025?", options: ["Messi", "Mbappe", "Neymar", "Ronaldo"], correctIndex: 1),
                Question(question: "Which team won Serie A 2022-23?", options: ["Juventus", "Napoli", "Inter", "AC Milan"], correctIndex: 1),
                Question(question: "Which player is top scorer EPL 2023?", options: ["Haaland", "Kane", "Salah", "Son"], correctIndex: 0),
                Question(question: "Which team is known as Red Devils?", options: ["Manchester United", "Liverpool", "Arsenal", "Chelsea"], correctIndex: 0),
                Question(question: "Which country hosted World Cup 2018?", options: ["Russia", "Qatar", "Germany", "Brazil"], correctIndex: 0),
        // … ajouter d'autres questions ici pour atteindre 100+
    ]
    
    var body: some View {
           VStack(spacing: 20) {
               Text("Quiz Game 🎯")
                   .font(.largeTitle)
                   .bold()
                   .foregroundColor(.green)

               if !quizQuestions.isEmpty && currentQuestion < quizQuestions.count {
                   VStack(spacing: 16) {
                       Text("Question \(currentQuestion + 1)/\(quizQuestions.count)")
                           .font(.headline)
                           .foregroundColor(.secondary)

                       Text(quizQuestions[currentQuestion].question)
                           .font(.title3)
                           .multilineTextAlignment(.center)
                           .padding()
                           .frame(maxWidth: .infinity)
                           .background(Color.green.opacity(0.1))
                           .cornerRadius(12)

                       VStack(spacing: 12) {
                           ForEach(0..<quizQuestions[currentQuestion].options.count, id: \.self) { index in
                               Button(action: { answerTapped(index) }) {
                                   HStack {
                                       Text(quizQuestions[currentQuestion].options[index])
                                           .foregroundColor(selectedAnswer == index ? .white : .primary)
                                           .padding()
                                       Spacer()
                                   }
                                   .background(
                                       selectedAnswer == index ?
                                       (index == quizQuestions[currentQuestion].correctIndex ? Color.green : Color.red) :
                                       Color(.systemGray5)
                                   )
                                   .cornerRadius(8)
                               }
                               .disabled(selectedAnswer != nil)
                           }
                       }

                       if selectedAnswer != nil {
                           Button("Next Question") {
                               if currentQuestion + 1 < quizQuestions.count {
                                   currentQuestion += 1
                                   selectedAnswer = nil
                               } else {
                                   showResult = true
                               }
                           }
                           .buttonStyle(.borderedProminent)
                           .tint(.green)
                       }
                   }
                   .padding()
               }

               Spacer()

               Text("Score: \(score)")
                   .font(.headline)
                   .padding()
           }
           .padding()
           .onAppear { startQuiz() }
           .alert("Quiz Finished", isPresented: $showResult) {
               Button("Restart", action: startQuiz)
           } message: {
               Text("Your score: \(score)/\(quizQuestions.count)")
           }
       }

    
    // MARK: - Fonctions
    func startQuiz() {
        score = 0
        currentQuestion = 0
        selectedAnswer = nil
        quizQuestions = Array(allQuestions.shuffled().prefix(5)) // 5 questions aléatoires
    }
    
    func answerTapped(_ index: Int) {
        selectedAnswer = index
        
        let question = quizQuestions[currentQuestion]
        
        #if !targetEnvironment(simulator)
        if index == question.correctIndex {
            // ✅ Correct: son uniquement
            AudioServicesPlaySystemSound(SystemSoundID(1113))
        } else {
            // ❌ Wrong: vibration uniquement
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        #endif
        
        if index == question.correctIndex { score += 1 }
        
        // Passer à la question suivante après un court délai
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if currentQuestion + 1 < quizQuestions.count {
                currentQuestion += 1
                selectedAnswer = nil
            } else {
                showResult = true
            }
        }
    }
}
