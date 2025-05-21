//
//  GuessNumberView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct GuessNumberView: View {
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @StateObject private var game = GuessTheNumberGame()
    @ObservedObject var gameViewModel: GameViewModel
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                Image("BG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                    // Игровое поле
                    VStack(spacing: 10) {

                        HStack(spacing: 10) {
                            ForEach(0..<3, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: g.size.width * 0.25, height: g.size.width * 0.25)
                                    
                                    if index < game.guess.count {
                                        Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                            .font(.system(size: 40, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.width * 0.25)

                        // Подсказка
                        Group{
                            if !game.hint.isEmpty {
                                Text(game.hint)
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding()
                                    .animation(.easeInOut, value: game.hint)
                                
                            } else{
                                Text("")
                                
                            }
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.05)

                        
                        Spacer()
                        
                        // Цифровая клавиатура
                        VStack(spacing: 10) {
                            ForEach(0..<3, id: \.self) { row in
                                HStack(spacing: 10) {
                                    ForEach(1..<4, id: \.self) { col in
                                        let number = row * 3 + col
                                        Button {
                                            if game.guess.count < 3 && !game.isWon {
                                                game.guess += "\(number)"
                                                checkIfComplete()
                                            }
                                        } label: {
                                            Text("\(number)")
                                                .foregroundColor(.white)
                                                .font(.title.weight(.bold))
                                                .frame(width: g.size.width * 0.25, height: g.size.width * 0.17)
                                                .background(content: {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .fill(
                                                            LinearGradient(
                                                                gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                                startPoint: .leading,
                                                                endPoint: .trailing
                                                            )
                                                        )

                                                })
                                        }
                                    }
                                }
                            }
                            
                            // Последний ряд (только 0 по центру)
                            HStack(spacing: 10) {
                                Spacer()
                                    .frame(width: g.size.width * 0.25, height: g.size.width * 0.17)

                                Button {
                                    if game.guess.count < 3 && !game.isWon {
                                        game.guess += "0"
                                        checkIfComplete()
                                    }
                                } label: {
                                    Text("0")
                                        .foregroundColor(.white)
                                        .font(.title.weight(.bold))
                                        .frame(width: g.size.width * 0.25, height: g.size.width * 0.17)
                                        .background(content: {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )

                                        })
                                }
                                
                                Button {
                                    if !game.guess.isEmpty && !game.isWon {
                                        game.guess.removeLast()
                                    }
                                } label: {
                                    Image(systemName: "delete.left")
                                        .foregroundColor(.white)
                                        .font(.title.weight(.bold))
                                        .frame(width: g.size.width * 0.25, height: g.size.width * 0.17)
                                        .background(content: {
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )

                                        })
                                }
                            }
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height )

            .overlay {
                if game.isWon {
                    ZStack{
                        Color.black
                            .opacity(0.5)
                            .ignoresSafeArea()
                        ZStack{
                            RoundedRectangle(cornerRadius: 25)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.5)
                            VStack{
                                Text("You Win")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 34, weight: .bold))
                                    .padding()
                                Text("Your Score:")
                                    .foregroundStyle(.white)
                                    .font(.callout)
                                HStack{
                                    Text("20")
                                        .foregroundStyle(.white)
                                        .font(.system(size: 28, weight: .bold))
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.15, height: g.size.width * 0.15)
                                }
                                .frame(width: g.size.width * 0.5)
                                Button {
                                    dismiss()
                                } label: {
                                    ZStack{
                                        Capsule()
                                            .foregroundStyle(.white)
                                            .frame(width: g.size.width * 0.6, height: g.size.width * 0.15)
                                        Text("Claim")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 24, weight: .bold))
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            .frame(width: g.size.width * 0.7, height: g.size.height * 0.5)
                            
                        }
                    }
                }
            }
            .onChange(of: game.isWon) { newValue in
                if game.isWon == true{
                    gameData.addCoins(20)
                }
            }


        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button{ dismiss() } label: {
                    BackButton()
                }
            }
        })

        .navigationBarBackButtonHidden()
    }
    
    private func checkIfComplete() {
        if game.guess.count == 3 {
            game.checkGuess()
        }
    }
}
