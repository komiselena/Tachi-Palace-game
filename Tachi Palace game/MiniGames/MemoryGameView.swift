//
//  MemoryMatchView.swift
//  Lucky Eagle Game
//
//  Created by Mac on 26.04.2025.
//

import SwiftUI

struct MemoryGameView: View {
    @StateObject private var game = MemoryGame(images: ["rubin", "_Group_-4", "heart", "shop", "redFlag"])
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var gameData: GameData
    @State private var remainingAttempts = 5
    @State private var timeLeft = 45
    @State private var showReward = false
    @State private var timer: Timer?
    @ObservedObject var gameViewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundView
                    .frame(width: geometry.size.width , height: geometry.size.height)

                mainContent(geometry: geometry)

                overlayViews(g: geometry)
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
    
        // MARK: - Subviews
    
    private var backgroundView: some View {
        Image("BG")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    private func mainContent(geometry: GeometryProxy) -> some View {
        let isIPad = UIDevice.current.userInterfaceIdiom == .pad

        return VStack{
            livesView(geometry: geometry)
            cardsGridView(geometry: geometry)
                .scaleEffect(isIPad ? 0.8 : 1.0)
        }
        .frame(height: geometry.size.height * 0.9)


    }
    
    
    private func livesView(geometry: GeometryProxy) -> some View {
        HStack(spacing: 10) {
            Spacer()
            ForEach(0..<5, id: \.self) { index in
                Image("heart")
                    .resizable()
                    .scaledToFit()
                    .opacity(index < remainingAttempts ? 1.0 : 0.5)
                    .frame(width: geometry.size.width * 0.08, height: geometry.size.width * 0.08)
            }
            Spacer()
        }
        .frame(width: geometry.size.width * 0.5, height: geometry.size.height * 0.2)

    }
    
    private func cardsGridView(geometry: GeometryProxy) -> some View {
        VStack {
            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            let cardWidth = geometry.size.width * 0.38
            let cardHeight = cardWidth * (UIImage(named: "Card")?.size.height ?? 1) / (UIImage(named: "Card")?.size.width ?? 1)
            
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(Array(game.cards.enumerated()), id: \.element.id) { index, card in
                    CardView(card: card, geometry: geometry)
                        .frame(width: cardWidth, height: cardHeight)
                        .onTapGesture {
                            handleCardTap(index)
                        }
                }
            }
        }
        .frame(height: geometry.size.height * 0.6)
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
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
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
    
    // Рассчитываем размеры на основе изображения "Card"
    private var cardSize: CGSize {
        let width = geometry.size.width * 0.38
        let height = width * (UIImage(named: "Card")?.size.height ?? 1) / (UIImage(named: "Card")?.size.width ?? 1)
        return CGSize(width: width, height: height)
    }
    
    var body: some View {
        ZStack {
            Group {
                if flipped {
                    // Лицевая сторона карточки (градиент + изображение)
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        
                        Image(card.imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: cardSize.width * 0.35)
                    }
                    .frame(width: cardSize.width, height: cardSize.height)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                } else {
                    // Обратная сторона карточки (изображение "Card")
                    Image("Card")
                        .resizable()
                        .scaledToFit()
                        .frame(width: cardSize.width, height: cardSize.height)
                }
            }
            .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
            .scaleEffect(scale)
        }
//        .frame(width: cardSize.width, height: cardSize.height)
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

// В cardsGridView:
// Кастомная форма, повторяющая контуры изображения карточки
struct ImageMaskShape: Shape {
    let imageName: String
    
    func path(in rect: CGRect) -> Path {
        // Здесь нужно создать Path, который повторяет форму вашей картинки "Card"
        // Для простоты используем закругленный прямоугольник с теми же параметрами, что и у картинки
        let cornerRadius: CGFloat = 10
        return Path(roundedRect: rect, cornerRadius: cornerRadius)
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

