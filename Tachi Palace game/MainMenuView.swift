//
//  MainMenuView.swift
//  NewCastle Game
//
//  Created by Mac on 16.05.2025.
//

import SwiftUI

struct MainMenuView: View {
    @StateObject private var gameData = GameData()
    @StateObject private var gameViewModel = GameViewModel()
    @State private var selectedTab: Int = 0
    
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                GeometryReader { g in
                    ZStack(alignment: .bottom) {
                        Image("bg")
                            .resizable()
                            .ignoresSafeArea()
                        VStack{
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: g.size.width * 0.45, height: g.size.width * 0.45)
                            Spacer()
                            HStack{
                                NavigationLink {
                                    MiniGamesView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 18)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.15)
                                        Text("Mini Games")
                                            .foregroundStyle(.white)
                                            .font(.title3.weight(.bold))
                                    }
                                }
                                Spacer()
                                NavigationLink {
                                    ShopView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 18)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.15)
                                        Text("Shop")
                                            .foregroundStyle(.white)
                                            .font(.title3.weight(.bold))
                                    }

                                }
                                Spacer()
                                NavigationLink {
                                    AchievementsView(gameData: gameData, gameViewModel: gameViewModel)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 18)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.15)
                                        Text("Achievements")
                                            .foregroundStyle(.white)
                                            .font(.title3.weight(.bold))
                                    }

                                }
                                Spacer()
                                NavigationLink {
                                    GameContainerView(gameViewModel: gameViewModel, gameData: gameData)
                                } label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 18)
                                            .foregroundStyle(.red)
                                            .frame(width: g.size.width * 0.2, height: g.size.height * 0.15)
                                        Text("Play Game")
                                            .foregroundStyle(.white)
                                            .font(.title3.weight(.bold))
                                    }

                                }

                            }
                            .frame(width: g.size.width * 0.9, height: g.size.height * 0.1)
                            .padding(.bottom, g.size.height * 0.3)
                            Spacer()
                        }
                        .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)

                    }
                    .overlay (
                        HStack{
                            NavigationLink {
                                SettingsView(gameData: gameData, gameViewModel: gameViewModel)
                            } label: {
                                ZStack{
                                    Circle()
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.075, height: g.size.width * 0.075)
                                    
                                    Image(systemName: "gear")
                                        .foregroundStyle(.white)
                                        .font(.title)
                                }
                                .padding(.top, g.size.height * 0.1)

                            }

                            Spacer()
                                .frame(width: g.size.width * 0.8)
                                
                            ZStack{

                                Capsule()
                                    .foregroundStyle(.black)
                                    .opacity(0.5)
                                    .frame(width: g.size.width * 0.13, height: g.size.width * 0.06)

                                HStack{
                                    Image("coin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.04, height: g.size.width * 0.04)

                                    Text("\(gameData.coins)")
                                        .foregroundStyle(.white)
                                        .font(.title3)

                                }
                                .frame(width: g.size.width * 0.15, height: g.size.width * 0.06)

                            }
                            .padding(.top, g.size.height * 0.1)

                        }
//                            .padding(.top, g.size.height * 0.1)
                        ,alignment: .top


                    )

                    .frame(width: g.size.width, height: g.size.height)


                }
                

            }
            
        } else {
            NavigationView {
                ZStack(alignment: .bottom) {
                    
                }
            }
        }
    }
    
}

#Preview {
    MainMenuView()
}
