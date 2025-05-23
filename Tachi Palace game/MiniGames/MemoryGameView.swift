//
//  MemoryMatchView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var game = MemoryGame(images: ["triangle", "triangle2", "romb", "star", "Ellipse", "rec"])
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @State private var remainingAttempts = 5
    @State private var timeLeft = 45
    @State private var showReward = false
    @State private var timer: Timer?
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("bg")
                    .resizable()
                    .ignoresSafeArea()

                
                mainContent(g: g)

            }
            .frame(width: g.size.width , height: g.size.height)


        }

        .navigationBarBackButtonHidden()
    }
    
        // MARK: - Subviews

    private func mainContent(g: GeometryProxy) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad

        return VStack{
            HStack(spacing: 0){
                Button {
                    dismiss()
                } label: {
                    BackButton()
                }
                
                Text("Find A Pair")
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
                if game.lostMatch {
                    VStack(){
                        livesView(geometry: g)
                        Text("Incorrect!!!")
                            .foregroundStyle(.white)
                            .font(.title)
                        HStack{
                            Button {
                                game.restartGame()
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

                } else if game.allMatchesFound{
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

                            Button {
                                game.restartGame()
                            } label: {
                                ZStack{
                                    Circle()
                                        .foregroundStyle(.red)
                                        .frame(width: g.size.width * 0.1, height: g.size.width * 0.1)
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                }
                            }

                        }
                    }
                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.55)

                } else{
                    VStack{
                        livesView(geometry: g)
                        cardsGridView(geometry: g)
                            .scaleEffect(isIPad ? 0.8 : 1.0)
                    }
                    .frame(width: g.size.width * 0.6, height: g.size.height * 0.5)

                }
            }
        }
        .frame(height: g.size.height * 0.9)


    }
    
    
    private func livesView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 10) {
            Spacer()
            ForEach(0..<5, id: \.self) { index in
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.white)
                        .opacity(0.5)
                        .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
                    Image(systemName: "xmark")
                        .opacity(index < remainingAttempts ? 0.0 : 1.0)
                        .font(.title.weight(.bold))
                }
            }
            Spacer()
        }
        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)

    }
    
    private func cardsGridView(geometry: GeometryProxy) -> some View {
        VStack {
            let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(game.cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card, geometry: geometry)
                        .onTapGesture {
                            handleCardTap(index)
                        }
                }
            }
        }
        .frame(width: geometry.size.width * 0.6, height: geometry.size.height * 0.4)
    }


    private func overlayViews(g: GeometryProxy) -> some View {
        Group {
            if game.lostMatch {
                lostMatchView(g: g)
            } else if game.allMatchesFound {
                ZStack{
                    Color.black
                        .opacity(0.5)
                        .ignoresSafeArea()
                    ZStack{
                        RoundedRectangle(cornerRadius: 25)
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
                                gameData.addCoins(20)
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
    }
    
    private func lostMatchView(g: GeometryProxy) -> some View {
        ZStack{
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            ZStack{
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: g.size.width * 0.7, height: g.size.height * 0.7)
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

    }
    
    // MARK: - Game Logic
    
    private func handleCardTap(_ index: Int) {
        guard !showReward else { return }
        
        let previousMatched = game.cards.filter { $0.isMatched }.count
        game.flipCard(at: index)
        let currentMatched = game.cards.filter { $0.isMatched }.count
        
        if currentMatched == previousMatched && game.indexOfFirstCard == nil {
            remainingAttempts -= 1
        }
        
        checkGameEnd()
    }
    
    
    private func checkGameEnd() {
        if game.cards.allSatisfy({ $0.isMatched }) {
            game.allMatchesFound = true
            gameData.addCoins(30)
        } else if remainingAttempts <= 0 {
            game.lostMatch = true
        }
    }
    
}


struct CardView: View {
    var card: Card
    @State private var flipped = false
    @State private var rotation = 0.0
    @State private var scale = 1.0
    @State var geometry: GeometryProxy
    
    
    var body: some View {
        ZStack {
            Group {
                if flipped {
                    // Лицевая сторона карточки (градиент + изображение)
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(.black)
                            .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.12)

                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.05, height: geometry.size.width * 0.05)
                    }
                    .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.12)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                } else {
                    // Обратная сторона карточки (изображение "Card")
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(.black)
                        .frame(width: geometry.size.width * 0.13, height: geometry.size.height * 0.12)
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
        }
        .onChange(of: card.isFlipped || card.isMatched) { newValue in
            flipCard(to: newValue)
        }
    }
    
    private func flipCard(to isFlipped: Bool) {
        withAnimation(.easeInOut(duration: 0.2)) {
            rotation = 90
            scale = 1.05
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            flipped = isFlipped
            withAnimation(.easeInOut(duration: 0.2)) {
                rotation = 0
                scale = 1.0
            }
        }
    }
}


// В cardsGridView измените расчет размеров:
extension AnyTransition {
    static var flipFromLeft: AnyTransition {
        .modifier(
            active: FlipEffect(angle: 90),
            identity: FlipEffect(angle: 0)
        )
    }
}

struct FlipEffect: ViewModifier {
    var angle: Double

    func body(content: Content) -> some View {
        content
            .rotation3DEffect(
                .degrees(angle),
                axis: (x: 0, y: 1, z: 0)
            )
            .animation(.easeInOut(duration: 0.3), value: angle)
    }
}

