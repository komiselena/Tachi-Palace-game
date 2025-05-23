//
//  MiniGamesView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI

struct MiniGamesView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        
                        Text("Mini Games")
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

                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                            VStack(alignment: .center, spacing: 8){
                                Image("theNumber")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                VStack(spacing: 0){
                                    Text("Guess")
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                    Text("The Number")
                                        .foregroundStyle(.white)
                                        .font(.headline)
                                }


                                    NavigationLink {
                                        GuessNumberView(gameData: gameData, gameViewModel: gameViewModel)
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 12)
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.16, height: g.size.height * 0.1)
                                            Text("Play")
                                                .foregroundStyle(.white)
                                                .font(.headline.weight(.semibold))

                                    }

                                }

                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("findAPair")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Find A Pair")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                NavigationLink {
                                    MemoryGameView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.16, height: g.size.height * 0.1)
                                        Text("Play")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.semibold))

                                }

                            }

                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("memoryAid")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Memory Aid")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                NavigationLink {
                                    MemorySequnceGameView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.16, height: g.size.height * 0.1)
                                        Text("Play")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.semibold))

                                }

                            }

                                    
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("Labyrinth")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Labyrinth")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                NavigationLink {
                                    MazeView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 12)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.16, height: g.size.height * 0.1)
                                        Text("Play")
                                            .foregroundStyle(.white)
                                            .font(.headline.weight(.semibold))

                                }

                            }


                                    
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                    }

                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

            }
            .frame(width: g.size.width, height: g.size.height)

        }
        .navigationBarBackButtonHidden()
    }
}
