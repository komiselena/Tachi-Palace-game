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
                Image("bg")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 10) {
                    HStack(spacing: 0){
                        Button {
                            dismiss()
                        } label: {
                            BackButton()
                        }
                        
                        Text("Memory Aid")
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
                        
                        
                        if viewModel.isGameOver && viewModel.isWon == false {
                            VStack{
                                HStack(spacing: 5) {
                                    ForEach(0..<viewModel.sequence.count, id: \.self) { index in
                                        ZStack {
                                            // Фон - пустой квадрат
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.white)
                                                .opacity(0.5)
                                                .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                            
                                            // Если пользователь уже ввел карточку на этой позиции - показываем ее
                                            if index < viewModel.userInput.count {
                                                Image(viewModel.userInput[index])
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                            }
                                        }
                                    }
                                }
                                .frame(height: g.size.width * 0.08)

                                Text("Incorrect!!!")
                                    .foregroundStyle(.white)
                                    .font(.title)
                                HStack{
                                    Button {
                                        dismiss()
                                    } label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.25, height: g.size.width * 0.1)
                                            Text("Retry")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }

                                    }

                                }
                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)

                        } else if viewModel.isGameOver && viewModel.isWon {
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
                                        ZStack{
                                            Circle()
                                                .foregroundStyle(.red)
                                                .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                            Image(systemName: "house")
                                                .font(.title)
                                                .foregroundStyle(.white)
                                        }
                                    }


                                }
                            }
                            .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)


                        } else {
                            VStack(spacing: 0) {
                                if viewModel.showingSequence {
                                    if let card = viewModel.showCard {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: g.size.width * 0.3, height: g.size.width * 0.2)
                                            
                                            Image(card)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: g.size.width * 0.15, height:  g.size.width * 0.15)
                                                .transition(.scale)
                                        }
                                    }
                                } else {
                                    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                                    let spacing: CGFloat = 10
                                    
                                    VStack {
                                        // Отображаем ряд квадратов по количеству элементов в последовательности
                                        HStack(spacing: 5) {
                                            ForEach(0..<viewModel.sequence.count, id: \.self) { index in
                                                ZStack {
                                                    // Фон - пустой квадрат
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .foregroundStyle(.white)
                                                        .opacity(0.5)
                                                        .frame(width: g.size.width * 0.08, height: g.size.width * 0.08)
                                                    
                                                    // Если пользователь уже ввел карточку на этой позиции - показываем ее
                                                    if index < viewModel.userInput.count {
                                                        Image(viewModel.userInput[index])
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: g.size.width * 0.06, height: g.size.width * 0.06)
                                                    }
                                                }
                                            }
                                        }
                                        .frame(height: g.size.width * 0.08)
                                        
                                        
                                        LazyVGrid(columns: columns, spacing: spacing) {
                                            ForEach(["triangle", "triangle2", "romb", "star", "Ellipse", "rec", "rec2", "star3"], id: \.self) { card in
                                                Button {
                                                    viewModel.selectCard(card)
                                                } label: {
                                                    ZStack{
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .foregroundStyle(.black)
                                                            .frame(width: g.size.width * 0.13, height: g.size.height * 0.12)
                                                        
                                                        Image(card)
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: g.size.width * 0.05, height: g.size.width * 0.05)
                                                        
                                                    }
                                                }
                                            }
                                        }
                                        .frame(width: g.size.width * 0.6, height: g.size.height * 0.4)
                                    }
                                    
                                }
                            }
                            .frame(height: g.size.height * 0.6)
                        }
                    }
                }
                .frame(width: g.size.width * 0.9, height: g.size.height * 0.9)


            }
            .frame(width: g.size.width , height: g.size.height)
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

        .navigationBarBackButtonHidden()

    }
}


#Preview {
    MemorySequnceGameView(gameData: GameData(), gameViewModel: GameViewModel())
}
