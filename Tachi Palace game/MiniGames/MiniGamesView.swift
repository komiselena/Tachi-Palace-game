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

    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("BG")
                    .resizable()
                    .ignoresSafeArea()
                
                
                VStack(alignment: .center, spacing: 10){
                    Spacer()
                    NavigationLink {
                        GuessNumberView(gameData: gameData, gameViewModel: gameViewModel)
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.12)
                            HStack{
                                Text("Numbers")
                                    .foregroundStyle(.white)
                                    .font(.title2.weight(.bold)) // Uses iOS's default title size + heavy weight
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.15)
                            
                        }
                    }
                    NavigationLink {
                        MemoryGameView(gameData: gameData, gameViewModel: gameViewModel)
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.12)
                            HStack{
                                Text("Cards")
                                    .foregroundStyle(.white)
                                    .font(.title2.weight(.bold)) // Uses iOS's default title size + heavy weight
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.15)
                            
                        }
                    }
                    NavigationLink {
                        MemorySequnceGameView(gameData: gameData, gameViewModel: gameViewModel)
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.12)
                            HStack{
                                Text("Simon Says")
                                    .foregroundStyle(.white)
                                    .font(.title2.weight(.bold)) // Uses iOS's default title size + heavy weight
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.15)
                            
                        }
                    }
                    NavigationLink {
                        MazeView(gameData: gameData, gameViewModel: gameViewModel)
                    } label: {
                        ZStack{
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: g.size.width * 0.9 , height: g.size.height * 0.12)
                            HStack{
                                Text("Maze")
                                    .foregroundStyle(.white)
                                    .font(.title2.weight(.bold)) // Uses iOS's default title size + heavy weight
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundStyle(.white)
                            }
                            .frame(width: g.size.width * 0.8, height: g.size.height * 0.15)
                            
                        }
                    }
                    
                    Spacer()
                }
                
            }
            .frame(width: g.size.width, height: g.size.height )

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
}

//#Preview {
//    MiniGamesView()
//}
