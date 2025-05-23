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
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                
                    // Игровое поле
                    VStack {
                        HStack(spacing: 0){
                            Button {
                                dismiss()
                            } label: {
                                BackButton()
                            }
                            
                            Text("Guess The Number")
                                .foregroundStyle(.white)
                                .font(.title2.weight(.bold))
                            Spacer()

                            ZStack{

                                Capsule()
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .frame(width: g.size.width * 0.16, height: g.size.width * 0.06)

                                HStack{
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)

                                    Text("\(gameData.coins)")
                                        .foregroundStyle(.white)
                                        .font(.title3)

                                }
                                .frame(width: g.size.width * 0.17, height: g.size.width * 0.06)

                            }
                        }
                        .frame(width: g.size.width , height: g.size.height * 0.1)
                        Spacer()

                        ZStack{
                            RoundedRectangle(cornerRadius: 18)
                                .foregroundStyle(.black)
                                .opacity(0.3)
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
                            
                            if game.isWon{
                                VStack(){
                                    Image("stars")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.4, height: g.size.height * 0.3)

                                    Text("You Win!")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                    HStack{
                                        Button {
                                            dismiss()
                                        } label: {
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "house")
                                                .font(.title)
                                                .foregroundStyle(.white)

                                        }

                                        Button {
                                            game.restart()
                                        } label: {
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "arrowtriangle.right.fill")
                                                .font(.title)
                                                .foregroundStyle(.white)

                                        }

                                    }
                                }
                                .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)

                            }else{
                                
                                VStack{
                                    HStack(spacing: 10) {
                                        ForEach(0..<3, id: \.self) { index in
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 20)
                                                    .foregroundStyle(.white)
                                                    .opacity(0.5)
                                                    .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                
                                                if index < game.guess.count {
                                                    Text(String(game.guess[game.guess.index(game.guess.startIndex, offsetBy: index)]))
                                                        .font(.system(size: 37, weight: .bold))
                                                        .foregroundColor(.black)
                                                }
                                            }
                                        }
                                    }
                                    .frame(width: g.size.width * 0.3, height: g.size.width * 0.07)
                                    Spacer()
                                    
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
                                    HStack(spacing: 10) {
                                        
                                        // Цифровая клавиатура
                                        VStack(spacing: 10) {
                                            ForEach(0..<2, id: \.self) { row in
                                                HStack(spacing: 10) {
                                                    ForEach(0..<5, id: \.self) { col in
                                                        let number = row * 5 + col
                                                        Button {
                                                            if game.guess.count < 5 && !game.isWon {
                                                                game.guess += "\(number)"
                                                                checkIfComplete()
                                                            }
                                                        } label: {
                                                            Text("\(number)")
                                                                .foregroundColor(.white)
                                                                .font(.title.weight(.bold))
                                                                .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                                .background(content: {
                                                                    RoundedRectangle(cornerRadius: 20)
                                                                        .foregroundStyle(.red)
                                                                    
                                                                })
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        
                                        // Последний ряд (только 0 по центру)
                                        
                                        Button {
                                            if !game.guess.isEmpty && !game.isWon {
                                                game.guess.removeLast()
                                            }
                                        } label: {
                                            Image(systemName: "delete.left")
                                                .foregroundColor(.white)
                                                .font(.title.weight(.bold))
                                                .frame(width: g.size.width * 0.07, height: g.size.width * 0.07)
                                                .background(content: {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .foregroundStyle(.red)
                                                    
                                                })
                                        }
                                    }
                                }
                                .frame(width: g.size.width * 0.6, height: g.size.height * 0.6)
                            }
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.6)

                    
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height )

            .onChange(of: game.isWon) { newValue in
                if game.isWon == true{
                    gameData.addCoins(20)
                }
            }

        }

        .navigationBarBackButtonHidden()
    }
    
    private func checkIfComplete() {
        if game.guess.count == 3 {
            game.checkGuess()
        }
    }
}
