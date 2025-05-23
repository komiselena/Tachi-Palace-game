//
//  AchievementsView.swift
//  Tachi Palace game
//
//  Created by Mac on 20.05.2025.
//

import SwiftUI

struct AchievementsView: View {
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
//                        .padding(.horizontal,20)
                        
                        Text("Achievements")
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

                            VStack(spacing: 15){
                                Image("ach1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Rubin Raider")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    HStack{
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)
                                        
                                        Text("10")
                                            .foregroundStyle(.white)
                                            .font(.callout)



                                    }
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)

                                }
                                .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)

                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("ach2")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Labyrinth Completion")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    HStack{
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)
                                        
                                        Text("10")
                                            .foregroundStyle(.white)
                                            .font(.callout)



                                    }
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)

                                }
                                .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("ach3")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("100 Coins per Game")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    HStack{
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)
                                        
                                        Text("10")
                                            .foregroundStyle(.white)
                                            .font(.callout)



                                    }
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)

                                }
                                .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    
                                
                            }
                        }
                        .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                        ZStack{
                            RoundedRectangle(cornerRadius: 20)
                                .tint(.black)
                                .opacity(0.2)
                                .frame(width: g.size.width * 0.25, height: g.size.height * 0.7)
                            VStack(spacing: 15){
                                Image("ach4")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: g.size.width * 0.17, height: g.size.width * 0.17)
                                    .clipped()
                                    .cornerRadius(15)
                                Text("Undying Phantom")
                                    .foregroundStyle(.white)
                                    .font(.headline)

                                ZStack{
                                    RoundedRectangle(cornerRadius: 18)
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    HStack{
                                Image("coin")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)
                                        
                                        Text("10")
                                            .foregroundStyle(.white)
                                            .font(.callout)



                                    }
                                    .frame(width: g.size.width * 0.15, height: g.size.height * 0.1)

                                }
                                .frame(width: g.size.width * 0.2, height: g.size.height * 0.1)

                                    
                                
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
