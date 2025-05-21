//
//  MazeView.swift
//  Potawatomi tribe game
//
//  Created by Mac on 12.05.2025.
//

import SwiftUI
import SpriteKit

struct MazeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var scene: MazeGameScene

    @ObservedObject var gameData: GameData
    @State private var timeLeft = 90
    @State private var timer: Timer?
    @State private var showWin = false
    @ObservedObject var gameViewModel: GameViewModel

    init(gameData: GameData, gameViewModel: GameViewModel) {
        self.gameData = gameData
        self.gameViewModel = gameViewModel
        let scene = MazeGameScene(size: CGSize(width: 196, height: 196))
        scene.onGameWon = {
            scene.isWon = true
        }
        self._scene = StateObject(wrappedValue: scene)
    }

    var body: some View {
        GeometryReader { g in
            ZStack{
                Image("BG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                
                VStack(spacing: 0) {
                    
                    
                    VStack(spacing: 30){
                        SpriteView(scene: scene)
                            .frame(width: g.size.width * 0.7, height: g.size.width * 0.7)
                            .border(Color.white)
//                            .padding(.leading, 20)
                        
                        VStack(spacing: 10){
                            // up
                            Button(action: { scene.movePlayer(dx: 0, dy: scene.moveStep) }) {
                                ZStack{
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: g.size.width * 0.2 , height: g.size.width * 0.2 )
                                    Image(systemName: "arrowtriangle.up.fill")
                                        .foregroundStyle(.white)
                                        .font(.title.weight(.bold))
                                    
                                }
                            }
                            HStack(spacing: 10) {
                                //left
                                Button(action: { scene.movePlayer(dx: -scene.moveStep, dy: 0) }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: g.size.width * 0.2 , height: g.size.width * 0.2 )
                                        Image(systemName: "arrowtriangle.left.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))

                                    }
                                }
                                //down
                                Button(action: { scene.movePlayer(dx: 0, dy: -scene.moveStep) }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: g.size.width * 0.2 , height: g.size.width * 0.2 )
                                        Image(systemName: "arrowtriangle.down.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))

                                    }
                                }
                                // right
                                Button(action: { scene.movePlayer(dx: scene.moveStep, dy: 0) }) {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 15)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [Color(hex: "#7C0A99"), Color(hex: "#440952")]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .frame(width: g.size.width * 0.2 , height: g.size.width * 0.2 )
                                        Image(systemName: "arrowtriangle.right.fill")
                                            .foregroundStyle(.white)
                                            .font(.title.weight(.bold))

                                    }
                                }
                            }
                        }

                        

                    }
//                    .padding(.bottom)

                    
                }
                .frame(width: g.size.width, height: g.size.height * 0.9)
                

            }
            .frame(width: g.size.width, height: g.size.height)
            .overlay{
                if scene.isWon {
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
                                    gameData.addCoins(30)
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
}

