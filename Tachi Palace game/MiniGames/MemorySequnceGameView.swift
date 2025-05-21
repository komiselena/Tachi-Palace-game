//
//  MemorySequnceGameView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 27.04.2025.
//


import SwiftUI

struct MemorySequnceGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @ObservedObject var gameData: GameData
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("BG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 10) {

                    VStack(spacing: 0) {
                        if viewModel.showingSequence {
                            if let card = viewModel.showCard {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: g.size.width * 0.7, height: g.size.width * 0.55)
                                    
                                    Image(card)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: g.size.width * 0.35, height:  g.size.width * 0.35)
                                        .transition(.scale)
                                }
                            }
                        } else {
                            let columns = [GridItem(.flexible()), GridItem(.flexible())]
                            let availableHeight = g.size.height * 0.6
                            let spacing: CGFloat = 10
                            let rows: CGFloat = 5
                            let cardHeight = (availableHeight - (spacing * (rows - 1))) / rows
                            
                            LazyVGrid(columns: columns, spacing: spacing) {
                                ForEach(["rubin", "_Group_-4", "heart", "shop", "redFlag", "Achievs", "battle", "flag", "bomb", "coin"], id: \.self) { card in
                                    Button {
                                        viewModel.selectCard(card)
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .frame(width: g.size.width * 0.38, height: cardHeight)

                                            Image(card)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.2, height: cardHeight * 0.6)

                                        }
                                    }
                                }
                            }
                        }
                    }
                    .frame(height: g.size.height * 0.6)
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height)
            .overlay{
                if viewModel.isGameOver && viewModel.isWon == false {
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
                                .frame(width: g.size.width * 0.7, height: g.size.height * 0.3)
                            VStack{
                                Text("Game Over")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 34, weight: .bold))
                                    .padding()
                                Button {
                                    dismiss()
                                    
                                } label: {
                                    ZStack{
                                        Capsule()
                                            .foregroundStyle(.white)
                                            .frame(width: g.size.width * 0.6, height: g.size.width * 0.15)
                                        Text("Home")
                                            .foregroundStyle(.black)
                                            .font(.system(size: 24, weight: .bold))
                                        
                                        
                                    }
                                    
                                }
                                
                                
                                
                            }
                            .frame(width: g.size.width * 0.7, height: g.size.height * 0.3)
                            
                        }
                    }


                } else if viewModel.isGameOver && viewModel.isWon {
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
            .onChange(of: viewModel.isWon) { newValue in
                if viewModel.isGameOver && viewModel.isWon {
                    gameData.addCoins(30)
                }
            }

            
            .onAppear {
                viewModel.startGame()
            }
            .animation(.easeInOut, value: viewModel.showCard)
            
            
            
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


#Preview {
    MemorySequnceGameView(gameData: GameData(), gameViewModel: GameViewModel())
}
